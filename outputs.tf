output "patient_service" {
  value = aws_ecr_repository.ecr["app/patient-service"].name
}
output "appointment_service" {
  value = aws_ecr_repository.ecr["app/appointment-service"].name
}
