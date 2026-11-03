<!--
  Entry point for validating an NLCS++ file with the right rule-set version.

    java -jar saxon-he.jar -xsl:validate.xsl -s:file.xml [version=v2026.1.0 | version=v2026.1]

  Without the version parameter, the version is the newest released rule-set version whose
  nlcspp equals the VersieNummer attribute of the file's root element. The selected version's
  compiled schema (<version>/rules/transpiled_phases/main_scope_checks.xsl) is run on the file
  and its SVRL report is returned. Validation stops with an error when no version can be selected.
-->
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:ma="http://example.com/mijnaansluiting"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            exclude-result-prefixes="#all"
            version="3.0">

  <include href="version_functions.xsl"/>

  <!-- Optional rule-set version: a full id (v2026.1.0) or a vYEAR.RELEASE alias (v2026.1) for its newest fix -->
  <param name="version" as="xs:string?" select="()"/>

  <template match="/">
    <variable name="selected" as="xs:string?" select="ma:select-version(., $version)"/>

    <if test="empty($selected)">
      <variable name="xsd_version" as="xs:string?" select="ma:file-xsd-version(.)"/>
      <message terminate="yes" error-code="ma:unsupported-version">
        <choose>
          <when test="$version">Unknown rule-set version: <value-of select="$version"/></when>
          <when test="empty($xsd_version)">Unsupported NLCS version: the root element declares no VersieNummer</when>
          <otherwise>Unsupported NLCS version: no released rule-set version targets VersieNummer <value-of select="$xsd_version"/></otherwise>
        </choose>
      </message>
    </if>

    <sequence select="transform(map {
                        'stylesheet-location': $selected || '/rules/transpiled_phases/main_scope_checks.xsl',
                        'source-node': .
                      })?output"/>
  </template>
</stylesheet>
