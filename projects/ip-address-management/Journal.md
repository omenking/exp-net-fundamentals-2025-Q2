## Downloaded Azure Resource Template

After deploying my Micorsoft Windows DataCenter Server 2025 to Azure VM.
I downloaded the Resource Templates to be able to easily deploy again.

## Converting Resource Template to Azure Bicep

I launched the a DataCenter Server which had no Windows UI.
I want to reuse my resource template files, but they are too hard
to work with directly. So I'm going to convert them to Azure Bicep.


Install and Login to Azure CLI
```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --use-device-code
```

Convert to Azure Bicep

```sh
cd ip-address-management/templates/vm
az bicep decompile --file template.json
```

After decompiling I noticed the files were still verbose.
It turns out that decompile with make the output 1:1 to json.
I asked ChatGPT to refactor the code to reduce the verboseness of the code.

## Switching Regions from CanadaEast to USEast

When attempting to deploy to CanadaEast Azure said the SKU for Windows 11 x86 is not avaliabe.
So I checked what was avaliable.


```text
az vm image list \
  --publisher MicrosoftWindowsDesktop \
  --offer windows11 \
  --sku win11-22h2-pro \
  --location canadaeast \
  --all \
  --output table
Architecture    Offer                   Publisher                Sku             Urn                                                                              Version
--------------  ----------------------  -----------------------  --------------  -------------------------------------------------------------------------------  -----------------
Arm64           windows11preview-arm64  MicrosoftWindowsDesktop  win11-22h2-ent  MicrosoftWindowsDesktop:windows11preview-arm64:win11-22h2-ent:22621.4751.250111  22621.4751.250111
Arm64           windows11preview-arm64  MicrosoftWindowsDesktop  win11-22h2-ent  MicrosoftWindowsDesktop:windows11preview-arm64:win11-22h2-ent:22621.4890.250210  22621.4890.250210
Arm64           windows11preview-arm64  MicrosoftWindowsDesktop  win11-22h2-ent  MicrosoftWindowsDesktop:windows11preview-arm64:win11-22h2-ent:22621.5039.250305  22621.5039.250305
Arm64           windows11preview-arm64  MicrosoftWindowsDesktop  win11-22h2-ent  MicrosoftWindowsDesktop:windows11preview-arm64:win11-22h2-ent:22621.5192.250409  22621.5192.250409
Arm64           windows11preview-arm64  MicrosoftWindowsDesktop  win11-22h2-ent  MicrosoftWindowsDesktop:windows11preview-arm64:win11-22h2-ent:22621.5335.250509  22621.5335.250509
```

- We want Gen2, and arm64 is only avaliable for Gen1 VMs.
- Also we only have preview images which might be bad for production use case
- We could switch to Gen1 but then we have reduce security
- Lets switch to EastUs, we don't have a data sonverinty requirement so it should be fine.
- even switching to eastus we cannot find a x86 image. So we're going to use preview arm64 in Canada.


## Conclusion

- I was unable within hour to get this AZ Bicep to deploy.
- There are challenges choosing the correct image type
- There is challenges knowing if we are set to Gen1 or Gen2 in our Azure Bicep
- We'll ship the code for someone else to fix.