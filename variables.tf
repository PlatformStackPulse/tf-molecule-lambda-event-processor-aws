variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = null
}

variable "role_arn" {
  description = "ARN of the IAM execution role for the Lambda function"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "role_arn must be a valid IAM role ARN."
  }
}

variable "handler" {
  description = "Function entrypoint (e.g., index.handler)"
  type        = string
  default     = "bootstrap"
}

variable "runtime" {
  description = "Runtime identifier"
  type        = string
  default     = "provided.al2023"
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Amount of memory in MB"
  type        = number
  default     = 128
}

variable "filename" {
  description = "Path to the deployment package"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket containing the deployment package"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the deployment package"
  type        = string
  default     = null
}

variable "architectures" {
  description = "Instruction set architecture"
  type        = list(string)
  default     = ["arm64"]
}

variable "environment_variables" {
  description = "Map of environment variables"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}

variable "alias_name" {
  description = "Name for the Lambda alias"
  type        = string
  default     = "live"
}

variable "alias_function_version" {
  description = "Lambda function version for the alias"
  type        = string
  default     = "$LATEST"
}

variable "event_source_arn" {
  description = "ARN of the event source (SQS, DynamoDB, Kinesis)"
  type        = string
  validation {
    condition     = length(var.event_source_arn) > 0
    error_message = "event_source_arn must not be empty."
  }
}

variable "batch_size" {
  description = "Maximum number of records per batch"
  type        = number
  default     = 10
}

variable "mapping_enabled" {
  description = "Whether the event source mapping is enabled"
  type        = bool
  default     = true
}

variable "starting_position" {
  description = "Starting position for stream-based sources"
  type        = string
  default     = null
}

variable "function_url_auth_type" {
  description = "Authorization type for function URL (NONE or AWS_IAM)"
  type        = string
  default     = "AWS_IAM"
}

variable "cors_configuration" {
  description = "CORS configuration for the function URL"
  type = object({
    allow_credentials = optional(bool, false)
    allow_headers     = optional(list(string), [])
    allow_methods     = optional(list(string), [])
    allow_origins     = optional(list(string), [])
    expose_headers    = optional(list(string), [])
    max_age           = optional(number, 0)
  })
  default = null
}
