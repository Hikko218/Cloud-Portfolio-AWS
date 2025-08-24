output "s3_bucket_name" {
  value = aws_s3_bucket.storage.bucket
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}