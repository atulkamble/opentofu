resource "random_id" "greet" {
  byte_length = 4
  keepers = {
    prefix = var.name_prefix
  }
}
