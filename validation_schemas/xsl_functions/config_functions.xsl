<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:ma="http://example.com/mijnaansluiting"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            version="3.0">

  <variable name="sys_config_file" select= "document('../../configuration/sys_config.xml')"/>
  <variable name="user_config_file" select= "document('../../configuration/user_config.xml')"/>

  <function name="ma:map-mof-functie" as="xs:string">
    <param name="functie" as="xs:string"/>
    <sequence select="name(($sys_config_file/config/v12/MofFuncties/*[Functie = $functie]))"/>
  </function>
  
  <function name="ma:allowed-inmeetwijzen" as="xs:string*">
    <sequence select="$sys_config_file/config/v12/ToegestaandeInmeetwijzen/Inmeetwijze"/>  
  </function>

  <function name="ma:object-requires-gis-id" as="xs:boolean">
    <param name="nlcs_object"/>
    <variable name="objects_not_requiring_gis_id" select="$sys_config_file/config/v12/GisIdAssetsIdExceptions/NoGisIdRequired"/>
    <value-of select="not(some $object in $objects_not_requiring_gis_id satisfies $object = name($nlcs_object))"/>
  </function>
  
  <function name="ma:get-soortkunstwerken-with-required-abestandsbijlage">
    <sequence select="$sys_config_file/config/v12/SoortKunstwerkRequiredBestandsBijlage/*"/>
  </function>

  <function name="ma:object-requires-asset-id" as="xs:boolean">
    <param name="nlcs_object"/>
    <variable name="objects_not_requiring_asset_id" select="$sys_config_file/config/v12/GisIdAssetsIdExceptions/NoAssetIdRequired"/>
    <value-of select="not(some $object in $objects_not_requiring_asset_id satisfies $object = name($nlcs_object))"/>
  </function>
</stylesheet>
