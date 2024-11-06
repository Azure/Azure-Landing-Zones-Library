# ALZ (Azure Landing Zones)
  
This library provides the reference set of Azure Landing Zones (ALZ) policies, archetypes, and management group architecture.
  
## Usage
  
```terraform
provider "alz" {
  library_references = [
    {
      path = "platform/alz"
      tag  = "0000.00.0" # Replace with the desired version
    }
  ]
}
```
  
## Architectures
  
The following architectures are available in this library, please note that the diagrams denote the management group display name and, in brackets, the associated archetypes:
  
### architecture `alz`
  
> [!NOTE]  
> This hierarchy will be deployed as a child of the user-supplied root management group.
  
```mermaid
flowchart TD
  alzroot["ALZ root
(root)"]
  alzroot --> decommissioned
  decommissioned["Decommissioned
(decommissioned)"]
  alzroot --> landingzones
  landingzones["Landing zones
(landing_zones)"]
  landingzones --> corp
  corp["Corp
(corp)"]
  landingzones --> online
  online["Online
(online)"]
  alzroot --> platform
  platform["Platform
(platform)"]
  platform --> connectivity
  connectivity["Connectivity
(connectivity)"]
  platform --> identity
  identity["Identity
(identity)"]
  platform --> management
  management["Management
(management)"]
  alzroot --> sandboxes
  sandboxes["Sandboxes
(sandboxes)"]

```
  
## Archetypes
  
### archetype `connectivity`
  
#### connectivity policy assignments
  
<details><summary>1 policy assignments</summary>

- Enable-DDoS-VNET
</details>
  
### archetype `corp`
  
#### corp policy assignments
  
<details><summary>5 policy assignments</summary>

- Audit-PeDnsZones
- Deny-HybridNetworking
- Deny-Public-Endpoints
- Deny-Public-IP-On-NIC
- Deploy-Private-DNS-Zones
</details>
  
### archetype `decommissioned`
  
#### decommissioned policy assignments
  
<details><summary>1 policy assignments</summary>

- Enforce-ALZ-Decomm
</details>
  
### archetype `identity`
  
#### identity policy assignments
  
<details><summary>4 policy assignments</summary>

- Deny-MgmtPorts-Internet
- Deny-Public-IP
- Deny-Subnet-Without-Nsg
- Deploy-VM-Backup
</details>
  
### archetype `landing_zones`
  
#### landing_zones policy assignments
  
<details><summary>25 policy assignments</summary>

- Audit-AppGW-WAF
- Deny-IP-forwarding
- Deny-MgmtPorts-Internet
- Deny-Priv-Esc-AKS
- Deny-Privileged-AKS
- Deny-Storage-http
- Deny-Subnet-Without-Nsg
- Deploy-AzSqlDb-Auditing
- Deploy-MDFC-DefSQL-AMA
- Deploy-SQL-TDE
- Deploy-SQL-Threat
- Deploy-VM-Backup
- Deploy-VM-ChangeTrack
- Deploy-VM-Monitoring
- Deploy-VMSS-ChangeTrack
- Deploy-VMSS-Monitoring
- Deploy-vmArc-ChangeTrack
- Deploy-vmHybr-Monitoring
- Enable-AUM-CheckUpdates
- Enable-DDoS-VNET
- Enforce-AKS-HTTPS
- Enforce-ASR
- Enforce-GR-KeyVault
- Enforce-Subnet-Private
- Enforce-TLS-SSL-H224
</details>
  
### archetype `platform`
  
#### platform policy assignments
  
<details><summary>12 policy assignments</summary>

- DenyAction-DeleteUAMIAMA
- Deploy-MDFC-DefSQL-AMA
- Deploy-VM-ChangeTrack
- Deploy-VM-Monitoring
- Deploy-VMSS-ChangeTrack
- Deploy-VMSS-Monitoring
- Deploy-vmArc-ChangeTrack
- Deploy-vmHybr-Monitoring
- Enable-AUM-CheckUpdates
- Enforce-ASR
- Enforce-GR-KeyVault
- Enforce-Subnet-Private
</details>
  
### archetype `root`
  
#### root policy definitions
  
<details><summary>158 policy definitions</summary>

