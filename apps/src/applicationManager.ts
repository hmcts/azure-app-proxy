import {OnPremisesPublishing} from "./onPremisesPublishing.js";

async function errorHandler(when: string, result: Response) {
    if (!result.ok) {
        console.log(`Error ${when}`, result.status)
        console.log(result.statusText)
        console.log(await result.json())
        // @ts-ignore
        process.exit(1)
    }
}

export async function createApplication({token, displayName}: { token: string, displayName: string }): Promise<string> {
    const id = await findExistingApplication({token, displayName})
    if (id) {
        console.log('Found existing application', displayName, id)
        return id
    }

    console.log('Creating application', displayName)
    const result = await fetch('https://graph.microsoft.com/v1.0/applicationTemplates/8adf8e6e-67b2-4cf2-a259-e3dc5476c621/instantiate', {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            displayName
        })
    })

    const body = await result.json()
    await errorHandler('creating application', result);

    await waitTillApplicationExists({token, appId: body.application.id});

    return body.application.id

}

export async function findExistingApplication({token, displayName}: {token: string, displayName: string}): Promise<string | undefined> {
    const result = await fetch(`https://graph.microsoft.com/v1.0/applications?$filter=displayName eq '${displayName}'&$top=1&$select=id`, {
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${token}`,
        },
    })

    await errorHandler('searching for application', result)

    const body = await result.json()

    if (body.value.length === 1) {
        return body.value[0].id
    }
    return undefined
}

async function waitTillApplicationExists({appId, token}: { appId: string; token: string }) {

    async function handler() {
        const result = await fetch(`https://graph.microsoft.com/v1.0/applications/${appId}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
            },
        })

        if (!result.ok && result.status !== 404) {
            console.log('Unexpected error reading application', result.status)
            console.log(result.statusText)
            console.log(await result.json())
        }

        return result.ok
    }

    let attempt = 0
    while (true) {
        attempt++
        const result = await handler()
        if (result) {
            return
        }

        console.log('Waiting for application to be created, attempt', attempt)
        // Could do exponential backoff by combining with attempt
        const sleepSeconds = 2
        await new Promise(resolve => setTimeout(resolve, sleepSeconds * 1000));

        const maxAttempts = 30
        if (attempt > maxAttempts) {
            console.log(`Failed to find application after ${maxAttempts} attempts`)
            // @ts-ignore
            process.exit(1)
        }
    }
}

export async function updateApplicationConfig({token, appId, externalUrl}: {
    token: string,
    appId: string,
    externalUrl: string
}): Promise<void> {
    const result = await fetch(`https://graph.microsoft.com/v1.0/applications/${appId}`, {
        method: 'PATCH',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            identifierUris: [
                externalUrl
            ],
            web: {
                redirectUris: [
                    externalUrl
                ],
                homePageUrl: externalUrl
            }
        })
    })

    await errorHandler('updating application config', result)
}

export async function setOnPremisesPublishing({token, appId, onPremisesPublishing}: {
    appId: string;
    onPremisesPublishing: OnPremisesPublishing;
    token: string
}): Promise<void> {
    const result = await fetch(`https://graph.microsoft.com/beta/applications/${appId}`, {
        method: 'PATCH',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            onPremisesPublishing
        })
    })

    await errorHandler('setting onPremisesPublishing', result)
}