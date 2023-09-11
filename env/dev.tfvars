### Common configurations
region   = "ap-southeast-1"
app_name = "fastapp"
env      = "dev"

### VPC configurations
vpc_cidr_block            = "10.0.0.0/16"
availability_zones        = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets_cidr_block = ["10.10.1.0/24", "10.10.2.0/24"]

### Service configurations
app_service = {
  name           = "detect-app"
  host_port      = 80
  container_port = 80
  cpu            = 512
  memory         = 1024
  desired_count  = 1

  autoscaling = {
    max_capacity = 3
    min_capacity = 1
    cpu = {
      target_value = 70
    }
  }
}
