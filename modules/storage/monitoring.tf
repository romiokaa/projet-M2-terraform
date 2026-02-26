resource "azurerm_monitor_action_group" "main" {
  name                = "critical-alerts"
  resource_group_name = var.resource_group_name
  short_name          = "crit-alert"

  email_receiver {
    name                    = "admin-email"
    email_address           = var.admin_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "storage_capacity" {
  name                = "storage-capacity-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_storage_account.storage.id]
  description         = "Alerte si le stockage dépasse 1 Go"
  severity            = 3
  
  frequency           = "PT1H" 
  window_size         = "PT1H" 

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1073741824 
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}