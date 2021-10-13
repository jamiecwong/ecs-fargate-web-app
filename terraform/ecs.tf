locals {
  container_name = "${local.cluster_name}-nginx-${var.env}"
}

resource "aws_ecs_cluster" "this" {
  name = "${local.cluster_name}-cluster-${var.env}"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.cluster_name}-task-definition-${var.env}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = local.container_name
    image     = "nginxdemos/hello"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-region        = "eu-west-2"
        awslogs-group         = local.cluster_name
        awslogs-stream-prefix = local.container_name
      }
    }
  }])
}

resource "aws_cloudwatch_log_group" "this" {
  name              = local.cluster_name
  retention_in_days = 1
  tags              = { env = var.env }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${local.cluster_name}-ecsTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.cluster_name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
