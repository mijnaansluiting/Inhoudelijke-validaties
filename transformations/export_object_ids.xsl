<?xml version="1.0" encoding="UTF-8"?>
<!--
  Exports the ID of every object in an NLCS++ XML file to CSV.

  One row per object directly below <NLCSnetbeheer>, in file order, with the
  columns object_type and id. Elements are matched on local-name(), so
  <nlcs:LSkabel> and <LSkabel> both give object_type LSkabel. An object
  without an <ID> element gets an empty id.

  Usage: java -jar saxon-he.jar -xsl:transformations/export_object_ids.xsl -s:input.xml -o:output.csv
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ma="http://example.com/my-functions"
                exclude-result-prefixes="xs ma">

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- Quote a CSV field when it contains a comma, quote or line break -->
  <xsl:function name="ma:csv-field" as="xs:string">
    <xsl:param name="value" as="xs:string"/>
    <xsl:sequence select="if (matches($value, '[,&quot;&#13;&#10;]'))
                          then concat('&quot;', replace($value, '&quot;', '&quot;&quot;'), '&quot;')
                          else $value"/>
  </xsl:function>

  <xsl:template match="/">
    <xsl:text>object_type,id&#10;</xsl:text>
    <xsl:for-each select="*[local-name() = 'NLCSnetbeheer']/*">
      <xsl:value-of select="ma:csv-field(local-name()), ma:csv-field(normalize-space(*[local-name() = 'ID'][1]))"
                    separator=","/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
