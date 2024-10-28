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
  
#### assignment `Deploy-VM-ChangeTrack`
  
<details><summary>1 parameter names</summary>

- dcrResourceId
</details>
  
#### assignment `Deploy-VMSS-ChangeTrack`
  
<details><summary>1 parameter names</summary>

- dcrResourceId
</details>
  
#### assignment `Deploy-vmArc-ChangeTrack`
  
<details><summary>1 parameter names</summary>

- dcrResourceId
</details>
  
### default name `ama_mdfc_sql_data_collection_rule_id`
  
#### assignment `Deploy-MDFC-DefSQL-AMA`
  
<details><summary>1 parameter names</summary>

- dcrResourceId
</details>
  
### default name `ama_user_assigned_managed_identity_id`
  
#### assignment `Deploy-MDFC-DefSQL-AMA`
  
<details><summary>1 parameter names</summary>

- userAssignedIdentityResourceId
</details>
  
#### assignment `Deploy-VM-ChangeTrack`
  
<details><summary>1 parameter names</summary>

- userAssignedIdentityResourceId
</details>
  
#### assignment `Deploy-VM-Monitoring`
  
<details><summary>1 parameter names</summary>

- userAssignedIdentityResourceId
</details>
  
#### assignment `Deploy-VMSS-ChangeTrack`
  
<details><summary>1 parameter names</summary>

- userAssignedIdentityResourceId
</details>
  
#### assignment `Deploy-VMSS-Monitoring`
  
<details><summary>1 parameter names</summary>

- userAssignedIdentityResourceId
</details>
  
### default name `ama_user_assigned_managed_identity_name`
  
#### assignment `DenyAction-DeleteUAMIAMA`
  
<details><summary>1 parameter names</summary>

- resourceName
</details>
  
### default name `ama_vm_insights_data_collection_rule_id`
  
#### assignment `Deploy-VM-Monitoring`
  
<details><summary>1 parameter names</summary>

- dcrResourceId
</details>
  
#### assignment `Deploy-VMSS-Monitoring`
  
<details><summary>1 parameter names</summary>

- dcrResourceId
</details>
  
#### assignment `Deploy-vmHybr-Monitoring`
  
<details><summary>1 parameter names</summary>

- dcrResourceId
</details>
  
### default name `ddos_protection_plan_id`
  
#### assignment `Enable-DDoS-VNET`
  
<details><summary>1 parameter names</summary>

- ddosPlan
</details>
  
### default name `log_analytics_workspace_id`
  
#### assignment `Deploy-AzActivity-Log`
  
<details><summary>1 parameter names</summary>

- logAnalytics
</details>
  
#### assignment `Deploy-AzSqlDb-Auditing`
  
<details><summary>1 parameter names</summary>

- logAnalyticsWorkspaceId
</details>
  
#### assignment `Deploy-Diag-LogsCat`
  
<details><summary>1 parameter names</summary>

- logAnalytics
</details>
  
#### assignment `Deploy-MDFC-Config-H224`
  
<details><summary>1 parameter names</summary>

- logAnalytics
</details>
  
#### assignment `Deploy-MDFC-DefSQL-AMA`
  
<details><summary>1 parameter names</summary>

- userWorkspaceResourceId
</details>
  
### default name `private_dns_bot_service`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureBotServicePrivateDnsZoneId
</details>
  
### default name `private_dns_databricks`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureDatabricksPrivateDnsZoneId
</details>
  
### default name `private_dns_iot_central`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureIotCentralPrivateDnsZoneId
</details>
  
### default name `private_dns_iot_device_update`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureIotDeviceupdatePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_acr`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureAcrPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_app`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureAppPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_app_services`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureAppServicesPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_arc_guestconfiguration`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureArcGuestconfigurationPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_arc_hybrid_resource_provider`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureArcHybridResourceProviderPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_arc_kubernetes_configuration`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureArcKubernetesConfigurationPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_asr`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureAsrPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_automation_dsc_hybrid`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureAutomationDSCHybridPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_automation_webhook`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureAutomationWebhookPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_batch`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureBatchPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_cognitive_search`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureCognitiveSearchPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_cognitive_services`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureCognitiveServicesPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_cosmos_cassandra`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureCosmosCassandraPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_cosmos_gremlin`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureCosmosGremlinPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_cosmos_mongo`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureCosmosMongoPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_cosmos_sql`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureCosmosSQLPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_cosmos_table`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureCosmosTablePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_data_factory`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureDataFactoryPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_data_factory_portal`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureDataFactoryPortalPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_disk_access`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureDiskAccessPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_event_grid_domains`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureEventGridDomainsPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_event_grid_topics`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureEventGridTopicsPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_event_hub_namespace`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureEventHubNamespacePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_file`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureFilePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_hdinsight`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureHDInsightPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_iot`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureIotPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_iot_hubs`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureIotHubsPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_key_vault`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureKeyVaultPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_machine_learning_workspace`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMachineLearningWorkspacePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_machine_learning_workspace_second`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMachineLearningWorkspaceSecondPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_managed_grafana_workspace`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureManagedGrafanaWorkspacePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_media_services_key`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMediaServicesKeyPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_media_services_live`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMediaServicesLivePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_media_services_stream`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMediaServicesStreamPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_migrate`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMigratePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_monitor_1`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMonitorPrivateDnsZoneId1
</details>
  
### default name `private_dns_zone_monitor_2`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMonitorPrivateDnsZoneId2
</details>
  
### default name `private_dns_zone_monitor_3`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMonitorPrivateDnsZoneId3
</details>
  
### default name `private_dns_zone_monitor_4`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMonitorPrivateDnsZoneId4
</details>
  
### default name `private_dns_zone_monitor_5`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureMonitorPrivateDnsZoneId5
</details>
  
### default name `private_dns_zone_redis_cache`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureRedisCachePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_service_bus_namespace`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureServiceBusNamespacePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_signal_r`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureSignalRPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_site_recovery_backup`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureSiteRecoveryBackupPrivateDnsZoneID
</details>
  
### default name `private_dns_zone_site_recovery_blob`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureSiteRecoveryBlobPrivateDnsZoneID
</details>
  
### default name `private_dns_zone_site_recovery_queue`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureSiteRecoveryQueuePrivateDnsZoneID
</details>
  
### default name `private_dns_zone_storage_blob`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageBlobPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_blob_sec`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageBlobSecPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_dfs`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageDFSPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_dfs_sec`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageDFSSecPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_file`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageFilePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_queue`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageQueuePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_queue_sec`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageQueueSecPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_static_web`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageStaticWebPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_static_web_sec`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageStaticWebSecPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_table`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageTablePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_storage_table_secondary`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureStorageTableSecondaryPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_synapse_dev`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureSynapseDevPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_synapse_sql`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureSynapseSQLPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_synapse_sql_od`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureSynapseSQLODPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_virtual_desktop_hostpool`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureVirtualDesktopHostpoolPrivateDnsZoneId
</details>
  
### default name `private_dns_zone_virtual_desktop_workspace`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureVirtualDesktopWorkspacePrivateDnsZoneId
</details>
  
### default name `private_dns_zone_web`
  
#### assignment `Deploy-Private-DNS-Zones`
  
<details><summary>1 parameter names</summary>

- azureWebPrivateDnsZoneId
</details>
  
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
  