<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:nlcs="NS_NLCSnetbeheer"
                xmlns:nvr="NLCSValidatieRegelsNameSpace"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">

  <xsl:output method="text" />

  <xsl:param name="scope_name" as="xs:string"/>

  <xsl:variable name="config_doc" select="document('../doc/NLCSValidatieRegels.xml')"/>
  <xsl:variable name="scope" select="$config_doc/nvr:NLCSValidatieregels/nvr:scopes/nvr:scope[@naam=$scope_name]"/>
  <xsl:variable name="rule_numbers" select="$scope/nvr:scopeValidatieRegels/nvr:scopeValidatieRegel/nvr:nummer"/>

  <!-- Extract numbers from contexts -->
  <xsl:variable name="found">
    <xsl:for-each select="//svrl:fired-rule/@context">
      <xsl:analyze-string select="." regex="rule-within-scope-for-object\((\d+),">
        <xsl:matching-substring>
          <number><xsl:value-of select="regex-group(1)"/></number>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="/">expected=<xsl:for-each select="$rule_numbers">
      <xsl:sequence select="substring-after(., 'R.')"/>
    </xsl:for-each>
found=<xsl:value-of select="distinct-values($found/number)"/>
missing=<xsl:value-of select="
      for $n in distinct-values($rule_numbers ! substring-after(., 'R.'))
        return
          if (not($found/number = $n)) then $n else ()"/>
unexpected=<xsl:value-of select="string-join(
        for $n in distinct-values($found/number)
        return
          if (not($rule_numbers ! substring-after(., 'R.') = $n)) then $n else (),
          ', ')"/>
  </xsl:template>

</xsl:stylesheet>
