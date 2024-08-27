$privateDnsZoneIds = @(
  "azureManagedGrafanaWorkspacePrivateDnsZoneId",
  "azureArcKubernetesConfigurationPrivateDnsZoneId",
  "azureArcHybridResourceProviderPrivateDnsZoneId",
  "azureArcGuestconfigurationPrivateDnsZoneId",
  "azureAppPrivateDnsZoneId",
  "azureAppServicesPrivateDnsZoneId",
  "azureAsrPrivateDnsZoneId",
  "azureAutomationDSCHybridPrivateDnsZoneId",
  "azureAutomationWebhookPrivateDnsZoneId",
  "azureBatchPrivateDnsZoneId",
  "azureCognitiveSearchPrivateDnsZoneId",
  "azureCognitiveServicesPrivateDnsZoneId",
  "azureCosmosCassandraPrivateDnsZoneId",
  "azureCosmosGremlinPrivateDnsZoneId",
  "azureCosmosMongoPrivateDnsZoneId",
  "azureCosmosSQLPrivateDnsZoneId",
  "azureCosmosTablePrivateDnsZoneId",
  "azureDataFactoryPortalPrivateDnsZoneId",
  "azureDataFactoryPrivateDnsZoneId",
  "azureDiskAccessPrivateDnsZoneId",
  "azureEventGridDomainsPrivateDnsZoneId",
  "azureEventGridTopicsPrivateDnsZoneId",
  "azureEventHubNamespacePrivateDnsZoneId",
  "azureFilePrivateDnsZoneId",
  "azureHDInsightPrivateDnsZoneId",
  "azureIotHubsPrivateDnsZoneId",
  "azureIotPrivateDnsZoneId",
  "azureKeyVaultPrivateDnsZoneId",
  "azureMachineLearningWorkspacePrivateDnsZoneId",
  "azureMediaServicesKeyPrivateDnsZoneId",
  "azureMediaServicesLivePrivateDnsZoneId",
  "azureMediaServicesStreamPrivateDnsZoneId",
  "azureMigratePrivateDnsZoneId",
  "azureMonitorPrivateDnsZoneId1",
  "azureMonitorPrivateDnsZoneId2",
  "azureMonitorPrivateDnsZoneId3",
  "azureMonitorPrivateDnsZoneId4",
  "azureMonitorPrivateDnsZoneId5",
  "azureRedisCachePrivateDnsZoneId",
  "azureServiceBusNamespacePrivateDnsZoneId",
  "azureSignalRPrivateDnsZoneId",
  "azureStorageBlobPrivateDnsZoneId",
  "azureStorageBlobSecPrivateDnsZoneId",
  "azureStorageDFSPrivateDnsZoneId",
  "azureStorageDFSSecPrivateDnsZoneId",
  "azureStorageFilePrivateDnsZoneId",
  "azureStorageQueuePrivateDnsZoneId",
  "azureStorageQueueSecPrivateDnsZoneId",
  "azureStorageStaticWebPrivateDnsZoneId",
  "azureStorageStaticWebSecPrivateDnsZoneId",
  "azureSynapseDevPrivateDnsZoneId",
  "azureSynapseSQLODPrivateDnsZoneId",
  "azureSynapseSQLPrivateDnsZoneId",
  "azureWebPrivateDnsZoneId",
  "azureVirtualDesktopHostpoolPrivateDnsZoneId",
  "azureVirtualDesktopWorkspacePrivateDnsZoneId",
  "azureSiteRecoveryBlobPrivateDnsZoneID",
  "azureSiteRecoveryQueuePrivateDnsZoneID"
)

$results = @()

foreach ($privateDnsZoneId in $privateDnsZoneIds) {
  $camelCase = ""
  $wasPreviousUpperI = $false

  foreach ($character in $privateDnsZoneId.ToCharArray()) {
    if ([System.Char]::IsUpper($character)) {
      if (!$wasPreviousUpper) {
        $camelCase += "_"
      }

      $wasPreviousUpper = $true
    }
    else {
      $wasPreviousUpper = $false
    }
    $camelCase += $character.ToString().ToLower()
  }

  $camelCase = $camelCase.Replace("sql", "_sql_").Replace("dfs", "_dfs_").Replace("dsc", "_dsc_").Replace("signal_r", "_signal_r_").Replace("private_dns_zone_id", "_private_dns_zone_id_").Replace("___", "_").Replace("__", "_").Trim("_")
  $finalName = $camelCase.Replace("_private_dns_zone_id", "").Replace("azure_", "").Trim("_")
  $finalName = "private_dns_zone_$finalName"

  $jsonObject = @{
    "default_name"       = $finalName
    "policy_assignments" = @(
      @{
        "policy_assignment_name" = "Deploy-Private-DNS-Zones"
        "parameter_names"        = @(
          $privateDnsZoneId
        )
      }
    )
  }
  $results += $jsonObject
}

Write-Output $results | ConvertTo-Json -Depth 10