- Append-AppService-httpsonly
- Append-AppService-latestTLS
- Append-KV-SoftDelete
- Append-Redis-disableNonSslPort
- Append-Redis-sslEnforcement
- Audit-AzureHybridBenefit
- Audit-Disks-UnusedResourcesCostOptimization
- Audit-MachineLearning-PrivateEndpointId
- Audit-PrivateLinkDnsZones
- Audit-PublicIpAddresses-UnusedResourcesCostOptimization
- Audit-ServerFarms-UnusedResourcesCostOptimization
- Deny-AA-child-resources
- Deny-APIM-TLS
- Deny-AppGW-Without-WAF
- Deny-AppGw-Without-Tls
- Deny-AppService-without-BYOC
- Deny-AppServiceApiApp-http
- Deny-AppServiceFunctionApp-http
- Deny-AppServiceWebApp-http
- Deny-AzFw-Without-Policy
- Deny-CognitiveServices-NetworkAcls
- Deny-CognitiveServices-Resource-Kinds
- Deny-CognitiveServices-RestrictOutboundNetworkAccess
- Deny-Databricks-NoPublicIp
- Deny-Databricks-Sku
- Deny-Databricks-VirtualNetwork
- Deny-EH-Premium-CMK
- Deny-EH-minTLS
- Deny-FileServices-InsecureAuth
- Deny-FileServices-InsecureKerberos
- Deny-FileServices-InsecureSmbChannel
- Deny-FileServices-InsecureSmbVersions
- Deny-LogicApp-Public-Network
- Deny-LogicApps-Without-Https
- Deny-MachineLearning-Aks
- Deny-MachineLearning-Compute-SubnetId
- Deny-MachineLearning-Compute-VmSize
- Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess
- Deny-MachineLearning-ComputeCluster-Scale
- Deny-MachineLearning-HbiWorkspace
- Deny-MachineLearning-PublicAccessWhenBehindVnet
- Deny-MachineLearning-PublicNetworkAccess
- Deny-MgmtPorts-From-Internet
- Deny-MySql-http
- Deny-PostgreSql-http
- Deny-Private-DNS-Zones
- Deny-PublicEndpoint-MariaDB
- Deny-PublicIP
- Deny-RDP-From-Internet
- Deny-Redis-http
- Deny-Service-Endpoints
- Deny-Sql-minTLS
- Deny-SqlMi-minTLS
- Deny-Storage-ContainerDeleteRetentionPolicy
- Deny-Storage-CopyScope
- Deny-Storage-CorsRules
- Deny-Storage-LocalUser
- Deny-Storage-NetworkAclsBypass
- Deny-Storage-NetworkAclsVirtualNetworkRules
- Deny-Storage-ResourceAccessRulesResourceId
- Deny-Storage-ResourceAccessRulesTenantId
- Deny-Storage-SFTP
- Deny-Storage-ServicesEncryption
- Deny-Storage-minTLS
- Deny-StorageAccount-CustomDomain
- Deny-Subnet-Without-Nsg
- Deny-Subnet-Without-Penp
- Deny-Subnet-Without-Udr
- Deny-UDR-With-Specific-NextHop
- Deny-VNET-Peer-Cross-Sub
- Deny-VNET-Peering-To-Non-Approved-VNETs
- Deny-VNet-Peering
- DenyAction-ActivityLogs
- DenyAction-DeleteResources
- DenyAction-DiagnosticLogs
- Deploy-ASC-SecurityContacts
- Deploy-Budget
- Deploy-Custom-Route-Table
- Deploy-DDoSProtection
- Deploy-Diagnostics-AA
- Deploy-Diagnostics-ACI
- Deploy-Diagnostics-ACR
- Deploy-Diagnostics-APIMgmt
- Deploy-Diagnostics-AVDScalingPlans
- Deploy-Diagnostics-AnalysisService
- Deploy-Diagnostics-ApiForFHIR
- Deploy-Diagnostics-ApplicationGateway
- Deploy-Diagnostics-Bastion
- Deploy-Diagnostics-CDNEndpoints
- Deploy-Diagnostics-CognitiveServices
- Deploy-Diagnostics-CosmosDB
- Deploy-Diagnostics-DLAnalytics
- Deploy-Diagnostics-DataExplorerCluster
- Deploy-Diagnostics-DataFactory
- Deploy-Diagnostics-Databricks
- Deploy-Diagnostics-EventGridSub
- Deploy-Diagnostics-EventGridSystemTopic
- Deploy-Diagnostics-EventGridTopic
- Deploy-Diagnostics-ExpressRoute
- Deploy-Diagnostics-Firewall
- Deploy-Diagnostics-FrontDoor
- Deploy-Diagnostics-Function
- Deploy-Diagnostics-HDInsight
- Deploy-Diagnostics-LoadBalancer
- Deploy-Diagnostics-LogAnalytics
- Deploy-Diagnostics-LogicAppsISE
- Deploy-Diagnostics-MariaDB
- Deploy-Diagnostics-MediaService
- Deploy-Diagnostics-MlWorkspace
- Deploy-Diagnostics-MySQL
- Deploy-Diagnostics-NIC
- Deploy-Diagnostics-NetworkSecurityGroups
- Deploy-Diagnostics-PostgreSQL
- Deploy-Diagnostics-PowerBIEmbedded
- Deploy-Diagnostics-RedisCache
- Deploy-Diagnostics-Relay
- Deploy-Diagnostics-SQLElasticPools
- Deploy-Diagnostics-SQLMI
- Deploy-Diagnostics-SignalR
- Deploy-Diagnostics-TimeSeriesInsights
- Deploy-Diagnostics-TrafficManager
- Deploy-Diagnostics-VM
- Deploy-Diagnostics-VMSS
- Deploy-Diagnostics-VNetGW
- Deploy-Diagnostics-VWanS2SVPNGW
- Deploy-Diagnostics-VirtualNetwork
- Deploy-Diagnostics-WVDAppGroup
- Deploy-Diagnostics-WVDHostPools
- Deploy-Diagnostics-WVDWorkspace
- Deploy-Diagnostics-WebServerFarm
- Deploy-Diagnostics-Website
- Deploy-Diagnostics-iotHub
- Deploy-FirewallPolicy
- Deploy-LogicApp-TLS
- Deploy-MDFC-Arc-SQL-DCR-Association
- Deploy-MDFC-Arc-Sql-DefenderSQL-DCR
- Deploy-MDFC-SQL-AMA
- Deploy-MDFC-SQL-DefenderSQL
- Deploy-MDFC-SQL-DefenderSQL-DCR
- Deploy-MySQL-sslEnforcement
- Deploy-Nsg-FlowLogs
- Deploy-Nsg-FlowLogs-to-LA
- Deploy-PostgreSQL-sslEnforcement
- Deploy-Private-DNS-Generic
- Deploy-SQL-minTLS
- Deploy-Sql-AuditingSettings
- Deploy-Sql-SecurityAlertPolicies
- Deploy-Sql-Tde
- Deploy-Sql-vulnerabilityAssessments
- Deploy-Sql-vulnerabilityAssessments_20230706
- Deploy-SqlMi-minTLS
- Deploy-Storage-sslEnforcement
- Deploy-UserAssignedManagedIdentity-VMInsights
- Deploy-VNET-HubSpoke
- Deploy-Vm-autoShutdown
- Deploy-Windows-DomainJoin
- Modify-NSG
- Modify-UDR
</details>
  
