output "vpc_id" {
  value = aws_vpc.aviacore.id
}

output "pub_sub1" {
  value = aws_subnet.aviacore-pub-sub1.id
}

output "pub_sub2" {
  value = aws_subnet.aviacore-pub-sub2.id
}

output "private_subnet" {
  value = aws_subnet.aviacore-priv-sub1.id
}


output "testing_subnet" {
  value = aws_subnet.aviacore-test-sub.id
}
