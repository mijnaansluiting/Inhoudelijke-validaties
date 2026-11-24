<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verbonden-kabels-juiste-kenmerken" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="mskabel"
            value="."/>

        <let name="connected_msmoffen"
            value="ma:touching-moffen($mskabel)[self::nlcs:MSmof]"/>

        <let name="connected_mskabels"
            value="ma:touching-kabels-via-moffen($connected_msmoffen, 'MSkabel')[. ne $mskabel]"/>

        <!-- Compare bedrijfstoestanden against original-->

        <let name="expected_bedrijfstoestand"
            value="nlcs:Bedrijfstoestand"/>

        <let name="unexpected_bedrijfstoestanden"
            value="distinct-values($connected_mskabels/nlcs:Bedrijfstoestand)[. != $expected_bedrijfstoestand]"/>

        <assert id="connected-mskabel-does-not-match-bedrijfstoestand"
            test="empty($unexpected_bedrijfstoestanden)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Bedrijfstoestand', $expected_bedrijfstoestand, string-join($unexpected_bedrijfstoestanden, ', ')])"/>
        </assert>

        <!-- Compare subnettypes against original-->

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

        <!-- Compare verbindingnummers against original-->

        <let name="expected_verbindingnummer"
            value="nlcs:Verbindingnummer"/>

        <let name="unexpected_verbindingnummers"
            value="distinct-values($connected_mskabels/nlcs:Verbindingnummer)[. != $expected_verbindingnummer]"/>

        <assert id="connected-mskabel-does-not-match-verbindingnummer"
            test="empty($unexpected_verbindingnummers)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Verbindingnummer', $expected_verbindingnummer, string-join($unexpected_verbindingnummers, ', ')])"/>
        </assert>

        <!-- Compare spanningsniveaus against original-->

        <let name="expected_spanningsniveau"
            value="nlcs:Spanningsniveau"/>

        <let name="unexpected_spanningsniveaus"
            value="distinct-values($connected_mskabels/nlcs:Spanningsniveau)[. != $expected_spanningsniveau]"/>

        <let name="overlapping_moffen"
            value="$connected_msmoffen[
                    some $kabel in ma:touching-kabels(.)[self::nlcs:MSkabel][not(. is $mskabel)]
                    satisfies ($kabel/nlcs:Bedrijfstoestand != $expected_bedrijfstoestand
                            or $kabel/nlcs:Subnettype       != $expected_subnettype
                            or $kabel/nlcs:Verbindingnummer != $expected_verbindingnummer
                            or $kabel/nlcs:Spanningsniveau  != $expected_spanningsniveau)]"/>

        <let name="overlap_point"
            value="$overlapping_moffen/nlcs:Geometry"/>

        <assert id="connected-mskabel-does-not-match-spanningsniveau"
            test="empty($unexpected_spanningsniveaus)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Spanningsniveau', $expected_spanningsniveau, string-join($unexpected_spanningsniveaus, ', ')])"/>
        </assert>
    </rule>

    <rule context="//nlcs:LSkabel">
        <let name="lskabel"
            value="."/>

        <let name="functies_where_subnettype_may_differ"
            value="('AANSLUIT AFTAK')"/>

        <let name="functies_where_spanningsniveau_may_differ"
            value="('AANSLUIT AFTAK', 'COMBI LS OV')"/>

        <let name="connected_lsmoffen"
            value="ma:touching-moffen($lskabel)[self::nlcs:LSmof]"/>

        <let name="connected_lskabels"
            value="ma:touching-kabels-via-moffen($connected_lsmoffen, 'LSkabel')[not(. is $lskabel)]"/>

        <let name="connected_lskabels_with_equal_subnettype"
            value="ma:touching-kabels-via-moffen(
                    $connected_lsmoffen[not(nlcs:Functie = $functies_where_subnettype_may_differ)],
                    'LSkabel')[not(. is $lskabel)]"/>

        <let name="connected_lskabels_with_equal_spanningsniveau"
            value="ma:touching-kabels-via-moffen(
                    $connected_lsmoffen[not(nlcs:Functie = $functies_where_spanningsniveau_may_differ)],
                    'LSkabel')[not(. is $lskabel)]"/>

        <let name="expected_bedrijfstoestand"
            value="nlcs:Bedrijfstoestand"/>

        <let name="expected_subnettype"
            value="nlcs:Subnettype"/>

        <let name="expected_verbindingnummer"
            value="nlcs:Verbindingnummer"/>

        <let name="expected_spanningsniveau"
            value="nlcs:Spanningsniveau"/>

        <let name="unexpected_bedrijfstoestanden"
            value="distinct-values($connected_lskabels/nlcs:Bedrijfstoestand)[. != $expected_bedrijfstoestand]"/>

        <let name="unexpected_subnettypes"
            value="distinct-values($connected_lskabels_with_equal_subnettype/nlcs:Subnettype)[. != $expected_subnettype]"/>

        <let name="unexpected_verbindingnummers"
            value="distinct-values($connected_lskabels/nlcs:Verbindingnummer)[. != $expected_verbindingnummer]"/>

        <let name="unexpected_spanningsniveaus"
            value="distinct-values($connected_lskabels_with_equal_spanningsniveau/nlcs:Spanningsniveau)[. != $expected_spanningsniveau]"/>

        <let name="aftak_eindmoffen_with_wrong_subnettype"
            value="$connected_lsmoffen[nlcs:Functie = 'AFTAK EINDMOF'][$expected_subnettype != 'DISTRIBUTIE']"/>

        <let name="overlapping_moffen"
            value="$connected_lsmoffen[
                    some $kabel in ma:touching-kabels(.)[self::nlcs:LSkabel][not(. is $lskabel)]
                    satisfies ($kabel/nlcs:Bedrijfstoestand != $expected_bedrijfstoestand
                            or $kabel/nlcs:Verbindingnummer != $expected_verbindingnummer
                            or (not(nlcs:Functie = $functies_where_subnettype_may_differ)
                                and $kabel/nlcs:Subnettype != $expected_subnettype)
                            or (not(nlcs:Functie = $functies_where_spanningsniveau_may_differ)
                                and $kabel/nlcs:Spanningsniveau != $expected_spanningsniveau))]"/>

        <let name="overlap_point"
            value="($overlapping_moffen | $aftak_eindmoffen_with_wrong_subnettype)/nlcs:Geometry"/>

        <assert id="connected-lskabel-does-not-match-bedrijfstoestand"
            test="empty($unexpected_bedrijfstoestanden)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Bedrijfstoestand', $expected_bedrijfstoestand, string-join($unexpected_bedrijfstoestanden, ', ')])"/>
        </assert>

        <assert id="connected-lskabel-does-not-match-subnettype"
            test="empty($unexpected_subnettypes)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Subnettype', $expected_subnettype, string-join($unexpected_subnettypes, ', ')])"/>
        </assert>

        <assert id="connected-lskabel-does-not-match-verbindingnummer"
            test="empty($unexpected_verbindingnummers)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Verbindingnummer', $expected_verbindingnummer, string-join($unexpected_verbindingnummers, ', ')])"/>
        </assert>

        <assert id="connected-lskabel-does-not-match-spanningsniveau"
            test="empty($unexpected_spanningsniveaus)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Spanningsniveau', $expected_spanningsniveau, string-join($unexpected_spanningsniveaus, ', ')])"/>
        </assert>

        <assert id="lskabel-at-aftak-eindmof-has-subnettype-distributie"
            test="empty($aftak_eindmoffen_with_wrong_subnettype)"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'cable-at-mof-functie-has-wrong-subnettype',
                    ['AFTAK EINDMOF', 'DISTRIBUTIE', string($expected_subnettype)])"/>
        </assert>
    </rule>
</pattern>
