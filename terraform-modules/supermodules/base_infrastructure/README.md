<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rsg"></a> [rsg](#module\_rsg) | ../../modules/rsg | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ../../modules/subnet_nsg_routetable | n/a |
| <a name="module_virtual_machine"></a> [virtual\_machine](#module\_virtual\_machine) | ../../modules/virtual_machine_nic_backup | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ../../modules/vnet | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the application associated with this deployment. | `string` | n/a | yes |
| <a name="input_az_region"></a> [az\_region](#input\_az\_region) | The location where resources will be created | `string` | n/a | yes |
| <a name="input_company"></a> [company](#input\_company) | Company name | `string` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Specific tags that is not covered in common tags | `map(string)` | `null` | no |
| <a name="input_enable_subnet_nsg"></a> [enable\_subnet\_nsg](#input\_enable\_subnet\_nsg) | Toggle to enable/disable subnet NSG | `bool` | n/a | yes |
| <a name="input_enable_vm_backup"></a> [enable\_vm\_backup](#input\_enable\_vm\_backup) | Toggle to enable/disable VM backup and resources | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment of the deployment | `string` | n/a | yes |
| <a name="input_example_subnet_prefix"></a> [example\_subnet\_prefix](#input\_example\_subnet\_prefix) | The Subnet Prefix | `list(string)` | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space that is used by the virtual network. | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->