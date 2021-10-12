resource "aws_ecs_cluster" "main" {
  name = "${local.cluster_name}-cluster-${var.env}"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${local.cluster_name}-container-${var.env}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${local.cluster_name}-container-${var.env}"
    image     = "amazon/amazon-ecs-sample"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
}

