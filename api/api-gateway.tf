resource "aws_apigatewayv2_api" "apigw" {
	name = "api-${var.environment}"
	protocol_type = "HTTP"
	
	tags = {
		Name = "api-${var.environment}"
	}
}

resource "aws_apigatewayv2_stage" "apigw_stage" {
	api_id = aws_apigatewayv2_api.apigw.id
	name = var.environment
	auto_deploy = true
	
	access_log_settings {
		destination_arn = aws_cloudwatch_log_group.apigw_lg.arn
		format = jsonencode({
			requestId = "$context.requestId"
			ip = "$context.identity.sourceIp"
			requestTime = "$context.requestTime"
			httpMethod = "$context.httpMethod"
			protocol = "$context.protocol"
		})
	}

	tags = {
		Name = "stage-${var.environment}"
	}
}

resource "aws_cloudwatch_log_group" "apigw_lg" {
	name = "/aws/apigateway/${var.environment}"
}

resource "aws_apigatewayv2_integration" "patient_lambda" {
	api_id = aws_apigatewayv2_api.apigw.id
	integration_type = "AWS_PROXY"
	integration_uri = aws_lambda_function.lambda_function["patient_service"].invoke_arn
	integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "appointment_lambda" {
	api_id = aws_apigatewayv2_api.apigw.id
	integration_type = "AWS_PROXY"
	integration_uri = aws_lambda_function.lambda_function["appointment_service"].invoke_arn
	integration_method = "POST"
}

resource "aws_apigatewayv2_route" "patient_srv_routes" {
	for_each = toset([
		"GET /patients",
		"GET /patients/{id}",
		"POST /patients"
		])
		
	api_id = aws_apigatewayv2_api.apigw.id
	route_key = each.value
	target = "integrations/${aws_apigatewayv2_integration.patient_lambda.id}"
}

resource "aws_apigatewayv2_route" "appointment_srv_routes" {
	for_each = toset([
		"GET /health",
		"GET /appointments",
		"GET /appointments/{id}",
		"POST /appointments",
		"POST /appointments/patient/{patientId}"
		])
		
	api_id = aws_apigatewayv2_api.apigw.id
	route_key = each.value
	target = "integrations/${aws_apigatewayv2_integration.appointment_lambda.id}"
}

resource "aws_lambda_permission" "patient_api" {
	statement_id = "AllowAPIgwInvoke"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.lambda_function["patient_service"].function_name
	principal = "apigateway.amazonaws.com"
	source_arn = "${aws_apigatewayv2_api.apigw.execution_arn}/*/*"
}

resource "aws_lambda_permission" "appointment_api" {
	statement_id = "AllowAPIgwInvoke"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.lambda_function["appointment_service"].function_name
	principal = "apigateway.amazonaws.com"
	source_arn = "${aws_apigatewayv2_api.apigw.execution_arn}/*/*"
}
