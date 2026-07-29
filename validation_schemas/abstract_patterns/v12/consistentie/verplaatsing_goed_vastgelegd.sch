<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplaatsing-goed-vastgelegd" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:LSkabel">
        <let name="is_verplaatsing"
            value="nlcs:Status = 'REVISIE' and nlcs:Bewerking = 'VERPLAATSEN'"/>

        <assert id="verplaatsing-cannot-have-asset-id"
            properties="scope rule-number severity object-type object-id"
            test="if($is_verplaatsing) then not(nlcs:AssetId) else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('property-not-allowed-for-statuses', ['AssetId', 'REVISIE'])"/>
        </assert>

        <let name="has_bestaand_original"
            value="some $cable in //nlcs:NLCSnetbeheer/* satisfies
                $cable ne . and
                name($cable) = name(.) and
                $cable/nlcs:Status = 'BESTAAND' and
                $cable/nlcs:GisId = nlcs:GisId"/>

        <let name="is_ontwerptekening"
            value="contains(//nlcs:AprojectReferentie/nlcs:Tekeningtype, 'ONTWERP')"/>

        <assert id="ontwerp-verplaatsing-has-original"
            test="if ($is_verplaatsing and $is_ontwerptekening) then $has_bestaand_original else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('verplaatsing-incorrectly-applied', [name(.)])"/>
        </assert>

        <let name="has_some_original"
            value="some $cable in //nlcs:NLCSnetbeheer/* satisfies
                $cable ne . and
                name($cable) = name(.) and
                $cable/nlcs:GisId = nlcs:GisId"/>

        <let name="is_revisietekening"
            value="contains(//nlcs:AprojectReferentie/nlcs:Tekeningtype, 'REVISIE')"/>

        <assert id="revisie-verplaatsing-has-no-original"
            test="if ($is_verplaatsing and $is_revisietekening) then not($has_some_original) else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="'TODO: revisie verplaatsing incorrect'"/>
        </assert>

        <assert id="revisie-verplaatsing-has-gisid"
            test="if ($is_verplaatsing and $is_revisietekening) then ma:element-exists-and-not-empty(nlcs:GisId) else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="'TODO: revisie verplaatsing no GisId'"/>
        </assert>
    </rule>
</pattern>
