# Both budgets are notification-only, which AWS does not charge for. They are
# tripwires, not brakes: budget data lags spend by up to a day, so the real
# control is the stop/destroy checkpoint closing every delivery.

resource "aws_budgets_budget" "warning" {
  name         = "edgar-lakehouse-warning-10usd"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.budget_email]
  }
}

resource "aws_budgets_budget" "critical" {
  name         = "edgar-lakehouse-critical-20usd"
  budget_type  = "COST"
  limit_amount = "20"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.budget_email]
  }
}
