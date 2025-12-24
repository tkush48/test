output "patient_service" {
  value = aws_ecr_repository.ecr["app/patient-service"].name
}
output "appointment_service" {
  value = aws_ecr_repository.ecr["app/appointment-service"].name
}
output "private_subnet_ids" {
	value = aws_subnet.private[*].id
}
output "vpc_id" {
	value = aws_vpc.main.id
}