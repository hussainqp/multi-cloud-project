data "azurerm_resource_group" "udacity" {
  name     = "Regroup_1zGYDSavV7EYetrQJ"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-hussain-azure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/tscotto5/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-hussain-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-hussain-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######

resource "azurerm_storage_account" "hussainudacitystorage" {
  name                     = "hussainudacitystorage"
  resource_group_name      = data.azurerm_resource_group.udacity.name
  location                 = data.azurerm_resource_group.udacity.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}







data "azurerm_mssql_server" "sqlserver" {
  name                = "udacity-hussain-azure-sql"
  resource_group_name = data.azurerm_resource_group.udacity.name
}





resource "azurerm_service_plan" "appserviceplan" {
  name                = "app-service-plan"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function" {
  name                = "udacity-hussain-azure-dotnet-app"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location

  storage_account_name       = azurerm_storage_account.hussainudacitystorage.name
  storage_account_access_key = azurerm_storage_account.hussainudacitystorage.primary_access_key
  service_plan_id            = azurerm_service_plan.appserviceplan.id

  site_config {}
}