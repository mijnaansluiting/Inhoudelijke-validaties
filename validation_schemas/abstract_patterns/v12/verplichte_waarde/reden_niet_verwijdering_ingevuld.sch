<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="reden-niet-verwijdering-ingevuld" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:LSkabel">
    <let name="should_be_tested"
        value="nlcs:Status = 'REVISIE' and nlcs:Bedrijfstoestand = 'VERLATEN'"/>
    <let name="missing_attributes"
        value="if ($should_be_tested) then ma:missing-attributes(., 'RedenNietVerwijdering') else ()"/>
        <assert id="reden-niet-verwijdering-present"
                test="empty($missing_attributes)"
                properties="scope rule-number severity object-type object-id missing-attributes">
            <value-of select="ma:missing-attributes-message($missing_attributes)"/>
        </assert>
    </rule>
</pattern>
