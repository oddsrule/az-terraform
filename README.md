# az-terraform
Terraform activities in azure

Getting used to terraform, will be writing code that originated as az cli commands and seeing where I end up.

Registering provider with the version parameter works - baby steps

Resource group create works - like I said this is learning to crawl

Both "DisplayName" and "Name" are valid for the location - will stick with Name from here on out.
Hoping to remember to use the tags for cool stuff later on.

Review this link at some point to see if there's value - still want a good assistant for VSCode and terraform
https://docs.microsoft.com/en-us/azure/terraform/terraform-vscode-extension

using random_id for SA name seed

Pay attention to _ vs - ... IMO the terraform syntax assistance is nowhere near as helpful as the arm template equivalents - errors are shown but not helpful to this newb.

SA account has been created - and tag inheritance works as I hoped just by pulling from the resource group

vnet and 1 subnet added after about 20 commits - could not figure out the function to merge/concat/join strings - finally found that JOIN is what is needed
two examples in the file so far

note - readup on md formatting sometime

network/subnets good - on to some NSGs

subnets cannot be tagged - nsg looks good now

ASGs in place but no rules exist - adding now
fixed up the ASG

bastion access works - ssh to public IP with password
next steps:
ssh keys pulling from keyvault in place of passwords
outputs
data disks
vm extensions to bootstrap

when brain works better look at parameterizing everything to try and make naming convention as code????
