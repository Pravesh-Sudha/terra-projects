output "website_url" {
  value = "Environment ${terraform.workspace} -> http://${aws_s3_bucket.site_bucket.bucket}.s3-website-us-east-1.amazonaws.com"
  description = "Static website endpoint"
}