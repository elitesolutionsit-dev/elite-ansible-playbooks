locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "devOps"
    Owner       = "elitesolutionsit"
    environment = "Development"
    ManagedWith = "terraform"
  }
  buildregion             = lower("EASTUS2")
  server                  = "elite"
  elite_general_resources = "elite-vm-dev"
}