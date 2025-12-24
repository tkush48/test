aws_region = "ap-south-1"
environment = "dev"
lambda_functions = {
	patient_service = {
		timeout     = 900
		memory_size = 512
	}

	appointment_service = {
		timeout     = 900
		memory_size = 512
	}
}
