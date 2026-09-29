output "ip-address" {
  value = aws_instance.web_app.public_ip 
}
 output "private-ip" {
   value = aws_instance.web_app.private_ip
 }

