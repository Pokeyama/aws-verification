# EC2 public1c
resource "aws_instance" "hirayama-ec2-c" {
  ami                    = "ami-073770dc3242b2a06"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.hirayama_public_1c.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id, aws_security_group.vpc_all_sg.id]
  key_name               = var.key_name
  user_data              = file("install.sh")

  tags = {
    Name = "hirayama-ec2"
  }

}

# キーペア
resource "aws_key_pair" "hirayama-key-pair" {
  key_name   = var.key_name
  public_key = file("../${var.key_name}.pub")
}

# ssh用eip
resource "aws_eip" "hirayama-ec2-eip-c" {
  instance = aws_instance.hirayama-ec2-c.id
  vpc      = true
}

# EC2 public1d
resource "aws_instance" "hirayama-ec2-d" {
  ami                    = "ami-073770dc3242b2a06"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.hirayama_public_1d.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id, aws_security_group.vpc_all_sg.id]
  key_name               = var.key_name
  user_data              = file("install.sh")

  tags = {
    Name = "hirayama-ec2"
  }

}

# ssh用eip
resource "aws_eip" "hirayama-ec2-eip-d" {
  instance = aws_instance.hirayama-ec2-d.id
  vpc      = true
}