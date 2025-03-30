echo "Select an option:"
echo "Up) Terraform Plan & Apply"
echo "Down) Terraform Destroy"

read -p "Enter 'Up' or 'Down': " choice

if [ "$choice" == "Up" ]; then
    terraform plan -out tfplan && terraform apply tfplan
elif [ "$choice" == "Down" ]; then
    terraform destroy -auto-approve
else
    echo "Invalid choice. Please enter 'Up' or 'Down'."
fi       