export type OnPremisesPublishing = {
  externalAuthenticationType: "aadPreAuthentication";
  externalUrl: string;
  internalUrl: string;
  isHttpOnlyCookieEnabled: boolean;
  isOnPremPublishingEnabled: boolean;
  isPersistentCookieEnabled: boolean;
  isSecureCookieEnabled: boolean;
  isTranslateHostHeaderEnabled: boolean;
  isTranslateLinksInBodyEnabled: boolean;
};
