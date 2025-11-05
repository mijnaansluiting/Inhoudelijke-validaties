<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplaatsing-goed-vastgelegd" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:LSkabel">
        <let name="is_verplaatsing"
            value="nlcs:Status = 'REVISIE' and nlcs:Bewerking = 'VERPLAATSEN'"/>

        <assert id="verplaatsing-cannot-have-asset-id"
            properties="scope rule-number severity object-type object-id"
            test="if($is_verplaatsing) then not(nlcs:AssetId) else true()">
            <value-of select="keronic:get-translation-and-replace-placeholders('property-not-allowed-for-statuses', ['AssetId', 'REVISIE'])"/>
        </assert>

        <let name="has_some_original"
            value="some $cable in //nlcs:NLCSnetbeheer/* satisfies
                name($cable) = name(.) and
                $cable/nlcs:Status = 'BESTAAND' and
                $cable/nlcs:GisId = nlcs:GisId"/>

        <assert id="verplaatsing-correctly-applied"
            test="if ($is_verplaatsing) then $has_some_original else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('verplaatsing-incorrectly-applied', [name(.)])"/>
        </assert>
    </rule>
</pattern>
