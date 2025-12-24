output "patient_service" {
  value = aws_ecr_repository.ecr["app/patient-service"].repository_url
}
output "appointment_service" {
  value = aws_ecr_repository.ecr["app/appointment-service"].repository_url
}
output "private_subnet_ids" {
	value = aws_subnet.private[*].id
}
output "vpc_id" {
	value = aws_vpc.main.id
}
output "ecr_repository_urls" {
	value = {for k,v in aws_ecr_repository.ecr : k => v.repository_url}
}
