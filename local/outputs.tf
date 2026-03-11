output "tomcat_url" {
  description = "Local URL for the Tomcat web server (equivalent to AWS instance_public_ip / Azure vm_public_ip)"
  value       = "http://localhost:${var.tomcat_port}"
}

output "tomcat_container_id" {
  description = "Docker container ID of the Tomcat instance (equivalent to AWS instance ARN / Azure vm_id)"
  value       = docker_container.web.id
}

output "minio_s3_api_url" {
  description = "MinIO S3-compatible API endpoint (equivalent to AWS S3 bucket URL / Azure storage_account_primary_blob_endpoint)"
  value       = "http://localhost:${var.minio_port}"
}

output "minio_console_url" {
  description = "MinIO web console — manage buckets and objects via a browser UI"
  value       = "http://localhost:${var.minio_console_port}"
}

output "minio_bucket_name" {
  description = "Name of the MinIO bucket (equivalent to AWS s3_bucket_name / Azure storage_account_name)"
  value       = var.minio_bucket_name
}

output "minio_access_key" {
  description = "MinIO root user (use as AWS_ACCESS_KEY_ID when connecting S3-compatible clients)"
  value       = var.minio_root_user
}

output "minio_secret_key" {
  description = "MinIO root password (use as AWS_SECRET_ACCESS_KEY when connecting S3-compatible clients)"
  value       = var.minio_root_password
  sensitive   = true
}

output "docker_network_name" {
  description = "Name of the shared Docker bridge network (equivalent to AWS VPC / Azure VNet)"
  value       = docker_network.main.name
}

output "docker_volume_name" {
  description = "Name of the Docker volume used for MinIO persistent storage"
  value       = docker_volume.minio_data.name
}
