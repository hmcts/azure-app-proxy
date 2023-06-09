// Azure authentication library to access Azure Key Vault
import { DefaultAzureCredential } from "@azure/identity";
import { Application } from "./application.js";
import {
  createApplication,
  setLogo,
  setOnPremisesPublishing,
  updateApplicationConfig,
} from "./applicationManager.js";
import { loadApps } from "./configuration.js";
import {
  assignGroups,
  setUserAssignmentRequired,
} from "./servicePrincipalManager.js";

const apps: Application[] = await loadApps();

console.log("Processing", apps);

// Azure SDK clients accept the credential as a parameter
const credential = new DefaultAzureCredential();

const { token } = await credential.getToken(
  "https://graph.microsoft.com/.default"
);

/**
 * Guides used to create this:
 * - https://learn.microsoft.com/en-us/graph/application-proxy-configure-api?tabs=http
 * - https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/assign-user-or-group-access-portal?pivots=ms-graph
 */
for await (const app of apps) {
  const { applicationId, servicePrincipalObjectId } = await createApplication({
    token,
    displayName: app.name,
  });

  await updateApplicationConfig({
    token,
    externalUrl: app.onPremisesPublishing.externalUrl,
    appId: applicationId,
  });

  await setLogo({ token, appId: applicationId, logoUrl: app.logoUrl });
  await setOnPremisesPublishing({
    token,
    appId: applicationId,
    onPremisesPublishing: app.onPremisesPublishing,
  });

  await setUserAssignmentRequired({
    token,
    objectId: servicePrincipalObjectId,
    assignmentRequired: app.appRoleAssignmentRequired,
  });
  await assignGroups({
    token,
    objectId: servicePrincipalObjectId,
    groups: app.appRoleAssignments,
  });
  // TODO SSL certificate

  console.log("Created application successfully", app.name, applicationId);
}
