<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="kabels-zelfde-netvlak" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="mskabel"
            value="."/>

        <let name="connected_msmoffen"
            value="//nlcs:MSmof[
                keronic:point-3d-touches-line-3d(
                    tokenize(normalize-space(nlcs:Geometry/gml:Point/gml:pos)),
                    tokenize(normalize-space($mskabel/nlcs:Geometry/gml:LineString/gml:posList)),
                    0)]"/>

        <let name="connected_lskabels"
            value="//nlcs:LSkabel[
                some $connected_mof in $connected_msmoffen satisfies
                    keronic:line-3d-touches-point-3d(
                        tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList)),
                        tokenize(normalize-space($connected_mof/nlcs:Geometry/gml:Point/gml:pos)),
                        0)]"/>

        <let name="connected_hskabels"
            value="//nlcs:HSkabel[
                some $connected_mof in $connected_msmoffen satisfies
                    keronic:line-3d-touches-point-3d(
                        tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList)),
                        tokenize(normalize-space($connected_mof/nlcs:Geometry/gml:Point/gml:pos)),
                        0)]"/>

        <assert id="mskabel-connected-to-lskabel"
            test="empty($connected_lskabels)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders(
                'connected-cable-does-not-match-netvlak',
                [$object_type, string(count($connected_lskabels)),'LSkabel'])"/>
        </assert>

        <assert id="mskabel-connected-to-hskabel"
            test="empty($connected_hskabels)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders(
                'connected-cable-does-not-match-netvlak',
                [$object_type, string(count($connected_hskabels)), 'HSkabel'])"/>
        </assert>
    </rule>
</pattern>
