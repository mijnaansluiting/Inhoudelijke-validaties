<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="kabels-zelfde-netvlak" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="connected_msmoffen"
            value="ma:touching-moffen(.)[self::nlcs:MSmof]"/>

        <let name="connected_lskabels"
            value="ma:touching-kabels-via-moffen($connected_msmoffen, 'LSkabel')"/>

        <let name="connected_hskabels"
            value="ma:touching-kabels-via-moffen($connected_msmoffen, 'HSkabel')"/>

        <let name="all_connections_are_valid"
            value="empty($connected_hskabels) and empty($connected_lskabels)"/>

        <let name="geometries"
            value="if(not($all_connections_are_valid)) then ($connected_hskabels/nlcs:Geometry, $connected_lskabels/nlcs:Geometry) else ()"/>

        <let name="overlapping_moffen"
            value="$connected_msmoffen[ma:touching-kabels(.)[self::nlcs:HSkabel or self::nlcs:LSkabel]]"/>

        <let name="overlap_point"
            value="$overlapping_moffen/nlcs:Geometry"/>

        <assert id="mskabel-connected-to-hskabel-or-lskabel"
            test="$all_connections_are_valid"
            properties="scope rule-number severity object-type object-id geometries overlap-point">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-netvlak',
                    [$object_type, string(count($connected_hskabels)), 'HSkabel', string(count($connected_lskabels)), 'LSkabel'])"/>
        </assert>
    </rule>

    <rule context="//nlcs:LSkabel">
        <let name="connected_lsmoffen"
            value="ma:touching-moffen(.)[self::nlcs:LSmof]"/>

        <let name="connected_mskabels"
            value="ma:touching-kabels-via-moffen($connected_lsmoffen, 'MSkabel')"/>

        <let name="connected_hskabels"
            value="ma:touching-kabels-via-moffen($connected_lsmoffen, 'HSkabel')"/>

        <let name="all_connections_are_valid"
            value="empty($connected_hskabels) and empty($connected_mskabels)"/>

        <let name="geometries"
            value="if(not($all_connections_are_valid)) then ($connected_hskabels/nlcs:Geometry, $connected_mskabels/nlcs:Geometry) else ()"/>

        <let name="overlapping_moffen"
            value="$connected_lsmoffen[ma:touching-kabels(.)[self::nlcs:HSkabel or self::nlcs:MSkabel]]"/>

        <let name="overlap_point"
            value="$overlapping_moffen/nlcs:Geometry"/>

        <assert id="mskabel-connected-to-hskabel-or-lskabel"
            test="$all_connections_are_valid"
            properties="scope rule-number severity object-type object-id geometries">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-netvlak',
                    [$object_type, string(count($connected_hskabels)), 'HSkabel', string(count($connected_mskabels)), 'MSkabel'])"/>
        </assert>
    </rule>
</pattern>
