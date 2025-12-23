output "patient_service" {
  value = aws_ecr_repository.ecr["app/patient-service"].name
}
output "appointment_service" {
  value = aws_ecr_repository.ecr["app/appointment-service"].name
}
output "lambda_functions_arns" {
  value = { for k, v in aws_lambda_function.lambda_function : k => v.arn }
}
output "lambda_functions_names" {
  value = { for k, v in aws_lambda_function.lambda_function : k => v.function_name }
}
output "lambda_role_arn" {
	value = aws_iam_role.lambda_role.arn
}
output "api_gateway_url" {
	value = aws_apigatewayv2_stage.apigw_stage.invoke_url
}