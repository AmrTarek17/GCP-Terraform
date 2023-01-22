module "network" {
    source = "./network"

    project_name = var.project_name
    vpc_name = var.vpc_name

}