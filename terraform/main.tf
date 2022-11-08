module "ingress" {
  source = "./modules/ingress"
}

module "monitoring" {
  depends_on = [module.ingress]
  source = "./modules/monitoring"
}

module "kafka" {
  source = "./modules/kafka"
}

#module "wordpress" {
#  source = "./modules/wordpress"
#  stage = var.stage
#}

#module "dashboard" {
#  source = "./modules/dashboard"
#}