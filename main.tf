module "patch_deployments" {
  for_each                    = var.maintenance_window
  source                      = "./modules/patch-deploy"
  regions                     = each.value.region
  patch_deployment_id         = each.value.patch_deployment_id
  instance_filter_labels      = each.value.instance_filter_labels
  maintenance_window_duration = each.value.maintenance_window_duration
  reboot_config               = each.value.reboot_config
  os_type                     = each.value.os_type
  package_configurations      = each.value.package_configurations
  pre_step                    = each.value.pre_step
  post_step                   = each.value.post_step
  schedule                    = each.value.schedule
  rollout                     = try(each.value.rollout, null)
}