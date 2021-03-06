resource "random_integer" "rand" {
  min = 1
  max = 1000
}

data "alicloud_simple_application_server_images" "default" {
  platform = "Linux"
}

data "alicloud_simple_application_server_plans" "default" {
  platform = "Linux"
}

data "alicloud_simple_application_server_disks" "default" {
  disk_type   = "System"
  instance_id = module.sas.instance_id
}

module "sas" {
  source = "../.."
  #  alicloud_simple_application_server_instance
  create_instance = true
  payment_type    = "Subscription"
  instance_name   = "${var.instance_name}-${random_integer.rand.result}"
  period          = 1
  image_id        = data.alicloud_simple_application_server_images.default.images.0.id
  plan_id         = data.alicloud_simple_application_server_plans.default.plans.0.id
  data_disk_size  = var.data_disk_size
  password        = var.password

  #  alicloud_simple_application_server_snapshot
  create_snapshot = true
  disk_id         = data.alicloud_simple_application_server_disks.default.ids.0
  snapshot_name   = "${var.snapshot_name}-${random_integer.rand.result}"

  #  alicloud_simple_application_server_custom_image
  create_image      = true
  custom_image_name = var.custom_image_name
  image_status      = var.image_status
  description       = "description"
}