#### root policy set definitions
  
<details><summary>46 policy set definitions</summary>

- Audit-TrustedLaunch
- Audit-UnusedResourcesCostOptimization
- Deny-PublicPaaSEndpoints
- DenyAction-DeleteProtection
- Deploy-AUM-CheckUpdates
- Deploy-Diagnostics-LogAnalytics
- Deploy-MDFC-Config
- Deploy-MDFC-Config_20240319
- Deploy-MDFC-DefenderSQL-AMA
- Deploy-Private-DNS-Zones
- Deploy-Sql-Security
- Deploy-Sql-Security_20240529
- Enforce-ACSB
- Enforce-ALZ-Decomm
- Enforce-ALZ-Sandbox
- Enforce-Backup
- Enforce-EncryptTransit
- Enforce-EncryptTransit_20240509
- Enforce-Encryption-CMK
- Enforce-Guardrails-APIM
- Enforce-Guardrails-AppServices
- Enforce-Guardrails-Automation
- Enforce-Guardrails-BotService
- Enforce-Guardrails-CognitiveServices
- Enforce-Guardrails-Compute
- Enforce-Guardrails-ContainerApps
- Enforce-Guardrails-ContainerInstance
- Enforce-Guardrails-ContainerRegistry
- Enforce-Guardrails-CosmosDb
- Enforce-Guardrails-DataExplorer
- Enforce-Guardrails-DataFactory
- Enforce-Guardrails-EventGrid
- Enforce-Guardrails-EventHub
- Enforce-Guardrails-KeyVault
- Enforce-Guardrails-KeyVault-Sup
- Enforce-Guardrails-Kubernetes
- Enforce-Guardrails-MachineLearning
- Enforce-Guardrails-MySQL
- Enforce-Guardrails-Network
- Enforce-Guardrails-OpenAI
- Enforce-Guardrails-PostgreSQL
- Enforce-Guardrails-SQL
- Enforce-Guardrails-ServiceBus
- Enforce-Guardrails-Storage
- Enforce-Guardrails-Synapse
- Enforce-Guardrails-VirtualDesktop
</details>
  
#### root policy assignments
  
<details><summary>15 policy assignments</summary>

- Audit-ResourceRGLocation
- Audit-TrustedLaunch
- Audit-UnusedResources
- Audit-ZoneResiliency
- Deny-Classic-Resources
- Deny-UnmanagedDisk
- Deploy-ASC-Monitoring
- Deploy-AzActivity-Log
- Deploy-Diag-LogsCat
- Deploy-MDEndpoints
- Deploy-MDEndpointsAMA
- Deploy-MDFC-Config-H224
- Deploy-MDFC-OssDb
- Deploy-MDFC-SqlAtp
- Enforce-ACSB
</details>
  
#### root role definitions
  
<details><summary>5 role definitions</summary>

- Application-Owners
- Network-Management
- Network-Subnet-Contributor
- Security-Operations
- Subscription-Owner
</details>
  
### archetype `sandboxes`
  
#### sandboxes policy assignments
  
<details><summary>1 policy assignments</summary>

- Enforce-ALZ-Sandbox
</details>
  
## Policy Default Values
  
The following policy default values are available in this library:
  
### default name `ama_change_tracking_data_collection_rule_id`
  
The data collection rule id that should be used for the change tracking deployment.
  
|        ASSIGNMENT        | PARAMETER NAMES |
|--------------------------|-----------------|
| Deploy-VM-ChangeTrack    | dcrResourceId   |
| Deploy-VMSS-ChangeTrack  | dcrResourceId   |
| Deploy-vmArc-ChangeTrack | dcrResourceId   |

  
### default name `ama_mdfc_sql_data_collection_rule_id`
  
The data collection rule id that should be used for the SQL MDFC deployment.
  
|       ASSIGNMENT       | PARAMETER NAMES |
|------------------------|-----------------|
| Deploy-MDFC-DefSQL-AMA | dcrResourceId   |

  
### default name `ama_user_assigned_managed_identity_id`
  
The user assigned managed identity id that should be used for the AMA deployment.
  
|       ASSIGNMENT        |        PARAMETER NAMES         |
|-------------------------|--------------------------------|
| Deploy-MDFC-DefSQL-AMA  | userAssignedIdentityResourceId |
| Deploy-VM-ChangeTrack   | userAssignedIdentityResourceId |
| Deploy-VM-Monitoring    | userAssignedIdentityResourceId |
| Deploy-VMSS-ChangeTrack | userAssignedIdentityResourceId |
| Deploy-VMSS-Monitoring  | userAssignedIdentityResourceId |

  
### default name `ama_user_assigned_managed_identity_name`
  
The user assigned managed identity name that is used for the deny action policy to prevent the accidental deletion of the AMA identity.
  
|        ASSIGNMENT        | PARAMETER NAMES |
|--------------------------|-----------------|
| DenyAction-DeleteUAMIAMA | resourceName    |

  
### default name `ama_vm_insights_data_collection_rule_id`
  
The data collection rule id that should be used for the VM Insights deployment.
  
