# Demostration webapps

These web applications are implemented using Java and can be deployed on a webserver like Tomcat (Tested on apache-tomcat-9.0.58).
All these apps are themed to represent a hypothetical insurance company named "Guardio".

Each can be used to connect with and Identity Provider using the OpenID Connect Protocol.
In order to do that the IdP and the application redirect URLs that need to be communicated to the IdP on request should be configured in WEB-INF/classes/distpatch.properties file

## Adding Branding

### Add Branding via Asgardeo Console

To configure branding from the Asgardeo Console UI, follow the steps below.

1. Go to [https://console.asgardeo.io](https://console.asgardeo.io) and login to your account.
2. Navigate to `Develop` -> `Branding`
3. Configure the `Gerenal`, `Design` and `Advanced` settings.

### Adding a CSS override stylesheet

At the moment, adding a CSS stylesheet via the Console UI is not permitted.
Hence, you have to use the Branding Preferences API to add a stylesheet.

#### Endpoint

```shell
https://api.asgardeo.io/t/<ORGANIZATION>/api/server/v1/branding-preference
```

#### Sample Payload

Following is a sample payload (domain name - `guardio`).

```json
{
 "type": "ORG",
 "name": "guardio",
 "locale": "en-US",
 "preference": {
  "colors": {
   "primary": "#262565"
  },
  "configs": {
   "isBrandingEnabled": true,
   "removeAsgardeoBranding": false
  },
  "images": {
   "favicon": {
    "imgURL": "https://cdn.statically.io/gh/malithie/demo-java-webapps/main/branding/images/favicon.ico"
   },
   "logo": {
    "altText": "Guardio Insurance Logo",
    "imgURL": "https://cdn.statically.io/gh/malithie/demo-java-webapps/main/branding/images/logo.svg"
   }
  },
  "organizationDetails": {
   "copyrightText": "© 2022 Guardio Insurance",
   "siteTitle": "Login - Guardio Insurance",
   "supportEmail": "support@guardio.com"
  },
  "stylesheets": {
   "accountApp": "https://cdn.statically.io/gh/malithie/demo-java-webapps/main/branding/stylesheets/login-portal.overrides.css"
  },
  "urls": {
   "cookiePolicyURL": "",
   "privacyPolicyURL": "",
   "termsOfUseURL": ""
  }
 }
}
```
