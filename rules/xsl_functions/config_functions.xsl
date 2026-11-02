<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:ma="http://example.com/mijnaansluiting"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            version="3.0">

  <variable name="sys_config_file" select= "document('../../configuration/sys_config.xml')"/>
  <variable name="user_config_file" select= "document('../../configuration/user_config.xml')"/>

  <!-- sys_config block of the version being validated; $active_version is declared in each version's main.sch -->
  <variable name="active_config" as="element(version)">
    <sequence select="($sys_config_file/config/version[@id = $active_version],
                       error((), 'No sys_config block for version ' || $active_version))[1]"/>
  </variable>

  <function name="ma:map-mof-functie" as="xs:string">
    <param name="functie" as="xs:string"/>
    <sequence select="name(($active_config/MofFuncties/*[Functie = $functie]))"/>
  </function>

  <function name="ma:allowed-inmeetwijzen" as="xs:string*">
    <sequence select="$active_config/ToegestaandeInmeetwijzen/Inmeetwijze"/>
  </function>

  <function name="ma:object-requires-gis-id" as="xs:boolean">
    <param name="nlcs_object"/>
    <variable name="objects_not_requiring_gis_id" select="$active_config/GisIdAssetsIdExceptions/NoGisIdRequired"/>
    <value-of select="not(some $object in $objects_not_requiring_gis_id satisfies $object = name($nlcs_object))"/>
  </function>

  <function name="ma:object-requires-asset-id" as="xs:boolean">
    <param name="nlcs_object"/>
    <variable name="objects_not_requiring_asset_id" select="$active_config/GisIdAssetsIdExceptions/NoAssetIdRequired"/>
    <value-of select="not(some $object in $objects_not_requiring_asset_id satisfies $object = name($nlcs_object))"/>
  </function>

  <function name="ma:mantelbuis-inhoud-asset-max-distance" as="xs:double">
    <sequence select="$active_config/MantelbuisInhoudMaxAfstand"/>
  </function>

  <function name="ma:decimal-precision" as="xs:integer">
    <sequence select="$active_config/DecimalPrecision"/>
  </function>
</stylesheet>
