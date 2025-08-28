output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "EC2 Instance Private IP"
  value       = aws_instance.this.private_ip
}

output "availability_zone" {
  description = "EC2 Instance Availability Zone"
  value       = aws_instance.this.availability_zone
}

output "subnet_id" {
  description = "EC2 Instance Subnet ID"
  value       = aws_instance.this.subnet_id
}

output "arn" {
  description = "EC2 Instance ARN"
  value       = aws_instance.this.arn
}

output "instance_state" {
  description = "EC2 Instance State"
  value       = aws_instance.this.instance_state
}

output "root_block_device" {
  description = "EC2 Instance Root Block Device"
  value       = aws_instance.this.root_block_device
}

output "additional_ebs_volumes" {
  description = "Additional EBS Volumes"
  value = {
    volumes = aws_ebs_volume.additional[*].id
    attachments = aws_volume_attachment.additional[*].id
  }
}
