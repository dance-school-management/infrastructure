# Infrastracture

## S3 bucket - dev purposes
If you want to create S3 bucket on your account:
- register free tier AWS account
- install AWS cli https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- install terraform cli https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
- configure AWS credentials to be able to perform `terraform apply`
- it could be very complicated or very easy, i would suggest to create User via AWS console with wide spectrum of permissions (for example AdministratorAccess)
- then generate access keys
- enter them locally with aws cli 
- thanks to that terraform will be able to perform operations
- use terraform in current directory (it will create resources based on `s3.tf` file)
- after you finish working to save money use `terraform destroy`
- RENAME s3-bucket in s3.tf as it has to be unique

Create env variables for example in product-microservice:
`sh create_s3_dev.sh "../backend/product-microservice/"`