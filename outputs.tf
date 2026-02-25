output "storage_account_name" {
  description = "Nom du compte de stockage déployé"
  value       = module.storage.storage_account_name
}

output "images_container_name" {
  value = module.storage.images_container_name
}