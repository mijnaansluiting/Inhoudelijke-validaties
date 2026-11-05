<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:ma="http://example.com/mijnaansluiting"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            version="3.0">

  <!-- A version is an NLCS++ version; its id is the NLCS++ version prefixed with v (v12, v12.1) -->
  <variable name="versions_file" select="document('../../configuration/versions.xml')"/>

  <!-- The requested version id (e.g. v12.1) if it is registered, else empty -->
  <function name="ma:resolve-version" as="xs:string?">
    <param name="requested" as="xs:string"/>
    <sequence select="$versions_file/versions/version[@id = $requested]/@id/string()"/>
  </function>

  <!-- NLCS++ (NLCS_Netbeheer XSD) version declared by the VersieNummer attribute of the file's root element, or empty -->
  <function name="ma:file-xsd-version" as="xs:string?">
    <param name="document" as="node()"/>
    <sequence select="root($document)/*/@VersieNummer"/>
  </function>

  <!-- Version for an NLCS++ version (12.1 -> v12.1) if it is registered, else empty -->
  <function name="ma:version-for-xsd" as="xs:string?">
    <param name="xsd_version" as="xs:string"/>
    <sequence select="ma:resolve-version('v' || $xsd_version)"/>
  </function>

  <!-- Version to validate a file with: the requested one if given, else detected from the file's XSD; empty if unsupported -->
  <function name="ma:select-version" as="xs:string?">
    <param name="document" as="node()"/>
    <param name="requested" as="xs:string?"/>
    <choose>
      <when test="$requested">
        <sequence select="ma:resolve-version($requested)"/>
      </when>
      <otherwise>
        <sequence select="ma:file-xsd-version($document) ! ma:version-for-xsd(.)"/>
      </otherwise>
    </choose>
  </function>
</stylesheet>
