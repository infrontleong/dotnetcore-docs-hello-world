resource "azurerm_linux_virtual_machine_scale_set" "vmss001" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  admin_username      = var.admin_username
  computer_name_prefix = var.computer_name_prefix
  instances           = var.instances
  sku                 = var.sku
  zones               = var.zones
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_id = var.source_image_id
  upgrade_mode    = "Manual"
  overprovision   = true
  platform_fault_domain_count = 5
  single_placement_group      = true
  provision_vm_agent          = true
  extension_operations_enabled = true
  extensions_time_budget       = "PT1H30M"
  zone_balance                 = false
  vtpm_enabled                 = false
  priority                     = "Regular"
  encryption_at_host_enabled   = false
  secure_boot_enabled          = false
  tags                         = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  scale_in {
    rule                   = "NewestVM"
    force_deletion_enabled = false
  }

  extension {
    name                       = "${var.name}-ext"
    publisher                  = "Microsoft.ManagedServices"
    type                       = "ApplicationHealthLinux"
    type_handler_version       = "1.0"
    auto_upgrade_minor_version = false
    automatic_upgrade_enabled  = false
    settings = jsonencode({
      port     = 8761
      protocol = "tcp"
    })
  }

    #   extension {
  #   auto_upgrade_minor_version = true
  #   automatic_upgrade_enabled  = false
  #   force_update_tag           = ""
  #   name                       = "ulsmrappprod01ext2-fileshare"
  #   protected_settings         = "" # Masked sensitive attribute
  #   provision_after_extensions = []
  #   publisher                  = "Microsoft.Azure.Extensions"
  #   settings = jsonencode({
  #     commandToExecute = "if sudo mount | grep -q '/data/app type cifs'; then status='azFileShare mounted. No action taken'; else sudo mount -t cifs //stpmysummerseaprod01.file.core.windows.net/sqldata /data/app -o vers=3.0,credentials=/etc/smbcredentials/stpmysummerseaprod01.cred,dir_mode=0777,file_mode=0777,serverino; fi"
  #   })
  #   type                 = "CustomScript"
  #   type_handler_version = "2.0"
  # }

  network_interface {
    name                          = var.name
    primary                       = true
    enable_accelerated_networking = false
    enable_ip_forwarding          = false

    ip_configuration {
      name                                   = "default"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.backend_address_pool_ids
      version                                = "IPv4"
    }
  }
}