|        ASSIGNMENT        | PARAMETER NAMES |
|--------------------------|-----------------|
| Deploy-VM-Monitoring     | dcrResourceId   |
| Deploy-VMSS-Monitoring   | dcrResourceId   |
| Deploy-vmHybr-Monitoring | dcrResourceId   |

  
### default name `ddos_protection_plan_id`
  
The DDoS protection plan id that should be used for the DDoS protection plan deployment. If this is invalid or you do not use DDoS protection, make sure to change the enforcement mode of the Enable-DDoS-VNET policy to 'DoNotEnforce'.
  
|    ASSIGNMENT    | PARAMETER NAMES |
|------------------|-----------------|
| Enable-DDoS-VNET | ddosPlan        |

  
### default name `log_analytics_workspace_id`
  
The Log Analytics workspace id that should be used for centralized log collection.
  
|       ASSIGNMENT        |     PARAMETER NAMES     |
|-------------------------|-------------------------|
| Deploy-AzActivity-Log   | logAnalytics            |
| Deploy-AzSqlDb-Auditing | logAnalyticsWorkspaceId |
| Deploy-Diag-LogsCat     | logAnalytics            |
| Deploy-MDFC-Config-H224 | logAnalytics            |
| Deploy-MDFC-DefSQL-AMA  | userWorkspaceResourceId |

  
### default name `private_dns_bot_service`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureBotServicePrivateDnsZoneId |

  
### default name `private_dns_databricks`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureDatabricksPrivateDnsZoneId |

  
### default name `private_dns_iot_central`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureIotCentralPrivateDnsZoneId |

  
### default name `private_dns_iot_device_update`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |           PARAMETER NAMES            |
|--------------------------|--------------------------------------|
| Deploy-Private-DNS-Zones | azureIotDeviceupdatePrivateDnsZoneId |

  
### default name `private_dns_zone_acr`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |     PARAMETER NAMES      |
|--------------------------|--------------------------|
| Deploy-Private-DNS-Zones | azureAcrPrivateDnsZoneId |

  
### default name `private_dns_zone_app`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |     PARAMETER NAMES      |
|--------------------------|--------------------------|
| Deploy-Private-DNS-Zones | azureAppPrivateDnsZoneId |

  
### default name `private_dns_zone_app_services`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES          |
|--------------------------|----------------------------------|
| Deploy-Private-DNS-Zones | azureAppServicesPrivateDnsZoneId |

  
### default name `private_dns_zone_arc_guestconfiguration`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |              PARAMETER NAMES               |
|--------------------------|--------------------------------------------|
| Deploy-Private-DNS-Zones | azureArcGuestconfigurationPrivateDnsZoneId |

  
### default name `private_dns_zone_arc_hybrid_resource_provider`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |                PARAMETER NAMES                 |
|--------------------------|------------------------------------------------|
| Deploy-Private-DNS-Zones | azureArcHybridResourceProviderPrivateDnsZoneId |

  
### default name `private_dns_zone_arc_kubernetes_configuration`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |                 PARAMETER NAMES                 |
|--------------------------|-------------------------------------------------|
| Deploy-Private-DNS-Zones | azureArcKubernetesConfigurationPrivateDnsZoneId |

  
### default name `private_dns_zone_asr`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |     PARAMETER NAMES      |
|--------------------------|--------------------------|
| Deploy-Private-DNS-Zones | azureAsrPrivateDnsZoneId |

  
### default name `private_dns_zone_automation_dsc_hybrid`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |             PARAMETER NAMES              |
|--------------------------|------------------------------------------|
| Deploy-Private-DNS-Zones | azureAutomationDSCHybridPrivateDnsZoneId |

  
### default name `private_dns_zone_automation_webhook`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES             |
|--------------------------|----------------------------------------|
| Deploy-Private-DNS-Zones | azureAutomationWebhookPrivateDnsZoneId |

  
### default name `private_dns_zone_batch`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |      PARAMETER NAMES       |
|--------------------------|----------------------------|
| Deploy-Private-DNS-Zones | azureBatchPrivateDnsZoneId |

  
### default name `private_dns_zone_cognitive_search`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |           PARAMETER NAMES            |
|--------------------------|--------------------------------------|
| Deploy-Private-DNS-Zones | azureCognitiveSearchPrivateDnsZoneId |

  
### default name `private_dns_zone_cognitive_services`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES             |
|--------------------------|----------------------------------------|
| Deploy-Private-DNS-Zones | azureCognitiveServicesPrivateDnsZoneId |

  
### default name `private_dns_zone_cosmos_cassandra`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |           PARAMETER NAMES            |
|--------------------------|--------------------------------------|
| Deploy-Private-DNS-Zones | azureCosmosCassandraPrivateDnsZoneId |

  
### default name `private_dns_zone_cosmos_gremlin`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |          PARAMETER NAMES           |
|--------------------------|------------------------------------|
| Deploy-Private-DNS-Zones | azureCosmosGremlinPrivateDnsZoneId |

  
### default name `private_dns_zone_cosmos_mongo`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES          |
|--------------------------|----------------------------------|
| Deploy-Private-DNS-Zones | azureCosmosMongoPrivateDnsZoneId |

  
### default name `private_dns_zone_cosmos_sql`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES         |
|--------------------------|--------------------------------|
| Deploy-Private-DNS-Zones | azureCosmosSQLPrivateDnsZoneId |

  
### default name `private_dns_zone_cosmos_table`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES          |
|--------------------------|----------------------------------|
| Deploy-Private-DNS-Zones | azureCosmosTablePrivateDnsZoneId |

  
### default name `private_dns_zone_data_factory`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES          |
|--------------------------|----------------------------------|
| Deploy-Private-DNS-Zones | azureDataFactoryPrivateDnsZoneId |

  
### default name `private_dns_zone_data_factory_portal`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES             |
|--------------------------|----------------------------------------|
| Deploy-Private-DNS-Zones | azureDataFactoryPortalPrivateDnsZoneId |

  
### default name `private_dns_zone_disk_access`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureDiskAccessPrivateDnsZoneId |

  
### default name `private_dns_zone_event_grid_domains`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES            |
|--------------------------|---------------------------------------|
| Deploy-Private-DNS-Zones | azureEventGridDomainsPrivateDnsZoneId |

  
### default name `private_dns_zone_event_grid_topics`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |           PARAMETER NAMES            |
|--------------------------|--------------------------------------|
| Deploy-Private-DNS-Zones | azureEventGridTopicsPrivateDnsZoneId |

  
### default name `private_dns_zone_event_hub_namespace`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES             |
|--------------------------|----------------------------------------|
| Deploy-Private-DNS-Zones | azureEventHubNamespacePrivateDnsZoneId |

  
### default name `private_dns_zone_file`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |      PARAMETER NAMES      |
|--------------------------|---------------------------|
| Deploy-Private-DNS-Zones | azureFilePrivateDnsZoneId |

  
### default name `private_dns_zone_hdinsight`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES         |
|--------------------------|--------------------------------|
| Deploy-Private-DNS-Zones | azureHDInsightPrivateDnsZoneId |

  
### default name `private_dns_zone_iot`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |     PARAMETER NAMES      |
|--------------------------|--------------------------|
| Deploy-Private-DNS-Zones | azureIotPrivateDnsZoneId |

  
### default name `private_dns_zone_iot_hubs`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |       PARAMETER NAMES        |
|--------------------------|------------------------------|
| Deploy-Private-DNS-Zones | azureIotHubsPrivateDnsZoneId |

  
### default name `private_dns_zone_key_vault`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES        |
|--------------------------|-------------------------------|
| Deploy-Private-DNS-Zones | azureKeyVaultPrivateDnsZoneId |

  
### default name `private_dns_zone_machine_learning_workspace`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |                PARAMETER NAMES                |
|--------------------------|-----------------------------------------------|
| Deploy-Private-DNS-Zones | azureMachineLearningWorkspacePrivateDnsZoneId |

  
### default name `private_dns_zone_machine_learning_workspace_second`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |                   PARAMETER NAMES                   |
|--------------------------|-----------------------------------------------------|
| Deploy-Private-DNS-Zones | azureMachineLearningWorkspaceSecondPrivateDnsZoneId |

  
### default name `private_dns_zone_managed_grafana_workspace`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |               PARAMETER NAMES                |
|--------------------------|----------------------------------------------|
| Deploy-Private-DNS-Zones | azureManagedGrafanaWorkspacePrivateDnsZoneId |

  
### default name `private_dns_zone_media_services_key`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES            |
|--------------------------|---------------------------------------|
| Deploy-Private-DNS-Zones | azureMediaServicesKeyPrivateDnsZoneId |

  
### default name `private_dns_zone_media_services_live`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES             |
|--------------------------|----------------------------------------|
| Deploy-Private-DNS-Zones | azureMediaServicesLivePrivateDnsZoneId |

  
### default name `private_dns_zone_media_services_stream`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |             PARAMETER NAMES              |
|--------------------------|------------------------------------------|
| Deploy-Private-DNS-Zones | azureMediaServicesStreamPrivateDnsZoneId |

  
### default name `private_dns_zone_migrate`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |       PARAMETER NAMES        |
|--------------------------|------------------------------|
| Deploy-Private-DNS-Zones | azureMigratePrivateDnsZoneId |

  
### default name `private_dns_zone_monitor_1`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES        |
|--------------------------|-------------------------------|
| Deploy-Private-DNS-Zones | azureMonitorPrivateDnsZoneId1 |

  
### default name `private_dns_zone_monitor_2`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES        |
|--------------------------|-------------------------------|
| Deploy-Private-DNS-Zones | azureMonitorPrivateDnsZoneId2 |

  
### default name `private_dns_zone_monitor_3`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES        |
|--------------------------|-------------------------------|
| Deploy-Private-DNS-Zones | azureMonitorPrivateDnsZoneId3 |

  
### default name `private_dns_zone_monitor_4`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES        |
|--------------------------|-------------------------------|
| Deploy-Private-DNS-Zones | azureMonitorPrivateDnsZoneId4 |

  
### default name `private_dns_zone_monitor_5`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |        PARAMETER NAMES        |
|--------------------------|-------------------------------|
| Deploy-Private-DNS-Zones | azureMonitorPrivateDnsZoneId5 |

  
### default name `private_dns_zone_redis_cache`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureRedisCachePrivateDnsZoneId |

  
### default name `private_dns_zone_region`
  
