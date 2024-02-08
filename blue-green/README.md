A few notes on how to Terraform. This was taken from Hashicorp's example on how to do a blue-green environment, but it doesn't work out of the box, and I added a few things.

The instance count variables work by using the 'count' Meta-argument. TF will create 'count' many copies of the hosts. If you set the count to 0, TF will destroy the EC2s in that particular group

The traffic-distribution variable takes input on startup, either interactively or through a -var passed at apply time. This gets compared to a map with the keys blue, blue-90, split, green-90, green, which tells the load balander how much to weigh traffic to the two environments.

The EC2s depend on the NAT gatway being up and running, and the subnets routing correctly. Otherwise, the user-data bootstrap script won't run.

**HOW TO LAUNCH AN EC2 IN TERRAFORM USING AN EXISTING IAM ROLE**

There's tons of documentation out there on having TF deploy a role for this but not a whole lot on how to deploy workloads with existing roles. Assuming you want to run the EC2s under a role that has the basic SSM permissions (SSMRoleforManagedHosts) so you can connect to them, here is how it's done:

In variables.tf
```
data "aws_iam_instance_profile" "my-ssm-role" {
  name = "SSMRoleforManagedHosts"
}
```
You want a data object so TF queries AWS for the role information
When you create an EC2 instance
```
resource "aws_instance" "my-ec2" {
        ami = data.aws_ami.amazon_linux.id
        instance_type = "t2.micro"
        subnet_id = aws_subnet.blue_subnet.id
        iam_instance_profile = data.aws_iam_instance_profile.my-ssm-role.name
}
```
That's it. Seriously. I don't know why it's so difficult to find actual useful information on how to do this.
