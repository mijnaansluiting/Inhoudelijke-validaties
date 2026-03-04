<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="reden-niet-verwijdering-ingevuld" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:LSkabel">
    <let name="should_be_tested"
        value="nlcs:Status = 'REVISIE' and nlcs:Bedrijfstoestand = 'VERLATEN'"/>
        <assert id="reden-niet-verwijdering-present"
                test="if($should_be_tested) then ma:element-exists-and-not-empty(nlcs:RedenNietVerwijdering) else true()"
                properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['RedenNietVerwijdering'])"/>
        </assert>
    </rule>
</pattern>