The region short name (e.g. `westus`) that should be used for the region specific private link DNS zones.
  
|        ASSIGNMENT        | PARAMETER NAMES |
|--------------------------|-----------------|
| Deploy-Private-DNS-Zones | dnsZoneRegion   |

  
### default name `private_dns_zone_resource_group_name`
  
The resource group name that hosts the private link DNS zones.
  
|        ASSIGNMENT        |     PARAMETER NAMES      |
|--------------------------|--------------------------|
| Deploy-Private-DNS-Zones | dnsZoneResourceGroupName |

  
### default name `private_dns_zone_service_bus_namespace`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |             PARAMETER NAMES              |
|--------------------------|------------------------------------------|
| Deploy-Private-DNS-Zones | azureServiceBusNamespacePrivateDnsZoneId |

  
### default name `private_dns_zone_signal_r`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |       PARAMETER NAMES        |
|--------------------------|------------------------------|
| Deploy-Private-DNS-Zones | azureSignalRPrivateDnsZoneId |

  
### default name `private_dns_zone_site_recovery_backup`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |             PARAMETER NAMES             |
|--------------------------|-----------------------------------------|
| Deploy-Private-DNS-Zones | azureSiteRecoveryBackupPrivateDnsZoneId |

  
### default name `private_dns_zone_site_recovery_blob`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES            |
|--------------------------|---------------------------------------|
| Deploy-Private-DNS-Zones | azureSiteRecoveryBlobPrivateDnsZoneId |

  
### default name `private_dns_zone_site_recovery_queue`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES             |
|--------------------------|----------------------------------------|
| Deploy-Private-DNS-Zones | azureSiteRecoveryQueuePrivateDnsZoneId |

  
### default name `private_dns_zone_storage_blob`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES          |
|--------------------------|----------------------------------|
| Deploy-Private-DNS-Zones | azureStorageBlobPrivateDnsZoneId |

  
### default name `private_dns_zone_storage_blob_sec`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |           PARAMETER NAMES           |
|--------------------------|-------------------------------------|
| Deploy-Private-DNS-Zones | azureStorageBlobSecPrivateDnsZoneId |

  
### default name `private_dns_zone_storage_dfs`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureStorageDFSPrivateDnsZoneId |

  
### default name `private_dns_zone_storage_dfs_sec`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |          PARAMETER NAMES           |
|--------------------------|------------------------------------|
| Deploy-Private-DNS-Zones | azureStorageDFSSecPrivateDnsZoneId |

  
### default name `private_dns_zone_storage_file`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES          |
|--------------------------|----------------------------------|
| Deploy-Private-DNS-Zones | azureStorageFilePrivateDnsZoneId |

  
### default name `private_dns_zone_storage_queue`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |          PARAMETER NAMES          |
|--------------------------|-----------------------------------|
| Deploy-Private-DNS-Zones | azureStorageQueuePrivateDnsZoneId |

  
### default name `private_dns_zone_storage_queue_sec`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |           PARAMETER NAMES            |
|--------------------------|--------------------------------------|
| Deploy-Private-DNS-Zones | azureStorageQueueSecPrivateDnsZoneId |

  
### default name `private_dns_zone_storage_static_web`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |            PARAMETER NAMES            |
|--------------------------|---------------------------------------|
| Deploy-Private-DNS-Zones | azureStorageStaticWebPrivateDnsZoneId |

  
### default name `private_dns_zone_storage_static_web_sec`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |             PARAMETER NAMES              |
|--------------------------|------------------------------------------|
| Deploy-Private-DNS-Zones | azureStorageStaticWebSecPrivateDnsZoneId |

  
### default name `private_dns_zone_storage_table`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |          PARAMETER NAMES          |
|--------------------------|-----------------------------------|
| Deploy-Private-DNS-Zones | azureStorageTablePrivateDnsZoneId |

  
### default name `private_dns_zone_storage_table_secondary`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |              PARAMETER NAMES               |
|--------------------------|--------------------------------------------|
| Deploy-Private-DNS-Zones | azureStorageTableSecondaryPrivateDnsZoneId |

  
### default name `private_dns_zone_subscription_id`
  
