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
}

build {
  sources = ["source.azure-arm.this"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

}
