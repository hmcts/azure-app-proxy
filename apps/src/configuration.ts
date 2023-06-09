import yaml from "js-yaml";
import { promises as fsPromises } from "fs";
import { Application } from "./application.js";
import path from "path";
import { fileURLToPath } from "url";

// TODO merge with config
function defaultOnPremisesFlags(): {
  externalAuthenticationType: "aadPreAuthentication";
  isHttpOnlyCookieEnabled: boolean;
  isOnPremPublishingEnabled: boolean;
  isPersistentCookieEnabled: boolean;
  isSecureCookieEnabled: boolean;
  isTranslateHostHeaderEnabled: boolean;
  isTranslateLinksInBodyEnabled: boolean;
} {
  return {
    externalAuthenticationType: "aadPreAuthentication",
    isHttpOnlyCookieEnabled: true,
    isOnPremPublishingEnabled: true,
    isPersistentCookieEnabled: true,
    isSecureCookieEnabled: true,
    isTranslateHostHeaderEnabled: true,
    isTranslateLinksInBodyEnabled: false,
  };
}

// https://flaviocopes.com/fix-dirname-not-defined-es-module-scope/
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export async function loadApps(): Promise<Application[]> {
  const file = await fsPromises.readFile(
    __dirname + "/../../apps.yaml",
    "utf8"
  );
  const yamlApps: any = yaml.load(file);
  return yamlApps.apps.map((app: any) => {
    const application: Application = {
      name: app.name,
      logoUrl: app.logoUrl,
      appRoleAssignmentRequired:
        app.userAssignmentRequired === undefined
          ? true
          : app.userAssignmentRequired,
      appRoleAssignments:
        app.appRoleAssignments === undefined ? [] : app.appRoleAssignments,
      onPremisesPublishing: {
        externalUrl: app.externalUrl,
        internalUrl: app.internalUrl,
        ...defaultOnPremisesFlags(),
      },
    };
    return application;
  });
}
