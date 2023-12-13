import { OnPremisesPublishing } from "./onPremisesPublishing.js";
import { errorHandler } from "./errorHandler.js";

export async function readApplication({
    token,
    applicationId,
}: {
    token: string;
    applicationId: string;
}) {
    console.log("Retrieving application", applicationId);
    const result = await fetch(
        `https://graph.microsoft.com/v1.0/applications/${applicationId}`,
        {
        method: "GET",
        headers: {
            Authorization: `Bearer ${token}`,
        },
        },
    );

    await errorHandler("reading application", result);

    return await result.json();
}

export async function setOnPremisesPublishing({
token,
appId,
onPremisesPublishing,
}: {
    appId: string;
    onPremisesPublishing: OnPremisesPublishing;
    token: string;
}): Promise<void> {
    const result = await fetch(
        `https://graph.microsoft.com/beta/applications/${appId}`,
        {
        method: "PATCH",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            onPremisesPublishing,
        }),
        },
    );

    await errorHandler("setting onPremisesPublishing", result);
}

export async function setResourceAccess({
token,
applicationId,
graphApiPermissions,
}: {
token: string;
applicationId: string;
graphApiPermissions: Array<string>;
}) {
if (graphApiPermissions && graphApiPermissions.length > 0) {
    const graphAppId = "00000003-0000-0000-c000-000000000000";
    console.log("Granting graphapi permissions");

    const {
    appRoleIds,
    graphAPIObjectId,
    }: { appRoleIds: string[]; graphAPIObjectId: any } = await getGraphAPIRoles(
    token,
    graphApiPermissions,
    );

    const application = await readApplication({ token, applicationId });

    let requiredResourceAccess = application.requiredResourceAccess ?? [];

    const graphPerms = {
    resourceAppId: graphAppId,
    resourceAccess: appRoleIds.map((id) => ({ id, type: "Role" })),
    };

    let graphPermsFound = false;

    for (let i = 0; i < requiredResourceAccess.length; i++) {
    if (requiredResourceAccess[i].resourceAppId === graphAppId) {
        requiredResourceAccess[i].resourceAccess = graphPerms.resourceAccess;
        graphPermsFound = true;
        break; // Assuming you want to replace only the first match
    }
    }

    if (!graphPermsFound) {
    requiredResourceAccess.push(graphPerms);
    }

    const body = {
    requiredResourceAccess: requiredResourceAccess,
    };

    const assignRolesResult = await fetch(
    `https://graph.microsoft.com/v1.0/applications/${applicationId}`,
    {
        method: "PATCH",
        headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
    },
    );
    await errorHandler("Granting graph api permissions", assignRolesResult);
}
}
async function getGraphAPIRoles(token: string, graphApiPermissions: string[]) {
const graphAPIIDResult = await fetch(
    `https://graph.microsoft.com/v1.0/servicePrincipals?$filter=displayName eq 'Microsoft Graph'&$select=id,appRoles`,
    {
    method: "GET",
    headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
    },
    },
);
await errorHandler("Getting Graph API Object ID", graphAPIIDResult);

const graphAPIObject = (await graphAPIIDResult.json()).value[0];
const graphAPIObjectId = graphAPIObject.id;
const graphAPIAppRoles = graphAPIObject.appRoles;

const appRoleIds: string[] = [];

for (const appRole of graphAPIAppRoles) {
    if (graphApiPermissions.includes(appRole.value)) {
    appRoleIds.push(appRole.id);
    }
}
return { appRoleIds, graphAPIObjectId };
}