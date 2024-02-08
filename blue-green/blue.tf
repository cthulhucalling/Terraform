resource "aws_instance" "blue" {
        count = var.blue_enable ? var.blue_instance_count : 0
        ami = data.aws_ami.amazon_linux.id
        instance_type = "t2.micro"
        subnet_id = aws_subnet.blue_subnet.id
        vpc_security_group_ids = [aws_security_group.allow-internal-network.id]
        user_data = templatefile("${path.module}/bootstrap.sh", {file_content = "version 1.0 - # ${count.index}"})
        iam_instance_profile = data.aws_iam_instance_profile.SSM.name
        depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_lb_target_group" "blue" {
        name = "tg-blue"
        port = 80
        protocol = "HTTP"
        vpc_id = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "blue" {
        count = length(aws_instance.blue)
        target_group_arn = aws_lb_target_group.blue.arn
        target_id = aws_instance.blue[count.index].id
        port = 80
}
