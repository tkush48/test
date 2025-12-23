data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "lambda_ecr" {
	statement {
		effect = "Allow"
        actions = [
			"ecr:*"
		]
		resources = [
			for repo in aws_ecr_repository.ecr : repo.arn
		]
}
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
resource "aws_iam_policy" "lambda_ecr_policy" {
	name = "lambda-ecr-policy-${var.environment}"
	policy = data.aws_iam_policy_document.lambda_ecr.json
}
resource "aws_iam_role_policy_attachment" "lambda_ecr_pa" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_ecr_policy
}

resource "aws_lambda_function" "lambda_function" {
  for_each = var.lambda_functions

  function_name = "${each.key}-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "public.ecr.aws/lambda/nodejs:18" #dummy image for initialization
  #image_uri     = "${aws_ecr_repository.ecr[each.value.ecr_repository].repository_url}:LATEST"
  timeout       = each.value.timeout
  memory_size   = each.value.memory_size
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
  tags = {
    Name = "${each.key}-${var.environment}"
  }
  
  depends_on = [
	aws_iam_role_policy_attachment.lambda_basic,
	aws_iam_role_policy_attachment.lambda_vpc
	]
}


resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg-${var.environment}"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg-${var.environment}"
  }

}

resource "aws_cloudwatch_log_group" "lambda_lg" {
  for_each          = var.lambda_functions
  name              = "/aws/lambda/${each.key}-${var.environment}"
  retention_in_days = 7
}
