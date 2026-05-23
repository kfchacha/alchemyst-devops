output "gateway_public_ip" {
  value = aws_instance.gateway.public_ip
}

output "caller_private_ip" {
  value = aws_instance.caller.private_ip
}

output "inference_private_ip" {
  value = aws_instance.inference.private_ip
}
