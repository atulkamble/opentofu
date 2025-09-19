resource "random_pet" "this" {
  length = 2
}

resource "local_file" "readme" {
  filename = "demo.txt"
  content  = "Hello from ${random_pet.this.id}!\n"
}

output "file_path" {
  value = local_file.readme.filename
}
