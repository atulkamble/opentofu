output "message" { value = "Hello, ${var.name_prefix}!" }
output "id" { value = random_id.greet.hex }
