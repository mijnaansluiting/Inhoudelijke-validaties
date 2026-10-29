<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:ma="http://example.com/mijnaansluiting"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            version="3.0">

  <variable name="versions_file" select="document('../../configuration/versions.xml')"/>

  <!-- Sort key for a version id: v2026.10.0 -> (2026, 10, 0) -->
  <function name="ma:version-key" as="xs:integer*">
    <param name="version_id" as="xs:string"/>
    <sequence select="for $part in tokenize(substring($version_id, 2), '\.') return xs:integer($part)"/>
  </function>

  <!-- Newest of the given <version/> entries, or empty -->
  <function name="ma:newest-version" as="xs:string?">
    <param name="versions" as="element(version)*"/>
    <variable name="sorted" as="element(version)*">
      <perform-sort select="$versions">
        <sort select="ma:version-key(@id)[1]" data-type="number"/>
        <sort select="ma:version-key(@id)[2]" data-type="number"/>
        <sort select="ma:version-key(@id)[3]" data-type="number"/>
      </perform-sort>
    </variable>
    <sequence select="$sorted[last()]/@id/string()"/>
  </function>

  <!-- Full version id for an explicit vYEAR.RELEASE.FIX, or the newest fix for a vYEAR.RELEASE alias; empty if unknown -->
  <function name="ma:resolve-version" as="xs:string?">
    <param name="requested" as="xs:string"/>
    <choose>
      <when test="matches($requested, '^v\d{4}\.\d+\.\d+$')">
        <sequence select="$versions_file/versions/version[@id = $requested]/@id/string()"/>
      </when>
      <when test="matches($requested, '^v\d{4}\.\d+$')">
        <sequence select="ma:newest-version($versions_file/versions/version[starts-with(@id, concat($requested, '.'))])"/>
      </when>
    </choose>
  </function>

  <!-- NLCS_Netbeheer XSD version referenced by the file's xsi:schemaLocation (".../V12.1/..."), or empty -->
  <function name="ma:file-xsd-version" as="xs:string?">
    <param name="document" as="node()"/>
    <variable name="schema_location" select="string(root($document)/*/@xsi:schemaLocation)"/>
    <sequence select="replace($schema_location, '^.*/V(\d+\.\d+)/.*$', '$1', 's')[matches($schema_location, '/V\d+\.\d+/')]"/>
  </function>

  <!-- Newest released version targeting an XSD version, or empty -->
  <function name="ma:version-for-xsd" as="xs:string?">
    <param name="xsd_version" as="xs:string"/>
    <sequence select="ma:newest-version($versions_file/versions/version[@nlcspp = $xsd_version and xs:boolean(@released)])"/>
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
