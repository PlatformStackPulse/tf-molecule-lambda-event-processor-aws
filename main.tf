# -----------------------------------------------------
# Molecule: Lambda Event Processor
# Creates a Lambda function with event source mapping, alias,
# function URL, and CloudWatch log group for event-driven processing.
# -----------------------------------------------------

module "log_group" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-cloudwatch-log-group-aws.git?ref=d05ce1626c5f7079ed66a5888fb58e2556d4e9aa"

  context           = module.this.context
  log_group_name    = "/aws/lambda/${module.this.id}"
  retention_in_days = var.log_retention_days
}

module "function" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-lambda-function-aws.git?ref=89ef0df3aea9e41890875f501004ff428b102bba"

  context               = module.this.context
  description           = var.description
  role_arn              = var.role_arn
  handler               = var.handler
  runtime               = var.runtime
  timeout               = var.timeout
  memory_size           = var.memory_size
  filename              = var.filename
  s3_bucket             = var.s3_bucket
  s3_key                = var.s3_key
  architectures         = var.architectures
  environment_variables = var.environment_variables

  depends_on = [module.log_group]
}

module "alias" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-lambda-alias-aws.git?ref=3a1c7225811f8e6039ab67498107b4aa9f18e753"

  context          = module.this.context
  alias_name       = var.alias_name
  function_name    = module.function.function_name
  function_version = var.alias_function_version
  description      = "Alias for ${module.this.id}"

  depends_on = [module.function]
}

module "event_source_mapping" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-lambda-event-source-mapping-aws.git?ref=78fe25ace417aa63ebd2d19051433004bdc5ebf3"

  context           = module.this.context
  event_source_arn  = var.event_source_arn
  function_name     = module.alias.arn
  batch_size        = var.batch_size
  mapping_enabled   = var.mapping_enabled
  starting_position = var.starting_position

  depends_on = [module.alias]
}

module "function_url" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-lambda-function-url-aws.git?ref=90a1ed08a95d8fe736ef2873437087626ef451c4"

  context            = module.this.context
  function_name      = module.function.function_name
  authorization_type = var.function_url_auth_type
  qualifier          = module.alias.arn != null ? var.alias_name : null
  cors_configuration = var.cors_configuration

  depends_on = [module.alias]
}
