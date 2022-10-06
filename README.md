# Terraform patterns for AWS Databricks deployments

Subdirectories are independent to each other, each represents a Terraform pattern of AWS Databricks workspace deployment.

AWS Databricks deployment patterns:
1. [aws_databricks_modular](https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_databricks_modular): multiple workspaces deployment into your VPC
2. [aws_databricks_modular_privatelink](https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_databricks_modular_privatelink): multiple workspaces deployment, CMK, VPC, Privatelinks
3. [aws_databricks_unity_catalog](https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_databricks_unity_catalog): deploys account level unity catalog related infra and resources such as account users/groups, to be run using account admin's credentials
4. [aws_databricks_unity_catalog_bootstrap](https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_databricks_unity_catalog_bootstrap): to be run with account owner's credentials, to generate account admins as the first step of unity catalog onboarding
5. [aws_remote_backend_infra](https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_remote_backend_infra): dedicated project to manage remote S3 backend infra: S3, DynamoDB table
6. [aws_workspace_config](https://github.com/hwang-db/tf_aws_deployment/tree/main/aws_workspace_config): dedicated project to manage workspace objects including ip access list