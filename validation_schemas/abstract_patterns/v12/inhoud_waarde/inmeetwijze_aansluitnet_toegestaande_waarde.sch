<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="inmeetwijze-aansluitnet-toegestaande-waarde" abstract="true">
    <rule context="//nlcs:LSkabel">
        <let name="inmeetwijze"
            value="nlcs:Inmeetwijze"/>

        <let name="subnettype"
            value="nlcs:Subnettype"/>

        <let name="allowed_inmeetwijzen"
            value="ma:allowed-inmeetwijzen()"/>

        <assert id="inmeetwijze-not-allowed"
            properties="scope rule-number severity object-type object-id"
            test="not($subnettype = 'AANSLUITNET' and $inmeetwijze = 'Meetlint')">
            <value-of select="ma:get-translation-and-replace-placeholders('inmeetwijze-not-allowed', [$inmeetwijze, string-join($allowed_inmeetwijzen, ', ')])"/>
        </assert>
    </rule>
</pattern>
