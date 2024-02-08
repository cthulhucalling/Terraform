resource "aws_instance" "green" {
        count = var.green_enable ? var.green_instance_count : 0
        ami = data.aws_ami.amazon_linux.id
        instance_type = "t2.micro"
        subnet_id = aws_subnet.green_subnet.id
        vpc_security_group_ids = [aws_security_group.allow-internal-network.id]
        user_data = templatefile("${path.module}/bootstrap.sh", {file_content = "version 1.1 - # ${count.index}"})
        iam_instance_profile = data.aws_iam_instance_profile.SSM.name
        depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_lb_target_group" "green" {
        name = "tg-green"
        port = 80
        protocol = "HTTP"
        vpc_id = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "green" {
        count = length(aws_instance.green)
        target_group_arn = aws_lb_target_group.green.arn
        target_id = aws_instance.green[count.index].id
        port = 80
}
