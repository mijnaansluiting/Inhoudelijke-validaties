<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="volgnummer-verplicht" abstract="true">
    <rule context="//nlcs:AprojectReferentie[nlcs:Tekeningtype = 'DEELREVISIE' or nlcs:Tekeningtype = 'EINDREVISIE']">
        <let name="missing_attributes"
            value="ma:missing-attributes(., 'Volgnummer')"/>

        <assert id="aprojectreferentie-has-volgnummer"
                test="empty($missing_attributes)"
                properties="rule-number severity object-type object-id missing-attributes">
            <value-of select="ma:missing-attributes-message($missing_attributes)"/>
        </assert>
    </rule>
</pattern>
