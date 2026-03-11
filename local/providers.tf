terraform {
  required_version = ">= 1.3.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Connects to the local Docker daemon via the Unix socket.
# On Windows/Mac with Docker Desktop, change host to:
#   host = "npipe:////.//pipe//docker_engine"  # Windows
#   host = "unix:///var/run/docker.sock"        # Mac (default)
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
