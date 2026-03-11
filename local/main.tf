# ---------------------------------------------------------------------------
# Docker Network — shared bridge network for all local containers
# Equivalent to: AWS VPC / Azure Virtual Network
# ---------------------------------------------------------------------------
resource "docker_network" "main" {
  name   = "net-learning-${var.environment}"
  driver = "bridge"

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "project"
    value = "learning-terraform"
  }
}

# ---------------------------------------------------------------------------
# Image pulls
# ---------------------------------------------------------------------------
resource "docker_image" "tomcat" {
  name         = var.tomcat_image
  keep_locally = true
}

resource "docker_image" "minio" {
  name         = var.minio_image
  keep_locally = true
}

resource "docker_image" "minio_mc" {
  name         = var.minio_mc_image
  keep_locally = true
}

# ---------------------------------------------------------------------------
# Tomcat container — web server
# Equivalent to: aws_instance (Bitnami Tomcat AMI) / azurerm_linux_virtual_machine
# ---------------------------------------------------------------------------
resource "docker_container" "web" {
  name  = "tomcat-web-${var.environment}"
  image = docker_image.tomcat.image_id

  ports {
    internal = 8080
    external = var.tomcat_port
  }

  networks_advanced {
    name = docker_network.main.name
  }

  restart = "unless-stopped"

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "project"
    value = "learning-terraform"
  }
}

# ---------------------------------------------------------------------------
# MinIO persistent volume
# Equivalent to: EBS volume (AWS) / Azure Managed Disk
# ---------------------------------------------------------------------------
resource "docker_volume" "minio_data" {
  name = "minio-data-${var.environment}"

  labels {
    label = "environment"
    value = var.environment
  }
}

# ---------------------------------------------------------------------------
# MinIO container — S3-compatible local object storage
# Equivalent to: aws_s3_bucket / azurerm_storage_account
# Access the S3 API at http://localhost:9000
# Access the web console at http://localhost:9001
# ---------------------------------------------------------------------------
resource "docker_container" "minio" {
  name  = "minio-storage-${var.environment}"
  image = docker_image.minio.image_id

  # Start MinIO server and expose the web console on port 9001
  command = ["server", "/data", "--console-address", ":9001"]

  ports {
    internal = 9000
    external = var.minio_port
  }

  ports {
    internal = 9001
    external = var.minio_console_port
  }

  volumes {
    volume_name    = docker_volume.minio_data.name
    container_path = "/data"
  }

  networks_advanced {
    name = docker_network.main.name
  }

  env = [
    "MINIO_ROOT_USER=${var.minio_root_user}",
    "MINIO_ROOT_PASSWORD=${var.minio_root_password}",
  ]

  restart = "unless-stopped"

  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "15s"
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "project"
    value = "learning-terraform"
  }
}

# ---------------------------------------------------------------------------
# MinIO init container — creates and configures the bucket (one-shot)
# Equivalent to: aws_s3_bucket + aws_s3_bucket_versioning + aws_s3_bucket_public_access_block
#                / azurerm_storage_container
# This container runs once and exits; Terraform tracks it via must_run = false.
# ---------------------------------------------------------------------------
resource "docker_container" "minio_init" {
  name  = "minio-init-${var.environment}"
  image = docker_image.minio_mc.image_id

  # Wait for MinIO to be ready, then create the bucket with versioning enabled
  # and private access (no anonymous reads)
  command = [
    "/bin/sh", "-c",
    <<-EOT
      until mc alias set minio http://minio-storage-${var.environment}:9000 "${var.minio_root_user}" "${var.minio_root_password}" > /dev/null 2>&1; do
        echo "Waiting for MinIO to be ready..."; sleep 3;
      done
      mc mb --ignore-existing minio/${var.minio_bucket_name}
      mc version enable minio/${var.minio_bucket_name}
      mc anonymous set none minio/${var.minio_bucket_name}
      echo "Bucket '${var.minio_bucket_name}' is ready."
    EOT
  ]

  networks_advanced {
    name = docker_network.main.name
  }

  # must_run = false means Terraform won't try to keep this container running
  must_run = false

  depends_on = [docker_container.minio]
}
