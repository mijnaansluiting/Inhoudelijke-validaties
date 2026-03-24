<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="kabels-zelfde-netvlak" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="line"
            value="ma:parse-line-alt(nlcs:Geometry)"/>
        
        <let name="connected_msmoffen"
            value="//nlcs:MSmof[ma:point-touches-line-alt(ma:parse-point-alt(nlcs:Geometry), $line)]"/>
        
        <let name="connected_lskabels"
            value="//nlcs:LSkabel[
                    some $connected_mof in $connected_msmoffen 
                    satisfies ma:point-touches-line-alt(ma:parse-point-alt($connected_mof/nlcs:Geometry), ma:parse-line-alt(nlcs:Geometry))]"/>
        
        <let name="connected_hskabels"
            value="//nlcs:HSkabel[
                    some $connected_mof in $connected_msmoffen 
                    satisfies ma:point-touches-line-alt(ma:parse-point-alt($connected_mof/nlcs:Geometry), ma:parse-line-alt(nlcs:Geometry))]"/>
        
        <let name="all_connections_are_valid"
            value="empty($connected_hskabels) and empty($connected_lskabels)"/>

        <let name="geometries"
            value="if(not($all_connections_are_valid)) then ($connected_hskabels/nlcs:Geometry, $connected_lskabels/nlcs:Geometry) else ()"/>
        
        <assert id="mskabel-connected-to-hskabel-or-lskabel"
            test="$all_connections_are_valid"
            properties="scope rule-number severity object-type object-id geometries">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-netvlak',
                    [$object_type, string(count($connected_hskabels)), 'HSkabel', string(count($connected_lskabels)), 'LSkabel'])"/>
        </assert>
    </rule>
    
    <rule context="//nlcs:LSkabel">
        <let name="line"
            value="ma:parse-line-alt(nlcs:Geometry)"/>
        
        <let name="connected_lsmoffen"
            value="//nlcs:LSmof[ma:point-touches-line-alt(ma:parse-point-alt(nlcs:Geometry), $line)]"/>
        
        <let name="connected_mskabels"
            value="//nlcs:MSkabel[
                    some $connected_mof in $connected_lsmoffen 
                    satisfies ma:point-touches-line-alt(
                            ma:parse-point-alt($connected_mof/nlcs:Geometry),
                            ma:parse-line-alt(nlcs:Geometry)
                        )]"/>
        
        <let name="connected_hskabels"
            value="//nlcs:HSkabel[
                    some $connected_mof in $connected_lsmoffen 
                    satisfies ma:point-touches-line-alt(
                            ma:parse-point-alt($connected_mof/nlcs:Geometry),
                            ma:parse-line-alt(nlcs:Geometry)
                        )]"/>
        
        <let name="all_connections_are_valid"
            value="empty($connected_hskabels) and empty($connected_mskabels)"/>

        <let name="geometries"
            value="if(not($all_connections_are_valid)) then ($connected_hskabels/nlcs:Geometry, $connected_mskabels/nlcs:Geometry) else ()"/>
        
        <assert id="mskabel-connected-to-hskabel-or-lskabel"
            test="$all_connections_are_valid"
            properties="scope rule-number severity object-type object-id geometries">
            <value-of select="ma:get-translation-and-replace-placeholders(
                    'connected-cable-does-not-match-netvlak',
                    [$object_type, string(count($connected_hskabels)), 'HSkabel', string(count($connected_mskabels)), 'MSkabel'])"/>
        </assert>
    </rule>
</pattern>
