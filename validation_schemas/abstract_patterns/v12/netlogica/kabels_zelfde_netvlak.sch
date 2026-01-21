<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="kabels-zelfde-netvlak" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="line"
            value="ma:parse-line(nlcs:Geometry)"/>

        <let name="connected_msmoffen"
            value="//nlcs:MSmof[ma:point-touches-line(ma:parse-point(nlcs:Geometry), $line)]"/>

        <let name="connected_lskabels"
            value="//nlcs:LSkabel[
                some $connected_mof in $connected_msmoffen 
                satisfies ma:point-touches-line(
                    ma:parse-point($connected_mof/nlcs:Geometry),
                    ma:parse-line(nlcs:Geometry)
                )]"/>

        <let name="connected_hskabels"
            value="//nlcs:HSkabel[
                some $connected_mof in $connected_msmoffen 
                satisfies ma:point-touches-line(
                    ma:parse-point($connected_mof/nlcs:Geometry),
                    ma:parse-line(nlcs:Geometry)
                )]"/>

        <assert id="mskabel-connected-to-lskabel"
            test="empty($connected_lskabels)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders(
                'connected-cable-does-not-match-netvlak',
                [$object_type, string(count($connected_lskabels)),'LSkabel'])"/>
        </assert>

        <assert id="mskabel-connected-to-hskabel"
            test="empty($connected_hskabels)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders(
                'connected-cable-does-not-match-netvlak',
                [$object_type, string(count($connected_hskabels)), 'HSkabel'])"/>
        </assert>
    </rule>
</pattern>
