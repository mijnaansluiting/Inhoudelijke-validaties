<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verbonden-kabels-juiste-kenmerken" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="mskabel"
            value="."/>

        <let name="connected_msmoffen"
            value="//nlcs:MSmof[
                keronic:point-3d-touches-line-3d(
                    tokenize(normalize-space(nlcs:Geometry/gml:Point/gml:pos)),
                    tokenize(normalize-space($mskabel/nlcs:Geometry/gml:LineString/gml:posList)),
                    0)]"/>

        <let name="connected_mskabels"
            value="//nlcs:MSkabel[
                some $connected_mof in $connected_msmoffen satisfies
                    . ne $mskabel and
                    keronic:line-3d-touches-point-3d(
                        tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList)),
                        tokenize(normalize-space($connected_mof/nlcs:Geometry/gml:Point/gml:pos)),
                        0)]"/>

        <!-- Compare bedrijfstoestanden against original-->

        <let name="expected_bedrijfstoestand"
            value="nlcs:Bedrijfstoestand"/>

        <let name="unexpected_bedrijfstoestanden"
            value="distinct-values($connected_mskabels/nlcs:Bedrijfstoestand)[. != $expected_bedrijfstoestand]"/>

        <assert id="connected-mskabel-does-not-match-bedrijfstoestand"
            test="empty($unexpected_bedrijfstoestanden)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders(
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
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders(
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
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders(
                'connected-cable-does-not-match-property',
                ['Verbindingnummer', $expected_verbindingnummer, string-join($unexpected_verbindingnummers, ', ')])"/>
        </assert>

        <!-- Compare spanningsniveaus against original-->

        <let name="expected_spanningsniveau"
            value="nlcs:Spanningsniveau"/>

        <let name="unexpected_spanningsniveaus"
            value="distinct-values($connected_mskabels/nlcs:Spanningsniveau)[. != $expected_spanningsniveau]"/>

        <assert id="connected-mskabel-does-not-match-spanningsniveau"
            test="empty($unexpected_spanningsniveaus)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders(
                'connected-cable-does-not-match-property',
                ['Spanningsniveau', $expected_spanningsniveau, string-join($unexpected_spanningsniveaus, ', ')])"/>
        </assert>
    </rule>
</pattern>
