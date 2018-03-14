#define parameters
$prefix = "hexa9site"
$PSScriptRoot = "C:\ResourceFiles"
$XConnectCollectionService = "$prefix.xconnect"
$sitecoreSiteName = "$prefix.local"
$SolrUrl = "https://localhost:8983/solr"
$SolrRoot = "C:\solr-6.6.2"
$SolrService = "solr6.6.2"
$SqlServer = "DT-WIN10-01\SQLEXPRESS2016"
$SqlAdminUser = "sa"
$SqlAdminPassword = "Edy@2017" 
 
#install client certificate for xconnect 
$certParams = 
@{     
    Path = "$PSScriptRoot\xconnect-createcert.json"     
    CertificateName = "$prefix.xconnect_client" 
} 
Install-SitecoreConfiguration @certParams -Verbose

#install solr cores for xdb 
$solrParams = 
@{
    Path = "$PSScriptRoot\xconnect-solr.json"     
    SolrUrl = $SolrUrl    
    SolrRoot = $SolrRoot  
    SolrService = $SolrService  
    CorePrefix = $prefix 
} 
Install-SitecoreConfiguration @solrParams -Verbose
 
#deploy xconnect instance 
$xconnectParams = 
@{
    Path = "$PSScriptRoot\xconnect-xp0.json"     
    Package = "$PSScriptRoot\Sitecore 9.0.0 rev. 171002 (OnPrem)_xp0xconnect.scwdp.zip"
    LicenseFile = "$PSScriptRoot\license.xml"
    Sitename = $XConnectCollectionService   
    XConnectCert = $certParams.CertificateName    
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser
    SqlAdminPassword = $SqlAdminPassword
    SolrCorePrefix = $prefix
    SolrURL = $SolrUrl      
} 
Install-SitecoreConfiguration @xconnectParams -Verbose
 
#install solr cores for sitecore 
$solrParams = 
@{
    Path = "$PSScriptRoot\sitecore-solr.json"
    SolrUrl = $SolrUrl
    SolrRoot = $SolrRoot
    SolrService = $SolrService     
    CorePrefix = $prefix 
} 
Install-SitecoreConfiguration @solrParams -Verbose
 
#install sitecore instance 
$sitecoreParams = 
@{     
    Path = "$PSScriptRoot\sitecore-XP0.json"
    Package = "$PSScriptRoot\Sitecore 9.0.0 rev. 171002 (OnPrem)_single.scwdp.zip" 
    LicenseFile = "$PSScriptRoot\license.xml"
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser     
    SqlAdminPassword = $SqlAdminPassword     
    SolrCorePrefix = $prefix  
    SolrUrl = $SolrUrl     
    XConnectCert = $certParams.CertificateName     
    Sitename = $sitecoreSiteName         
    XConnectCollectionService = "https://$XConnectCollectionService"    
} 
Install-SitecoreConfiguration @sitecoreParams -Verbose