### Common configurations
region   = "ap-southeast-1"
app_name = "detect-ecs"
env      = "dev"

### VPC configurations
cidr               = "10.0.0.0/16"
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets     = ["10.10.1.0/24", "10.10.2.0/24"]

### ALB configurations
