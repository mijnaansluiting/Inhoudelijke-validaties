<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="subnettype-ingevuld-voor-ls-en-ms-kabel" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:LSkabel | nlcs:LSmof">
        <let name="missing_attributes"
            value="ma:missing-attributes(., 'Subnettype')"/>

        <assert id="subnettype-present"
            test="empty($missing_attributes)"
            properties="scope rule-number severity object-type object-id missing-attributes">
            <value-of select="ma:missing-attributes-message($missing_attributes)"/>
        </assert>
    </rule>
</pattern>
