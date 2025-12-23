aws_region = "ap-south-1"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
vpc_az = ["ap-south-1a", "ap-south-1b"]
ecr_repo_name = ["app/appointment-service", "app/patient-service"]
environment = "dev"


lambda_functions = {
	patient_service = {
		ecr_repository = "app/patient-service"
		timeout     = 900
		memory_size = 512
	}

	appointment_service = {
		ecr_repository = "app/appointment-service"
		timeout     = 900
		memory_size = 512
	}
}
