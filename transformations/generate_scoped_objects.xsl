<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:nvr="NLCSValidatieRegelsNameSpace"
                xmlns:nlcs="NS_NLCSnetbeheer"
                exclude-result-prefixes="nvr">

  <xsl:output method="xml" indent="true"/>

  <!-- Load config XML -->
  <xsl:variable name="config_doc" select="document('../doc/NLCSValidatieRegels.xml')"/>
  <xsl:variable name="scopes" select="$config_doc/nvr:NLCSValidatieregels/nvr:scopes/nvr:scope"/>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:variable name="template" select="."/>
    <xsl:for-each select="$scopes">
      <xsl:variable name="naam" select="@naam"/>
      <xsl:variable name="tekening_type" select="upper-case(nvr:tekeningSoort)"/>
      <xsl:variable name="statussen" select="nvr:statussen/nvr:status"/>
      <xsl:variable name="bedrijfstoestanden" select="nvr:bedrijfsToestanden/nvr:bedrijfstoestand"/>

      <xsl:for-each select="$statussen">
        <xsl:variable name="status" select="."/>
        <xsl:for-each select="$bedrijfstoestanden">
          <xsl:variable name="bedrijfstoestand" select="."/>
          <xsl:variable name="scoped_template">
            <xsl:apply-templates select="$template/*">
              <xsl:with-param name="tekening_type" select="$tekening_type"/>
              <xsl:with-param name="status" select="$status"/>
              <xsl:with-param name="bedrijfstoestand" select="$bedrijfstoestand"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:result-document href="scoped_objects/{$naam}/{$tekening_type}/{$status}/{$bedrijfstoestand}.xml">
            <xsl:copy-of select="$scoped_template/node()"/>
          </xsl:result-document>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="node()|@*">
    <xsl:param name="tekening_type"/>
    <xsl:param name="status"/>
    <xsl:param name="bedrijfstoestand"/>
    <xsl:copy>
      <xsl:apply-templates select="node()|@*">
        <xsl:with-param name="tekening_type" select="$tekening_type"/>
        <xsl:with-param name="status" select="$status"/>
        <xsl:with-param name="bedrijfstoestand" select="$bedrijfstoestand"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <!-- Matches any instance of "{{SOME PLACEHOLDER}}" -->
  <xsl:template match="text()[matches(., '\{\{[^}]+\}\}')]">
    <xsl:param name="tekening_type"/>
    <xsl:param name="status"/>
    <xsl:param name="bedrijfstoestand"/>

    <xsl:variable name="text_placeholders_replaced" select="replace(., '\{\{TEKENING TYPE\}\}', $tekening_type)"/>
    <xsl:variable name="text_placeholders_replaced" select="replace($text_placeholders_replaced, '\{\{STATUS\}\}', $status)"/>
    <xsl:variable name="text_placeholders_replaced" select="replace($text_placeholders_replaced, '\{\{BEDRIJFSTOESTAND\}\}', $bedrijfstoestand)"/>
    <xsl:value-of select="$text_placeholders_replaced"/>
  </xsl:template>


</xsl:stylesheet>
