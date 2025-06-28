terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.33.0"
    }
  }

}



provider "azurerm" {

    features {}
    subscription_id = "1f196f8e-ab8f-4746-a1f5-1798c2228e8f"
  
}