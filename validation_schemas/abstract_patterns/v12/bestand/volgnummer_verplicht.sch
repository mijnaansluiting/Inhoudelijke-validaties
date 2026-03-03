<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="volgnummer-verplicht" abstract="true">
    <rule context="//nlcs:AprojectReferentie[nlcs:Tekeningtype = 'DEELREVISIE' or nlcs:Tekeningtype = 'EINDREVISIE']">
        
        <assert id="nlcs-object-has-volgnummer"
                test="ma:element-exists-and-not-empty(nlcs:Volgnummer)"
                properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Volgnummer'])"/>
        </assert>
    </rule>
</pattern>
