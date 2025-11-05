<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                exclude-result-prefixes="svrl">

  <xsl:template match="/">
    <xsl:variable name="filename"
                  select="replace(tokenize(base-uri(), '/')[last()], '\.xml$', '.txt')"/>

    <xsl:variable name="has_failed_asserts"
                  select="count(//svrl:failed-assert) &gt; 0"/>

    <xsl:variable name="test"
                  select="tokenize(base-uri(), '/')[last() - 1]"/>

    <xsl:result-document href="{$filename}" method="text">
      <xsl:choose>
        <xsl:when test="$test = 'failing' and $has_failed_asserts">
          <xsl:text>PASS</xsl:text>
        </xsl:when>
        <xsl:when test="$test = 'passing' and not($has_failed_asserts)">
          <xsl:text>PASS</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>FAIL</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:result-document>
  </xsl:template>
</xsl:stylesheet>
