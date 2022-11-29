# パブリックIPを出力 public1c
output "public1c_ip" {
  value = aws_instance.hirayama-ec2-c.public_ip
}

# パブリックIPを出力 public1d
output "public1d_ip" {
  value = aws_instance.hirayama-ec2-d.public_ip
}

# sshコマンドを出力
output "ssh_command_1c" {
  value = "ssh -i ${var.key_name} admin@${aws_instance.hirayama-ec2-c.public_ip}"
}

# sshコマンドを出力
output "ssh_command_1d" {
  value = "ssh -i ${var.key_name} admin@${aws_instance.hirayama-ec2-d.public_ip}"
}

# key名を出力
output "var_key_name" {
  value = var.key_name
}

# ALBのDNS名
output "alb_dnsname" {
  value = aws_lb.hirayama_alb.dns_name
}