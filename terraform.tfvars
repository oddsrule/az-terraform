landscape       = "dev"
location        = "westus2"
networkrg       = "kj-terraform-network-rg"
computerg       = "kj-terraform-compute-rg"
vnet            = "kj-terraform-vnet"
objectId        = ""
tenantId        = ""

bastion_subnet  = "bastion-subnet"
dmz_subnet      = "dmz-subnet"
web_subnet      = "web-subnet"
database_subnet = "database-subnet"

bastion_asg     = "kj-terraform-network-rg-bst-asg" 
dmz_asg         = "kj-terraform-network-rg-dmz-asg"
web_asg         = "kj-terraform-network-rg-web-asg"
database_asg    = "kj-terraform-network-rg-db-asg"

bastion_prefix = "bst"
dmz_prefix = "dmz"
web_prefix = "web"
database_prefix = "db"

network_security_group = "kj-terraform-vnet-nsg"

storage_base_name = "kjtfcompute"
