// Azure authentication library to access Azure Key Vault
import {DefaultAzureCredential} from "@azure/identity";
import {Application} from "./application.js";
import {
    createApplication,
    setOnPremisesPublishing,
    updateApplicationConfig
} from "./applicationManager.js";
import {loadApps} from "./configuration.js";

const apps: Application[] = await loadApps()

console.log('Processing', apps)

// Azure SDK clients accept the credential as a parameter
const credential = new DefaultAzureCredential();

const {token} = await credential.getToken('https://graph.microsoft.com/.default');

apps.forEach(async (app) => {
    const applicationId = await createApplication({token, displayName: app.name});

    await updateApplicationConfig({token, externalUrl: app.onPremisesPublishing.externalUrl, appId: applicationId})
    await setOnPremisesPublishing({token, appId: applicationId, onPremisesPublishing: app.onPremisesPublishing})

    console.log('Created application successfully', app.name, applicationId)
})
