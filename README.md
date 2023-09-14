# ECS Infrastructure for Pose Detection - Infrastructure as Code

## Infrastructure

![image](https://github.com/falco2202/ecs_infrastructure/assets/82159331/cd7fc5e4-eea5-4115-a83e-64c7fac16ebc)

- Note: To reduce complexity and cost, I ran the container in the public subnet. (It is still best practice to keep container in the private subnet).

## Folder structure 
```
.
├── detect-model
|   ├── app
|   |      ├── __init__.py
|   |      ├── app.py
|   |      ├── yolov8n-pose.py             # Model pose detect image
|   ├── Dockerfile
|   ├── requirements.txt          
├── environment
|       ├── development                    # Infrastructure Dev environment
|       |      ├── main.tf
|       |      ├── variables.tf
|       |      ├── terraform.tfvars
|       |      ├── ...
|       ├── production                     # Infrastructure Production environment     
|       |      ├── main.tf
|       |      ├── variables.tf
|       |      ├── terraform.tfvars
|       |      ├── ...             
├── module
|   ├── acm
|   |    ├── main.tf
|   |    ├── variables.tf
|   |    ├── outputs.tf
|   ├── alb
|   ├── ecr
|   ├── ecs
|   ├── networking
|   ├── route53                 
├── .gitignore                   
├── LICENSE.md
└── README.md

```

## Usage repository
1. Clone repository
```bash
git clone https://github.com/falco2202/provision-detect-model.git
```
2. To add your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to Github secret, as well as your preferred `REGION` in Github variables.
3. Run job in GitHub action

## Load test
* Note: Application is tested for performance with ECS Fargate(task: 1 vCPU, 2GB Memory) and autoscaling (min: 2, max: 5)
* 
![image](https://github.com/falco2202/provision-detect-model/assets/82159331/dae6f5ab-5a68-4c19-97a7-7f0a4c4a8a30)

-> The server died with the 15 users and 13 requests/second

