# AWS region information

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Define the server hostname variable
variable "serverHostname" {
  type = string

  # Change this variable to set the server hostname in AWS
  default = "server"
}
data "aws_ssm_parameter" "linuxAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Define the ec2 instance resource
# user_data points to the boostrap script used to deploy the instnace
resource "aws_instance" "ec2_server" {
  count                  = 2
  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t2.micro"
  key_name               = "PrivateKey"
  vpc_security_group_ids      = ["sg-0fe5e83bec8403da5"]
  subnet_id                   = "subnet-016797eb5e4da658c"
  user_data                   = fileexists("script.sh") ? file("script.sh") : null
  # Set the correct instance name in AWS
  tags = {
    Name = "${format("%s%02s", var.serverHostname, count.index + 1)}"
  }

}

# Output the IP address of the instance after provisioning
output "instance_ip" {
  description = "VM's public IP"
  value       = aws_instance.ec2_server.*.public_ip
}
