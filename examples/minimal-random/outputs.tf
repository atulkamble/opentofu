output "greeting" {
  value = module.greet.message
}

output "token" {
  value       = module.greet.id
  description = "Deterministic token for demo purposes"
}
