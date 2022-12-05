provider "azurerm" {
  skip_provider_registration = true
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.21.0"
    }
  }
}

data "azurerm_client_config" "current" {}

locals {
  sufixName  = "myapptest"
  rgName     = "myapptest-rg"
  rgLocation = "westeurope"
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = "sql-${local.sufixName}-01"
  resource_group_name          = local.rgName
  location                     = local.rgLocation
  version                      = "12.0"
  administrator_login          = "SQLAdminTest"
  administrator_login_password = "SQLAdminTestPassword"
}

resource "azurerm_storage_account" "sqlserver_sta" {
  name                     = "st${local.sufixName}01"
  resource_group_name      = local.rgName
  location                 = local.rgLocation
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_sql_database" "sqldatabase" {
  name                = "dbsql-${local.sufixName}-01"
  resource_group_name = local.rgName
  location            = local.rgLocation
  server_name         = azurerm_sql_server.sqlserver.name
  edition             = "Basic"
}