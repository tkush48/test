variable "environment" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "lambda_functions" {
  type = map(object({
    timeout        = number
    memory_size    = number
  }))
}
