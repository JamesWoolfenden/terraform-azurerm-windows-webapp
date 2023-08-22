resource "azurerm_windows_web_app" "pass" {
  #checkov:skip=CKV_AZURE_16: AD might not be required
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  service_plan_id     = var.service_plan_id

  https_only = true
  logs {
    detailed_error_messages = true
    failed_request_tracing  = true
    http_logs {
      file_system {
        retention_in_days = 4
        retention_in_mb   = 25
      }

    }
  }

  storage_account {
    name         = var.storage.name
    type         = var.storage.store_type
    account_name = var.storage.account_name
    share_name   = var.storage.share_name
    access_key   = var.storage.access_key
    mount_path   = var.storage.mount_path
  }

  site_config {
    ftps_state        = "FtpsOnly"
    http2_enabled     = true
    health_check_path = var.health_check_path
    application_stack {
      dotnet_version = "v7.0"
    }
  }


  client_certificate_enabled = true

  auth_settings {
    enabled = true
  }

  identity {
    type = "SystemAssigned"
  }


}
