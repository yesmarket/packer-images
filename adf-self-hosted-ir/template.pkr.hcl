source "azure-arm" "this" {
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  image_publisher                   = var.source_image_publisher
  image_offer                       = var.source_image_offer
  image_sku                         = var.source_image_sku
  location                          = var.location
  managed_image_name                = var.image_name
  managed_image_resource_group_name = var.resource_group_name
  os_type                           = "Windows"
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  vm_size                           = var.vm_size
  communicator                      = "winrm"
  winrm_username                    = "packer"
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_use_ssl                     = true
}

build {
  sources = ["source.azure-arm.this"]

  provisioner "powershell" {
    environment_vars = ["url=${var.adf_shir_msi_url}"]
    script           = "./DownloadAndInstallGateway.ps1"
  }

  provisioner "file" {
    source      = "RegisterGateway.ps1"
    destination = "C:/temp/RegisterGateway.ps1"
  }
}
