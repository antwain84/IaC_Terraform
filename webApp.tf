resource "azurerm_app_service_plan" "a84_app_service_plan" {
    name = "a84-app-service-plan"
    location = var.resource_group_location
    resource_group_name = azurerm_resource_group.DevSecOps.name
    kind = "Linux"
    reserved = false # Indicates Linux-based hosting

        sku {
        tier = "Basic" # Pricing tier (can be changed)
        size = "B1" # Size of the App Service Plan
        }

        tags = {
        environment = "Production"
        project = "App Service Deployment"
        }
}

resource "azurerm_app_service" "a84_app_serv" {
    name        = "a84-app-serv"
    location    =  var.resource_group_location
    resource_group_name = azurerm_resource_group.DevSecOps.name
    app_service_plan_id = azurerm_app_service_plan.a84_app_service_plan.id
}

# Create the App Service with Node.js 20 LTS
resource "azurerm_linux_web_app" "a84_lin_app_service" {
    name = "a84-lin-app-service"
    location = var.resource_group_location
    resource_group_name = azurerm_resource_group.DevSecOps.name
    service_plan_id = azurerm_app_service_plan.a84_app_service_plan.id
    
    # Configure the runtime (Node.js 20 LTS)
        site_config {
            linux_fx_version = "NODE|20-lts" # Set the runtime stack to Node.js 20 LTS
            
            # App Service Authentication (Basic Authentication using Azure AD)
            #ftps_state = "FtpsOnly" # Enable FTPS only for secure deployment

            #app_command_line = "" # You can set custom commands here if needed
        }
    # Authentication Settings (enable with Azure Active Directory)
     
    # Set up inbound traffic rules (IP restrictions)
    dynamic "allowed_ips" {
        for_each = var.allowed_ips
        content {
            name = "AllowSpecificIP-${allowed_ips.value}"
            ip_address = allowed_ips.value
            action = "Allow"
            priority = count.index + 100
        }      
    }
 
        app_settings = {
            APPINSIGHTS_PROFILERFEATURE_VERSION = "1.0.0"
            APPINSIGHTS_SNAPSHOTFEATURE_VERSION = "1.0.0"
            DiagnosticServices_EXTENSION_VERSION = "~3"
            InstrumentationEngine_EXTENSION_VERSION = "disabled"
            SnapshotDebugger_EXTENSION_VERSION = "disabled"
            XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
            XDT_MicrosoftApplicationInsights_Java = "1"
            XDT_MicrosoftApplicationInsights_Mode = "recommended"
            XDT_MicrosoftApplicationInsights_NodeJS = "1"
            XDT_MicrosoftApplicationInsights_PreemptSdk = "disabled"
        }
    # Add multiple IP restrictions if needed
  
    # Tags
    tags = {

        environment = "Production"
        project = "App Service Deployment"
    }
}