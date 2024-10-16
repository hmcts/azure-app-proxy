# azure-app-proxy

[Azure Application Proxy](https://learn.microsoft.com/en-us/azure/active-directory/app-proxy/application-proxy) is a service that allows you to publish on-premises web applications to external users in a secure and simple way without requiring VPN clients and configurations.

## Adding a new application

Applications are configured in [`apps.yaml`](https://github.com/hmcts/azure-app-proxy/blob/main/apps.yaml).

There is a JSON schema which can be [configured in your IDE](https://github.com/hmcts/azure-app-proxy-manager#appsyaml-schema).
This will provide autocompletion and show all the features available.

The automation is built using a project called [azure-app-proxy-manager](https://github.com/hmcts/azure-app-proxy-manager)
written by [@timja](http://github.com/timja) and with many features added by [@adusumillipraveen](https://github.com/adusumillipraveen).

After an application is registered through the automated pipeline, a GA account must grant admin consent for the Microsoft Graph Permissions in Azure. 

We can likely swap to terraform once it's supported there, but currently there are some limitations in the current version which may not change until a major version of the provider.
[See the work that was done to look at this](https://github.com/hashicorp/terraform-provider-azuread/issues/7#issuecomment-1581102984).

## Architecture

![Architecture](https://github.com/hmcts/azure-app-proxy/assets/21194782/c1ba21e3-6258-4cf0-a03f-c3afd9bd98b8)

## Operational concerns

### Patching

Patching should be handled automatically as the `patch_mode` is set to `AutomaticByPlatform`

### Availability

Three Virtual Machines are run across different availability zones for redunduncy.
There should always be at least one active but the others may be shutdown outside of business hours to save costs.

### Connecting to the Application Proxy connectors

Only local accounts are supported for connecting to the connectors due to limitations with Azure AD Windows login [requiring Windows only and to be registered with HMCTS.NET AAD](https://learn.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-windows#log-in-using-passwordlimited-passwordless-authentication-with-azure-ad).

- Username: `VMAdmin`
- Password: 
  - Retrieve with `az keyvault secret show --vault-name app-proxy --name vm-admin-password --query value -o tsv`

To connect you will need to be on the VPN and have the Windows App (formerly Microsoft Remote Desktop) or another remote desktop client installed on your laptop.

### Monitoring

The main service that needs to be running on the VMs is the `Microsoft Entra private network connector` service (`WAPSVC).

If a ticket is raised about services behind app-proxy not working, then login to the servers and check this service is running.

First, you may need to type `15` on the sconfig screen to get to powershell. Then run:

`get-service WAPSVC`

If it's not running, run:

`start-service WAPSVC`

A scheduled task has been created to check the status of this service every fifteen minutes and start it if it's not running.

The code for this can be found in the powershell scripts in [app-proxy component](./components/app-proxy).

The scheduled task is called [CheckAndStartWAPSvc](https://github.com/hmcts/azure-app-proxy/blob/6154229ddf3f4f824ee9d0490f6d2d5dd6dbddfa/components/app-proxy/Bootstrap-Application-Proxy.ps1#L97).

## References

- [Plan an Azure AD Application Proxy deployment](https://learn.microsoft.com/en-us/azure/active-directory/app-proxy/application-proxy-deployment-plan)
- [High level design](https://tools.hmcts.net/confluence/display/DTSPO/DTS+Azure+Application+Proxy+HLD)
- [High level design - summary](https://justiceuk.sharepoint.com/:p:/s/DTSPlatformOperations/Eb8dvWOAFYREuW4ANUhfeF8BCYiyHQ28srF0kn8_cARgmg?e=7CyEqf)
- [Tab approval - TODO]()
- [How to automate Azure AD Application Proxy? - Blog by timja](https://blog.timja.dev/azuread-app-proxy/)
- [How to automate Azure AD Application Proxy? - Part 2 - Blog by timja](https://blog.timja.dev/how-to-automate-azure-ad-application-proxy-part-2/)
- [Terraform tracking issue](https://github.com/hashicorp/terraform-provider-azuread/issues/7#issuecomment-1581102984)


