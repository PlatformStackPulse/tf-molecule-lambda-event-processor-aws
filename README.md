# tf-molecule-lambda-event-processor-aws

Terraform molecule that creates a Lambda function configured for event-driven processing with an event source mapping (SQS/DynamoDB/Kinesis), a version alias for safe deployments, a function URL for direct invocation, and a CloudWatch log group.

## Usage

```hcl
module "event_processor" {
  source = "git::https://github.com/PlatformStackPulse/tf-molecule-lambda-event-processor-aws.git?ref=v1.0.0"

  namespace   = "psp"
  environment = "prod"
  name        = "order-processor"

  role_arn         = module.lambda_role.role_arn
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  filename         = "dist/handler.zip"
  event_source_arn = module.orders_queue.arn
  batch_size       = 5
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
