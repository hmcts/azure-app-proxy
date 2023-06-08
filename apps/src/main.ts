// Azure authentication library to access Azure Key Vault
import {DefaultAzureCredential} from "@azure/identity";
import {Application} from "./application.js";
import {
    createApplication,
    setOnPremisesPublishing,
    updateApplicationConfig
} from "./applicationManager.js";

// TODO merge with config
function defaultOnPremisesFlags(): {
    externalAuthenticationType: 'aadPreAuthentication',
    isHttpOnlyCookieEnabled: boolean
    isOnPremPublishingEnabled: boolean
    isPersistentCookieEnabled: boolean
    isSecureCookieEnabled: boolean
    isTranslateHostHeaderEnabled: boolean
    isTranslateLinksInBodyEnabled: boolean
} {
    return {
        externalAuthenticationType: 'aadPreAuthentication',
        isHttpOnlyCookieEnabled: true,
        isOnPremPublishingEnabled: true,
        isPersistentCookieEnabled: true,
        isSecureCookieEnabled: true,
        isTranslateHostHeaderEnabled: true,
        isTranslateLinksInBodyEnabled: false,
    }
}

// TODO load from yaml config file
const app: Application = {
    name: 'My App5',
    onPremisesPublishing: {
        externalUrl: 'https://contosoiwaapp10-1dwnh4.msappproxy.net',
        internalUrl: 'https://some-app3.sandbox.platform.hmcts.net',
        ...defaultOnPremisesFlags()
    }
}

// Azure SDK clients accept the credential as a parameter
const credential = new DefaultAzureCredential();

const {token} = await credential.getToken('https://graph.microsoft.com/.default');

const applicationId = await createApplication({token, displayName: app.name});

await updateApplicationConfig({token, externalUrl: app.onPremisesPublishing.externalUrl, appId: applicationId})

await setOnPremisesPublishing({token, appId: applicationId, onPremisesPublishing: app.onPremisesPublishing})

console.log('Created application successfully', app.name, applicationId)