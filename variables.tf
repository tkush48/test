variable "environment" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "vpc_az" {
  type = list(string)
}
variable "ecr_repo_name" {
  type = list(string)
}
variable "lambda_functions" {
  type = map(object({
    ecr_repository = string
    timeout        = number
    memory_size    = number
  }))
}
