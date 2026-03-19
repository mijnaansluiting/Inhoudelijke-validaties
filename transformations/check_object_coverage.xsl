<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:nlcs="NS_NLCSnetbeheer"
                xmlns:nvr="NLCSValidatieRegelsNameSpace"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:keronic="http://example.com/my-functions"
                version="2.0">
  
      <xsl:output method="text"/>
      
      <xsl:param name="rule_number" as="xs:string"/>
      
      <xsl:variable name="config_doc" select="document('../doc/NLCSValidatieRegels.xml')"/>

      <xsl:variable name="failing_test_files" select="collection(concat('../rule_validation_reports/v12/', $rule_number, '/failing/?select=*.xml'))"/>
      <xsl:variable name="rule" select="$config_doc/nvr:NLCSValidatieregels/nvr:validatieRegels/nvr:validatieRegel[@nummer = $rule_number]"/>
      <xsl:variable name="expected_object_names" select="$rule/nvr:validatieObjecten/nvr:validatieObject/nvr:naam"/>
      <xsl:variable name="failed_asserts_matching_rule_number" select="$failing_test_files/svrl:schematron-output/svrl:failed-assert[svrl:property-reference[@property='rule-number']/svrl:text = substring-after($rule_number, 'R.')]"/>
      <xsl:variable name="found_object_names" select="distinct-values($failed_asserts_matching_rule_number/svrl:property-reference[@property='object-type']/svrl:text)"/>
      <xsl:variable name="missing_object_names" select="$expected_object_names[not(some $object_name in $found_object_names satisfies . = $object_name)]"/>
      <xsl:variable name="is_correctly_covered" select="(empty($missing_object_names)) or ($expected_object_names = ('AlleObjecten', 'Document'))"/>      
      
      <xsl:function name="keronic:as-markdown-row" as="xs:string">
            <xsl:param name="rule_number" as="xs:string"/>
            <xsl:param name="expected" as="xs:string*"/>
            <xsl:param name="found" as="xs:string*"/>
            <xsl:param name="missing" as="xs:string*"/>
            <xsl:value-of select="concat(
                        '| ', 
                        string-join((
                              $rule_number,
                              string-join($expected, ' '), 
                              string-join($found, ' '), 
                              string-join($missing, ' ') 
                        ), ' | '),
                        ' |'
                  )"/>
      </xsl:function>
      
      <xsl:template match="/">
            <xsl:value-of select="keronic:as-markdown-row($rule_number, $expected_object_names, $found_object_names, $missing_object_names)"/>
            <xsl:value-of select="','"/>
            <xsl:value-of select="$is_correctly_covered"/>
      </xsl:template> 
 </xsl:stylesheet>