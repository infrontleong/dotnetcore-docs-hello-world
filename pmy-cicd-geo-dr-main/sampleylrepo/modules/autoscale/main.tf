resource "azurerm_monitor_autoscale_setting" "autoscale001" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = var.target_resource_id
  enabled             = true
  tags                = var.tags

  profile {
    name = "Auto created scale condition"
    capacity {
      minimum = 2
      default = 2
      maximum = 4
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
        metric_resource_id = var.target_resource_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThanOrEqual"
        threshold          = 80
        divide_by_instance_count = false
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
        metric_resource_id = var.target_resource_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThanOrEqual"
        threshold          = 40
        divide_by_instance_count = false
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT10M"
      }
    }
  }
}
