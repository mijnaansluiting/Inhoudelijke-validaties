<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verbonden-kabels-juiste-kenmerken" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="connected_msmoffen"
            value="ma:touching-moffen($mskabel)[self::nlcs:MSmof]"/>

        <let name="overlap_point"
            value="$overlapping_moffen/nlcs:Geometry"/>

        <let name="expected_subnettype"
            value="nlcs:Subnettype"/>

        <let name="unexpected_subnettypes"
            value="distinct-values($connected_mskabels/nlcs:Subnettype)[. != $expected_subnettype]"/>

        <assert id="connected-mskabel-does-not-match-subnettype"
            test="empty($unexpected_subnettypes)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Subnettype', $expected_subnettype, string-join($unexpected_subnettypes, ', ')])"/>
        </assert>

        <assert id="subnettype_correct"
            test="every $connected_mof in $connected_msmoffen satisfies if ($connected_mof/nlcs:Functie = 'LOODKOP') then $connected_mof/nlcs:Subnettype = 'DISTRIBUTIE' else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
        </assert>
    </rule>

    <rule context="//nlcs:LSkabel">
        <let name="connected_lsmoffen"
            value="ma:touching-moffen($lskabel)[self::nlcs:LSmof]"/>


        <assert id="subnettype_correct"
            test="every $connected_mof in $connected_lsmoffen satisfies if ($connected_mof/nlcs:Functie = 'LOODKOP') then $connected_mof/nlcs:Subnettype = 'DISTRIBUTIE' else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
        </assert>
    </rule>
</pattern>
