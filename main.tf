provider "aws" {
  region = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "ec2-vm" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = "t3.micro"
  key_name                    = "PrivateKey"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id
  user_data                   = fileexists("script.sh") ? file("script.sh") : null
  connection {
    user        = var.EC2_USER
    private_key = file("${var.PRIVATE_KEY_PATH}")
  }
  tags = {
    Name = "main-ec2"
  }
}
output "instace_ip" {
  value = aws_instance.ec2-vm.*.public_ip
}
