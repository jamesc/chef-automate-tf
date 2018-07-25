output "vpc_id" {
  value = "${aws_vpc.automate-vpc.id}"
}

output "subnet_id" {
  value = "${aws_subnet.automate-subnet.id}"
}
