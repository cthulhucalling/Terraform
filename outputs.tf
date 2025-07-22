output "instance_public_ip" {
	description = "Public IP of instance"
	value = aws_instance.my_proxy.public_ip
}
