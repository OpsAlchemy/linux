$publicIp = terraform output -raw public_ip

$privateKey = "keys/private_key.pem"

$username = "azureuser"

ssh -i $privateKey "$username@$publicIp"