The subscription id that hosts the private link DNS zones.
  
|        ASSIGNMENT        |    PARAMETER NAMES    |
|--------------------------|-----------------------|
| Deploy-Private-DNS-Zones | dnsZoneSubscriptionId |

  
### default name `private_dns_zone_synapse_dev`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureSynapseDevPrivateDnsZoneId |

  
### default name `private_dns_zone_synapse_sql`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |         PARAMETER NAMES         |
|--------------------------|---------------------------------|
| Deploy-Private-DNS-Zones | azureSynapseSQLPrivateDnsZoneId |

  
### default name `private_dns_zone_synapse_sql_od`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |          PARAMETER NAMES          |
|--------------------------|-----------------------------------|
| Deploy-Private-DNS-Zones | azureSynapseSQLODPrivateDnsZoneId |

  
### default name `private_dns_zone_virtual_desktop_hostpool`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |               PARAMETER NAMES               |
|--------------------------|---------------------------------------------|
| Deploy-Private-DNS-Zones | azureVirtualDesktopHostpoolPrivateDnsZoneId |

  
### default name `private_dns_zone_virtual_desktop_workspace`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |               PARAMETER NAMES                |
|--------------------------|----------------------------------------------|
| Deploy-Private-DNS-Zones | azureVirtualDesktopWorkspacePrivateDnsZoneId |

  
### default name `private_dns_zone_web`
  
DEPRECATED - please use private_dns_zone_region, private_dns_zone_resource_group_name, and private_dns_zone_subscription_id instead.
  
|        ASSIGNMENT        |     PARAMETER NAMES      |
|--------------------------|--------------------------|
| Deploy-Private-DNS-Zones | azureWebPrivateDnsZoneId |

  
---
## Contents
  
### all policy definitions
  
<details><summary>158 policy definitions</summary>

