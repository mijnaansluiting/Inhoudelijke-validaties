b<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verbonden-kabels-juiste-kenmerken" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="mskabel"
            value="."/>

<let name="functies_where_spanningsniveau_may_differ"
    value=('COMBI LS OV', AANSLUIT AFTAK')"/>

        <let name="connected_msmoffen"
            value="ma:touching-moffen($mskabel)[self::nlcs:MSmof]"/>

        <let name="connected_mskabels"
            value="ma:touching-kabels-via-moffen($connected_msmoffen, 'MSkabel')[. ne $mskabel]"/>

    <let name="should_test_spanningsniveau"
        value="some $connected_mof in $connected_msmoffen satisfies $connected_mof/nlcs:Functie = $functies_where_properties_may_differ"/>

        <let name="subnettype_must_be_equal"
        value="some $connected_mof in $connected_msmoffen satisfies not($connected_mof/nlcs:Functie = ('AANSLUIT AFTAK', 'AFTAK EINDMOF'))"

        <let name="subnettype_must_be_different"
        value="some $connected_mof in $connected_msmoffen satisfies $connected_mof/nlcs:Functie = 'AFTAK EINDMOF'"

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
            test="if($subnettype_must_be_equal) then empty($unexpected_subnettypes) else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Subnettype', $expected_subnettype, string-join($unexpected_subnettypes, ', ')])"/>
        </assert>

        <assert id="connected-mskabel-matches-subnettype"
            test=if($subnettype_must_be_different) then not(empty($unexpected_subnettypes)) else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation('connected-cable-should-match-subnettype')"/>
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
            test=if($should_test_spanningsniveau) then empty($unexpected_spanningsniveaus) else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Spanningsniveau', $expected_spanningsniveau, string-join($unexpected_spanningsniveaus, ', ')])"/>
        </assert>
    </rule>

    <rule context="//nlcs:LSkabel">
        <let name="lskabel"
            value="."/>

        <let name="connected_lsmoffen"
            value="ma:touching-moffen($lskabel)[self::nlcs:LSmof]"/>

        <let name="connected_lskabels"
            value="ma:touching-kabels-via-moffen($connected_lsmoffen, 'LSkabel')[. ne $lskabel]"/>

    <let name="should_test_spanningsniveau"
        value="some $connected_mof in $connected_lsmoffen satisfies $connected_mof/nlcs:Functie = $functies_where_properties_may_differ"/>

        <let name="subnettype_must_be_equal"
        value="some $connected_mof in $connected_lsmoffen satisfies not($connected_mof/nlcs:Functie = ('AANSLUIT AFTAK', 'AFTAK EINDMOF'))"

        <let name="subnettype_must_be_different"
        value="some $connected_mof in $connected_lsmoffen satisfies $connected_mof/nlcs:Functie = 'AFTAK EINDMOF'"

        <!-- Compare bedrijfstoestanden against original-->

        <let name="expected_bedrijfstoestand"
            value="nlcs:Bedrijfstoestand"/>

        <let name="unexpected_bedrijfstoestanden"
            value="distinct-values($connected_lskabels/nlcs:Bedrijfstoestand)[. != $expected_bedrijfstoestand]"/>

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
            value="distinct-values($connected_lskabels/nlcs:Subnettype)[. != $expected_subnettype]"/>

        <assert id="connected-mskabel-does-not-match-subnettype"
            test="if($subnettype_must_be_equal) then empty($unexpected_subnettypes) else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Subnettype', $expected_subnettype, string-join($unexpected_subnettypes, ', ')])"/>
        </assert>

        <assert id="connected-mskabel-matches-subnettype"
            test=if($subnettype_must_be_different) then not(empty($unexpected_subnettypes)) else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation('connected-cable-should-match-subnettype')"/>
            </assert>

        <!-- Compare verbindingnummers against original-->

        <let name="expected_verbindingnummer"
            value="nlcs:Verbindingnummer"/>

        <let name="unexpected_verbindingnummers"
            value="distinct-values($connected_lskabels/nlcs:Verbindingnummer)[. != $expected_verbindingnummer]"/>

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
            value="distinct-values($connected_lskabels/nlcs:Spanningsniveau)[. != $expected_spanningsniveau]"/>

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
            test=if($should_test_spanningsniveau) then empty($unexpected_spanningsniveaus) else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-property',
                    ['Spanningsniveau', $expected_spanningsniveau, string-join($unexpected_spanningsniveaus, ', ')])"/>
        </assert>
    </rule>
</pattern>
