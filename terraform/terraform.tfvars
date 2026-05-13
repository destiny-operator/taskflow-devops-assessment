aws_region         = "us-east-1"
environment        = "production"
project_name       = "taskflow"
instance_type      = "t3.micro"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
docker_image       = "sailor4/taskflow-app:latest"
allowed_ssh_cidr   = ["0.0.0.0/0"]
