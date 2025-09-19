module "greet" {
  source = "../../modules/greeting"

  name_prefix = var.name_prefix
}

# Demonstrate null_resource provisioners running a harmless local-exec
resource "null_resource" "echo_demo" {
  triggers = {
    id = module.greet.id
  }

  provisioner "local-exec" {
    command = "echo Greeting ID: ${module.greet.id}"
  }
}
