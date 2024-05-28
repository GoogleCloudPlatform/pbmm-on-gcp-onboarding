output "folder_id" {
  description = "Folder id id."
  value       = google_folder.env_business_unit.name
}

output "business_code" {
    description = "business_code"
    value = var.business_code

}

output "business_unit" {
    description = "business_unit"
    value = var.business_unit
}
