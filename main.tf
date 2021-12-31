provider "aws" {
    region = "us-east-1"
  
}


resource "aws_instance" "ec2-vm" {
   ami             = "ami-0ed9277fb7eb570c9"
   instance_type   = "t3.micro"
   associate_public_ip_address = true
   vpc_security_group_ids = [aws_security_group.sg.id]
   subnet_id = aws_subnet.subnet.id
   user_data       = fileexists("script.sh") ? file("script.sh") : null
   tags = {
       Name = "workspace-ec2"
   }
}
