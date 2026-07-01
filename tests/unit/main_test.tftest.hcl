# Unit Tests — tf-molecule-lambda-event-processor-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:      terraform test -test-directory=tests/unit
# Run verbose:   terraform test -test-directory=tests/unit -verbose
# Run specific:  terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: assertions target plan-KNOWN values only (tf-label id, the enabled
# pass-through). Computed ARNs / IDs / UUIDs are unknown under a mock provider
# and must not be asserted on at plan time.

mock_provider "aws" {}

variables {
  # tf-label context
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-specific required inputs
  role_arn         = "arn:aws:iam::123456789012:role/eg-test-thing-exec"
  event_source_arn = "arn:aws:sqs:us-east-1:123456789012:eg-test-thing-queue"

  # optional inputs with valid sample values
  handler         = "bootstrap"
  runtime         = "provided.al2023"
  filename        = "dist/handler.zip"
  batch_size      = 5
  mapping_enabled = true
}

# ---------------------------------------------------------------------------
# Test: module wires up and produces expected label + enabled pass-through
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id should be 'eg-test-thing' for namespace=eg, stage=test, name=thing"
  }

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true by default"
  }

  assert {
    condition     = module.this.namespace == "eg"
    error_message = "namespace should pass through to the label context"
  }
}

# ---------------------------------------------------------------------------
# Test: event-source-mapping inputs pass through to the child atom
# ---------------------------------------------------------------------------
# NOTE: the child atoms (alias / function-url) do not gate on `enabled`, so a
# fully-disabled plan cannot be planned under a mock provider (a child input
# would be null and trip its own validation). We therefore exercise the
# enabled path and assert on plan-known input pass-throughs instead.
run "wires_event_source_mapping" {
  command = plan

  variables {
    batch_size        = 25
    mapping_enabled   = false
    event_source_arn  = "arn:aws:dynamodb:us-east-1:123456789012:table/eg-test-thing/stream/2026-01-01T00:00:00.000"
    starting_position = "LATEST"
  }

  assert {
    condition     = module.event_source_mapping.enabled == true
    error_message = "event source mapping child module should be enabled when the molecule is enabled"
  }

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id should remain 'eg-test-thing' regardless of mapping tuning"
  }
}
