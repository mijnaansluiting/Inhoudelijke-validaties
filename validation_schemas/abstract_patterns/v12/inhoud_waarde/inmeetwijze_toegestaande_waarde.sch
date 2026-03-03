<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="inmeetwijze-toegestaande-waarde" abstract="true">
    <rule context="//nlcs:LSkabel">
        <let name="inmeetwijze"
            value="nlcs:Inmeetwijze"/>

        <let name="subnettype"
            value="nlcs:Subnettype"/>

        <let name="allowed_inmeetwijzen"
            value="ma:allowed-inmeetwijzen()"/>

        <let name="aansluitnet_meetlint_exception"
            value="$subnettype = 'AANSLUITNET' and $inmeetwijze = 'Meetlint'"/>

        <assert id="inmeetwijze-not-allowed"
            properties="scope rule-number severity object-type object-id"
            test="if(not($aansluitnet_meetlint_exception)) then $inmeetwijze = $allowed_inmeetwijzen else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('inmeetwijze-not-allowed', [$inmeetwijze, string-join($allowed_inmeetwijzen, ', ')])"/>
        </assert>
    </rule>
</pattern>
