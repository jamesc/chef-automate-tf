resource "aws_vpc" "automate-vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name          = "${var.tag_name}-vpc"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Contact     = "${var.tag_contact}"
    X-Application = "${var.tag_application}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_internet_gateway" "automate-gateway" {
  vpc_id = "${aws_vpc.automate-vpc.id}"

  tags {
    Name = "automate-gateway"
  }
}

resource "aws_route" "automate-internet-access" {
  route_table_id         = "${aws_vpc.automate-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.automate-gateway.id}"
}

resource "aws_subnet" "automate-subnet" {
  vpc_id                  = "${aws_vpc.automate-vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "automate-subnet"
  }
}


resource "aws_subnet" "workload-subnet" {
  vpc_id                  = "${aws_vpc.automate-vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "workload-subnet"
  }
}