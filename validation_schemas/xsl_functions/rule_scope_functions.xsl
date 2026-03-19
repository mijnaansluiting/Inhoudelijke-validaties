<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:ma="http://example.com/mijnaansluiting"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:nlcs="NS_NLCSnetbeheer"
            xmlns:nvr="NLCSValidatieRegelsNameSpace"
            version="3.0">
  
  <variable name="validatieregels_file" select="document('../../doc/NLCSValidatieRegels.xml')"/>
  <variable name="scopes" select="$validatieregels_file/nvr:NLCSValidatieregels/nvr:scopes/nvr:scope"/>

  <function name="ma:rule-string" as="xs:string">
    <param name="rule_number" as="xs:integer"/>
    <value-of select="concat('R.', $rule_number)"/>
  </function>
  
  <function name="ma:rule-type" as="xs:string">
    <param name="rule_string" as="xs:string"/>
    <value-of select="$validatieregels_file/nvr:NLCSValidatieregels/nvr:validatieRegels/nvr:validatieRegel[@nummer = $rule_string]/nvr:soort"/>
  </function>

  <function name="ma:rule-within-scope-for-object" as="xs:boolean">
    <param name="rule_number" as="xs:integer"/>
    <param name="nlcs_object"/>
    <variable name="object_type" select="name($nlcs_object)"/>
    <variable name="rule_string" select="ma:rule-string($rule_number)"/>

    <choose>
      <!-- Rules of type Bestand are always within scope -->
      <when test="ma:rule-type($rule_string) = 'Bestand'">
        <value-of select="true()"/>
      </when>
      <otherwise>
        <variable name="matching_scope" select="ma:matching-scope($nlcs_object)"/>
        <variable name="scope_validation_rules" select="$matching_scope/nvr:scopeValidatieRegels/nvr:scopeValidatieRegel"/>

        <value-of select="some $rule in $scope_validation_rules satisfies $rule/nvr:nummer = $rule_string"/>
      </otherwise>
    </choose>
  </function>

  <function name="ma:rule-severity-within-scope" as="xs:string">
    <param name="rule_number" as="xs:integer"/>
    <param name="nlcs_object"/>
    <variable name="object_type" select="name($nlcs_object)"/>

    <choose>
      <when test="$object_type = 'NS_NLCSnetbeheer'">
        <value-of select="'Fout'"/>
      </when>
      <otherwise>
        <variable name="rule_string" select="ma:rule-string($rule_number)"/>
        <variable name="matching_scope" select="ma:matching-scope($nlcs_object)"/>
        <variable name="scope_validation_rules" select="$matching_scope/nvr:scopeValidatieRegels/nvr:scopeValidatieRegel"/>

        <value-of select="$scope_validation_rules[nvr:nummer = $rule_string]/nvr:niveau"/>
      </otherwise>
    </choose>
  </function>

  <function name="ma:scope-name" as="xs:string">
    <param name="nlcs_object"/>

    <variable name="matching_scope" select="ma:matching-scope($nlcs_object)"/>

    <value-of select="$matching_scope/@naam"/>
  </function>

  <function name="ma:matching-scope">
    <param name="nlcs_object"/>

    <variable name="tekening_type" select="$nlcs_object//preceding-sibling::nlcs:AprojectReferentie/nlcs:Tekeningtype"/>
    <variable name="status" select="$nlcs_object/nlcs:Status"/>
    <variable name="bedrijfstoestand" select="$nlcs_object/nlcs:Bedrijfstoestand"/>

    <sequence select="$scopes[
                      upper-case(nvr:tekeningSoort) = $tekening_type
                      and nvr:statussen/nvr:status = $status
                      and nvr:bedrijfsToestanden/nvr:bedrijfstoestand = $bedrijfstoestand]"/>
  </function>
</stylesheet>
