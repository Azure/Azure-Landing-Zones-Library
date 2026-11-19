---
title: Policy Set Definitions
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `*.alz_policy_set_definition.json`

These files represent Azure Policy Set (initiative) definitions.
They are files that represent the resource definition as per the schema.
The file type is JSON.
Any keys that are not part of the schema should be ignored.

Within the resource definition, there are several values that specific to the scope of the deployed resource and must be modified when the assignment is deployed in an architecture.

These are:

- The resource id
- The resource ids of the custom policy definitions that are part of the policy set

[Clients](/Azure-Landing-Zones-Library/clients) should be aware of these values and ensure that they are correctly set when deploying the resource.

## Private endpoint DNS zone groups

The `Deploy-Private-DNS-Zones` initiative includes API Management (`Gateway`),
Azure SQL logical servers (`sqlServer`), MySQL Single and Flexible Servers
(`mysqlServer`), Static Web Apps (`staticSites`), and Cognitive Services accounts
(`account`, including OpenAI and AI Services).

Provide existing zone resource IDs through `azureApiManagementPrivateDnsZoneId`,
`azureSQLPrivateDnsZoneId`, `azureMySQLPrivateDnsZoneId`,
`azureStaticWebAppsPrivateDnsZoneId`, `azureOpenAIPrivateDnsZoneId`, and
`azureAIServicesPrivateDnsZoneId`. Alternatively, use the existing
`dnsZoneSubscriptionId` and `dnsZoneResourceGroupName` parameters to construct
these IDs from `dnsZoneNames`. These policies configure zone groups; they do not
create DNS zones or virtual network links.

The Cognitive Services reference uses a single custom policy rather than
competing policies for the same endpoint. An `OpenAI` account uses
`privatelink.openai.azure.com`; an `AIServices` account uses that zone together
with `privatelink.services.ai.azure.com` and the existing
`privatelink.cognitiveservices.azure.com` zone. Other account kinds retain the
Cognitive Services zone.

For Static Web Apps, supply the ID of `privatelink.azurestaticapps.net`. The policy
reads the app's `defaultHostname` and selects either that zone or
`privatelink.<partitionId>.azurestaticapps.net` in the same subscription and
resource group. Create the required zones before remediation. The audit/deny
list includes the unpartitioned zone and partitions 1 through 5, matching the
private-link DNS pattern module's defaults. The deployment policy can also
select future partitions when their zones have been provisioned.

Like the previous Cognitive Services built-in, these policies deploy only when
no zone group exists. They preserve existing
groups, including groups managed by application IaC. Existing OpenAI or AI Services
endpoints that were configured with the wrong zone must have their zone group
corrected by its owner; this change does not automatically migrate existing groups.
Private endpoints support only one zone group, so do not run remediation against
an endpoint whose DNS configuration is owned by another deployment.

These policies handle both automatic and manual private-link service connections,
without restricting the endpoint region. Remediation needs Network Contributor
access to the endpoint and central DNS zones. The Cognitive Services and Static
Web Apps policies also need Reader access to the target account or app, including
when it is in another subscription. Update the assignment identity's role grants
when upgrading an existing assignment; listing a role in a policy definition does
not itself grant that role.
