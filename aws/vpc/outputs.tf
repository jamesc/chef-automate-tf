output "vpc_id" {
  value = "${aws_vpc.automate-vpc.id}"
}

output "automate_subnet_id" {
  value = "${aws_subnet.automate-subnet.id}"
}

output "workload_subnet_id" {
  value = "${aws_subnet.workload-subnet.id}"
}
