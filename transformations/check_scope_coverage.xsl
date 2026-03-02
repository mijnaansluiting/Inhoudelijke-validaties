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
  <xsl:variable name="scope_rule_numbers" select="$scope/nvr:scopeValidatieRegels/nvr:scopeValidatieRegel/nvr:nummer ! substring-after(., 'R.') ! xs:integer(.)"/>
  <xsl:variable name="scopeless_rule_numbers" select="$config_doc/nvr:NLCSValidatieregels/nvr:validatieRegels/nvr:validatieRegel[nvr:soort = 'Bestand']/@nummer ! substring-after(., 'R.') ! xs:integer(.)"/>

  <!-- Extract numbers from contexts -->
  <xsl:variable name="all_found">
    <xsl:for-each select="//svrl:fired-rule/@context">
      <xsl:analyze-string select="." regex="rule-within-scope-for-object\((\d+),">
        <xsl:matching-substring>
          <xsl:sequence select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="expected" select="sort(distinct-values(($scope_rule_numbers, $scopeless_rule_numbers)))"/>
  <xsl:variable name="found" select="sort(distinct-values(tokenize($all_found)) ! xs:integer(.))"/>
  <xsl:variable name="missing" select="$expected[not(. = $found)]"/>
  <xsl:variable name="unexpected" select="$found[not(. = $expected)]"/>

  <xsl:template match="/">expected=<xsl:value-of select="$expected"/>
found=<xsl:value-of select="$found"/>
missing=<xsl:value-of select="$missing"/>
unexpected=<xsl:value-of select="$unexpected"/>
  </xsl:template>

</xsl:stylesheet>
