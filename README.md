# tf-molecule-lambda-event-processor-aws

Terraform molecule that provisions a complete event-driven Lambda processor on AWS: a Lambda function, a version alias for safe deployments, an event source mapping (SQS / DynamoDB Streams / Kinesis), a function URL for direct invocation, and a dedicated CloudWatch log group.

## Features

- **Lambda function** — configurable runtime, handler, memory, timeout, architecture, and environment variables; deployed from a local zip or S3 object.
- **Version alias** — stable pointer (e.g. `live`) for blue/green and canary deploys.
- **Event source mapping** — connect an SQS queue, DynamoDB stream, or Kinesis stream with a configurable batch size, enable/disable flag, and starting position; the mapping targets the alias for safe rollouts.
- **Function URL** — optional direct HTTPS endpoint with `AWS_IAM` or `NONE` auth and full CORS configuration.
- **CloudWatch log group** — created ahead of the function with configurable retention.
- **tf-label context** — standard `namespace`/`stage`/`name` labelling and tagging via `module.this`, with a single `enabled` switch to toggle the whole molecule.

## Usage

```hcl
module "event_processor" {
  source = "git::https://github.com/PlatformStackPulse/tf-molecule-lambda-event-processor-aws.git?ref=v1.0.0"

  namespace   = "psp"
  stage       = "prod"
  name        = "order-processor"

  # required
  role_arn         = module.lambda_role.role_arn
  event_source_arn = module.orders_queue.arn

  # deployment package + runtime
  handler  = "bootstrap"
  runtime  = "provided.al2023"
  filename = "dist/handler.zip"

  # event source mapping tuning
  batch_size      = 5
  mapping_enabled = true
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Tests

Unit tests use a mock AWS provider (no credentials, no AWS calls) and assert on plan-known values only.

```bash
terraform init -backend=false
terraform test -test-directory=tests/unit            # unit tests (mock provider)
terraform test -test-directory=tests/integration     # integration tests (requires AWS credentials)

make test-unit                                        # via Makefile
```
