<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                exclude-result-prefixes="sch">

  <!-- Identity: copy everything as-is -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sch:include/@href">
    <xsl:attribute name="href">
      <xsl:value-of select="replace(., 'abstract_patterns', 'abstract_patterns_scope_checks')"/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
