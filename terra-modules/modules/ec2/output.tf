output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the Instance: "

}
