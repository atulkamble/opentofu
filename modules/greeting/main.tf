resource "random_id" "greet" {
  byte_length = 4
  keepers = {
    prefix = var.name_prefix
  }
}

output "message" {
  value = "Hello, ${var.name_prefix}!"
}

output "id" {
  value = random_id.greet.hex
}
