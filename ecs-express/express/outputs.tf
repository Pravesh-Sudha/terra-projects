output "express_service_arn" {
  description = "ECS Express service ARN"
  value       = aws_ecs_express_gateway_service.portfolio.service_arn
}

output "express_service_revision_arn" {
  description = "Current Express service revision ARN"
  value       = aws_ecs_express_gateway_service.portfolio.service_revision_arn
}

output "ingress_paths" {
  description = "Express Mode ingress information"
  value       = aws_ecs_express_gateway_service.portfolio.ingress_paths
}