- Append-AppService-httpsonly
- Append-AppService-latestTLS
- Append-KV-SoftDelete
- Append-Redis-disableNonSslPort
- Append-Redis-sslEnforcement
- Audit-AzureHybridBenefit
- Audit-Disks-UnusedResourcesCostOptimization
- Audit-MachineLearning-PrivateEndpointId
- Audit-PrivateLinkDnsZones
- Audit-PublicIpAddresses-UnusedResourcesCostOptimization
- Audit-ServerFarms-UnusedResourcesCostOptimization
- Deny-AA-child-resources
- Deny-APIM-TLS
- Deny-AppGW-Without-WAF
- Deny-AppGw-Without-Tls
- Deny-AppService-without-BYOC
- Deny-AppServiceApiApp-http
- Deny-AppServiceFunctionApp-http
- Deny-AppServiceWebApp-http
- Deny-AzFw-Without-Policy
- Deny-CognitiveServices-NetworkAcls
- Deny-CognitiveServices-Resource-Kinds
- Deny-CognitiveServices-RestrictOutboundNetworkAccess
- Deny-Databricks-NoPublicIp
- Deny-Databricks-Sku
- Deny-Databricks-VirtualNetwork
- Deny-EH-Premium-CMK
- Deny-EH-minTLS
- Deny-FileServices-InsecureAuth
- Deny-FileServices-InsecureKerberos
- Deny-FileServices-InsecureSmbChannel
- Deny-FileServices-InsecureSmbVersions
- Deny-LogicApp-Public-Network
- Deny-LogicApps-Without-Https
- Deny-MachineLearning-Aks
- Deny-MachineLearning-Compute-SubnetId
- Deny-MachineLearning-Compute-VmSize
- Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess
- Deny-MachineLearning-ComputeCluster-Scale
- Deny-MachineLearning-HbiWorkspace
- Deny-MachineLearning-PublicAccessWhenBehindVnet
- Deny-MachineLearning-PublicNetworkAccess
- Deny-MgmtPorts-From-Internet
- Deny-MySql-http
- Deny-PostgreSql-http
- Deny-Private-DNS-Zones
- Deny-PublicEndpoint-MariaDB
- Deny-PublicIP
- Deny-RDP-From-Internet
- Deny-Redis-http
- Deny-Service-Endpoints
- Deny-Sql-minTLS
- Deny-SqlMi-minTLS
- Deny-Storage-ContainerDeleteRetentionPolicy
- Deny-Storage-CopyScope
- Deny-Storage-CorsRules
- Deny-Storage-LocalUser
- Deny-Storage-NetworkAclsBypass
- Deny-Storage-NetworkAclsVirtualNetworkRules
- Deny-Storage-ResourceAccessRulesResourceId
- Deny-Storage-ResourceAccessRulesTenantId
- Deny-Storage-SFTP
- Deny-Storage-ServicesEncryption
- Deny-Storage-minTLS
- Deny-StorageAccount-CustomDomain
- Deny-Subnet-Without-Nsg
- Deny-Subnet-Without-Penp
- Deny-Subnet-Without-Udr
- Deny-UDR-With-Specific-NextHop
- Deny-VNET-Peer-Cross-Sub
- Deny-VNET-Peering-To-Non-Approved-VNETs
- Deny-VNet-Peering
- DenyAction-ActivityLogs
- DenyAction-DeleteResources
- DenyAction-DiagnosticLogs
- Deploy-ASC-SecurityContacts
- Deploy-Budget
- Deploy-Custom-Route-Table
- Deploy-DDoSProtection
- Deploy-Diagnostics-AA
- Deploy-Diagnostics-ACI
- Deploy-Diagnostics-ACR
- Deploy-Diagnostics-APIMgmt
- Deploy-Diagnostics-AVDScalingPlans
- Deploy-Diagnostics-AnalysisService
- Deploy-Diagnostics-ApiForFHIR
- Deploy-Diagnostics-ApplicationGateway
- Deploy-Diagnostics-Bastion
- Deploy-Diagnostics-CDNEndpoints
- Deploy-Diagnostics-CognitiveServices
- Deploy-Diagnostics-CosmosDB
- Deploy-Diagnostics-DLAnalytics
- Deploy-Diagnostics-DataExplorerCluster
- Deploy-Diagnostics-DataFactory
- Deploy-Diagnostics-Databricks
- Deploy-Diagnostics-EventGridSub
- Deploy-Diagnostics-EventGridSystemTopic
- Deploy-Diagnostics-EventGridTopic
- Deploy-Diagnostics-ExpressRoute
- Deploy-Diagnostics-Firewall
- Deploy-Diagnostics-FrontDoor
- Deploy-Diagnostics-Function
- Deploy-Diagnostics-HDInsight
- Deploy-Diagnostics-LoadBalancer
- Deploy-Diagnostics-LogAnalytics
- Deploy-Diagnostics-LogicAppsISE
- Deploy-Diagnostics-MariaDB
- Deploy-Diagnostics-MediaService
- Deploy-Diagnostics-MlWorkspace
- Deploy-Diagnostics-MySQL
- Deploy-Diagnostics-NIC
- Deploy-Diagnostics-NetworkSecurityGroups
- Deploy-Diagnostics-PostgreSQL
- Deploy-Diagnostics-PowerBIEmbedded
- Deploy-Diagnostics-RedisCache
- Deploy-Diagnostics-Relay
- Deploy-Diagnostics-SQLElasticPools
- Deploy-Diagnostics-SQLMI
- Deploy-Diagnostics-SignalR
- Deploy-Diagnostics-TimeSeriesInsights
- Deploy-Diagnostics-TrafficManager
- Deploy-Diagnostics-VM
- Deploy-Diagnostics-VMSS
- Deploy-Diagnostics-VNetGW
- Deploy-Diagnostics-VWanS2SVPNGW
- Deploy-Diagnostics-VirtualNetwork
- Deploy-Diagnostics-WVDAppGroup
- Deploy-Diagnostics-WVDHostPools
- Deploy-Diagnostics-WVDWorkspace
- Deploy-Diagnostics-WebServerFarm
- Deploy-Diagnostics-Website
- Deploy-Diagnostics-iotHub
- Deploy-FirewallPolicy
- Deploy-LogicApp-TLS
- Deploy-MDFC-Arc-SQL-DCR-Association
- Deploy-MDFC-Arc-Sql-DefenderSQL-DCR
- Deploy-MDFC-SQL-AMA
- Deploy-MDFC-SQL-DefenderSQL
- Deploy-MDFC-SQL-DefenderSQL-DCR
- Deploy-MySQL-sslEnforcement
- Deploy-Nsg-FlowLogs
- Deploy-Nsg-FlowLogs-to-LA
- Deploy-PostgreSQL-sslEnforcement
- Deploy-Private-DNS-Generic
- Deploy-SQL-minTLS
- Deploy-Sql-AuditingSettings
- Deploy-Sql-SecurityAlertPolicies
- Deploy-Sql-Tde
- Deploy-Sql-vulnerabilityAssessments
- Deploy-Sql-vulnerabilityAssessments_20230706
- Deploy-SqlMi-minTLS
- Deploy-Storage-sslEnforcement
- Deploy-UserAssignedManagedIdentity-VMInsights
- Deploy-VNET-HubSpoke
- Deploy-Vm-autoShutdown
- Deploy-Windows-DomainJoin
- Modify-NSG
- Modify-UDR
</details>
  
