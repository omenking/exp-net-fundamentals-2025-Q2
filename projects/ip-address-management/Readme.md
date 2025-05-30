# Deploy Windows Server


Find Windows 11 for my region
```sh
az vm image list \
  --publisher MicrosoftWindowsDesktop \
  --offer windows11 \
  --sku win11-22h2 \
  --location canadaeast \
  --all \
  --output table
```

```sh
cd ip-address-management/templates/vm
az group create \
  --name net-fun-bootcamp \
  --location canadaeast
az deployment group create \
  --resource-group net-fun-bootcamp \
  --template-file template.bicep \
  --parameters @parameters.json  \
  --debug
```