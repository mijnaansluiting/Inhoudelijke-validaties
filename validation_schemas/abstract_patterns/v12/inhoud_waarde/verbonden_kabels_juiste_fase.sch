<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verbonden-kabels-juiste-fase" abstract="true">
    <rule context="//nlcs:MSmof">
        <let name="msmof"
            value="."/>

        <let name="connected_mskabels"
            value="//nlcs:MSkabel[keronic:line-3d-connected-to-point-3d(
                        tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList)),
                        tokenize(normalize-space($msmof/nlcs:Geometry/gml:Point/gml:pos)),
                        0)]"/>

        <let name="unique_connected_phases"
            value="distinct-values($connected_mskabels/nlcs:FaseAanduiding)"/>

        <let name="allowed_phases"
            value="('3 Fasen', 'L1', 'L2', 'L3')"/>

        <let name="unique_allowed_connected_phases"
            value="$unique_connected_phases[. = $allowed_phases]"/>

        <let name="unique_unallowed_connected_phases"
            value="$unique_connected_phases[not(. = $allowed_phases)]"/>

        <let name="connections"
            value="count($connected_mskabels)"/>

        <let name="all_connected_cables_match_fases"
            value="count($unique_connected_phases) = 1"/>

        <let name="all_connected_cables_have_combined_and_split_fases"
            value="count($unique_allowed_connected_phases) = 4"/>

        <assert id="msmof-2-3-4-connected-only-allowed-phases"
            properties="scope rule-number severity object-type object-id"
            test="if($connections = 2 or $connections = 3 or $connections = 4) then empty($unique_unallowed_connected_phases) else true()">
            <value-of select="keronic:get-translation-and-replace-placeholders(
                'connected-fases-not-allowed',
                [string($connections), string-join($unique_unallowed_connected_phases, ', ')])"/>
        </assert>

        <assert id="msmof-2-3-connected-cables-have-same-fase"
            properties="scope rule-number severity object-type object-id"
            test="if($connections = 2 or $connections = 3) then $all_connected_cables_match_fases else true()">
            <value-of select="keronic:get-translation-and-replace-placeholders(
                'connected-fases-do-not-match',
                [string($connections), string-join($unique_connected_phases, ', ')])"/>
        </assert>

        <assert id="msmof-4-connected-cables-have-combined-and-split-fasen"
            properties="scope rule-number severity object-type object-id"
            test="if($connections = 4) then $all_connected_cables_have_combined_and_split_fases else true()">
            <value-of select="keronic:get-translation-and-replace-placeholders(
                'connected-fases-do-not-split',
                [string-join($allowed_phases, ', '), string-join($connected_mskabels/nlcs:FaseAanduiding, ', ')])"/>
        </assert>

    </rule>
</pattern>
