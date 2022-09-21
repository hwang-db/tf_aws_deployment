# tf_aws_deployment
Terraform patterns for aws deployments and aws Databricks

Subdirectories are independent to each other, each represents a Terraform pattern of AWS Databricks workspace deployment.

AWS Databricks deployment patterns:
1. `aws_databricks_modular`, multiple workspaces deployment into your VPC: https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_databricks_e2_modular
2. `aws_databricks_modular_privatelink`, multiple workspaces deployment, CMK, VPC, Privatelinks: https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_databricks_modular_privatelink
3. `aws_remote_backend_infra`, dedicated project to manage remote S3 backend infra: S3, DynamoDB table: https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_remote_backend_infra
4. `aws_workspace_config`, dedicated project to manage workspace objects including ip access list: https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_workspace_config