### all policy set definitions
  
<details><summary>46 policy set definitions</summary>

- Audit-TrustedLaunch
- Audit-UnusedResourcesCostOptimization
- Deny-PublicPaaSEndpoints
- DenyAction-DeleteProtection
- Deploy-AUM-CheckUpdates
- Deploy-Diagnostics-LogAnalytics
- Deploy-MDFC-Config
- Deploy-MDFC-Config_20240319
- Deploy-MDFC-DefenderSQL-AMA
- Deploy-Private-DNS-Zones
- Deploy-Sql-Security
- Deploy-Sql-Security_20240529
- Enforce-ACSB
- Enforce-ALZ-Decomm
- Enforce-ALZ-Sandbox
- Enforce-Backup
- Enforce-EncryptTransit
- Enforce-EncryptTransit_20240509
- Enforce-Encryption-CMK
- Enforce-Guardrails-APIM
- Enforce-Guardrails-AppServices
- Enforce-Guardrails-Automation
- Enforce-Guardrails-BotService
- Enforce-Guardrails-CognitiveServices
- Enforce-Guardrails-Compute
- Enforce-Guardrails-ContainerApps
- Enforce-Guardrails-ContainerInstance
- Enforce-Guardrails-ContainerRegistry
- Enforce-Guardrails-CosmosDb
- Enforce-Guardrails-DataExplorer
- Enforce-Guardrails-DataFactory
- Enforce-Guardrails-EventGrid
- Enforce-Guardrails-EventHub
- Enforce-Guardrails-KeyVault
- Enforce-Guardrails-KeyVault-Sup
- Enforce-Guardrails-Kubernetes
- Enforce-Guardrails-MachineLearning
- Enforce-Guardrails-MySQL
- Enforce-Guardrails-Network
- Enforce-Guardrails-OpenAI
- Enforce-Guardrails-PostgreSQL
- Enforce-Guardrails-SQL
- Enforce-Guardrails-ServiceBus
- Enforce-Guardrails-Storage
- Enforce-Guardrails-Synapse
- Enforce-Guardrails-VirtualDesktop
</details>
  
### all policy assignments
  
<details><summary>49 policy assignments</summary>

- Audit-AppGW-WAF
- Audit-PeDnsZones
- Audit-ResourceRGLocation
- Audit-TrustedLaunch
- Audit-UnusedResources
- Audit-ZoneResiliency
- Deny-Classic-Resources
- Deny-HybridNetworking
- Deny-IP-forwarding
- Deny-MgmtPorts-Internet
- Deny-Priv-Esc-AKS
- Deny-Privileged-AKS
- Deny-Public-Endpoints
- Deny-Public-IP
- Deny-Public-IP-On-NIC
- Deny-Storage-http
- Deny-Subnet-Without-Nsg
- Deny-UnmanagedDisk
- DenyAction-DeleteUAMIAMA
- Deploy-ASC-Monitoring
- Deploy-AzActivity-Log
- Deploy-AzSqlDb-Auditing
- Deploy-Diag-LogsCat
- Deploy-MDEndpoints
- Deploy-MDEndpointsAMA
- Deploy-MDFC-Config-H224
- Deploy-MDFC-DefSQL-AMA
- Deploy-MDFC-OssDb
- Deploy-MDFC-SqlAtp
- Deploy-Private-DNS-Zones
- Deploy-SQL-TDE
- Deploy-SQL-Threat
- Deploy-VM-Backup
- Deploy-VM-ChangeTrack
- Deploy-VM-Monitoring
- Deploy-VMSS-ChangeTrack
- Deploy-VMSS-Monitoring
- Deploy-vmArc-ChangeTrack
- Deploy-vmHybr-Monitoring
- Enable-AUM-CheckUpdates
- Enable-DDoS-VNET
- Enforce-ACSB
- Enforce-AKS-HTTPS
- Enforce-ALZ-Decomm
- Enforce-ALZ-Sandbox
- Enforce-ASR
- Enforce-GR-KeyVault
- Enforce-Subnet-Private
- Enforce-TLS-SSL-H224
</details>
  
### all role definitions
  
<details><summary>5 role definitions</summary>

- Application-Owners
- Network-Management
- Network-Subnet-Contributor
- Security-Operations
- Subscription-Owner
</details>
  