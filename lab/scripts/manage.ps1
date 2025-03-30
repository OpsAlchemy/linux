Write-Host "Select an option:"
Write-Host "1) Up - Terraform Plan & Apply"
Write-Host "2) Down - Terraform Destroy"

$choice = Read-Host "Enter 'Up' or 'Down'"

if ($choice -eq "Up") {
    terraform plan -out tfplan
    if ($?) { 
        terraform apply tfplan
    }
} elseif ($choice -eq "Down") {
    terraform destroy -auto-approve
} else {
    Write-Host "Invalid choice. Please enter 'Up' or 'Down'."
}
