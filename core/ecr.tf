resource "aws_ecr_repository" "ecr" {
  for_each = toset(var.ecr_repo_name)
  name     = "${each.value}-${var.environment}"
  tags = {
    Name = "${each.value}-${var.environment}"
  }
}
