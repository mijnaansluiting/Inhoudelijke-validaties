<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aantal-kabels-en-mof-functie" abstract="true">
    <rule context="//nlcs:MSmof">
        <let name="msmof"
            value="."/>

        <let name="connected_mskabels"
            value="//nlcs:MSkabel[keronic:line-3d-connected-to-point-3d(
                tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList)),
                tokenize(normalize-space($msmof/nlcs:Geometry/gml:Point/gml:pos)),
                0)]"/>

        <let name="functie_type"
            value="keronic:map-mof-functie(nlcs:Functie)"/>

        <let name="is_aftak_from_existing_cable"
            value="$functie_type = 'Aftak' and not(empty($connected_mskabels[nlcs:Status = 'BESTAAND']))"/>

        <let name="required_connections"
            value="if($functie_type = 'Eind') then 1
                else if($functie_type = 'Verbinding') then 2
                else if($functie_type = 'Faseovergang') then 4
                else if($is_aftak_from_existing_cable) then 2
                else if($functie_type = 'Aftak') then 3
                else -1
            "/>

        <let name="connections"
            value="count($connected_mskabels)"/>

        <assert id="mof_connected_to_right_amount_of_cables"
            properties="scope rule-number severity object-type object-id"
            test="$connections = $required_connections">
            <value-of select="keronic:get-translation-and-replace-placeholders('cable-amount-incorrect', [string($required_connections), string($connections)])"/>
        </assert>

        <let name="connected_to_new_cable"
            value="not(empty($connected_mskabels[./nlcs:Status = 'NIEUW']))"/>

        <assert id="aftak_from_existing_cable_must_be_new_cable"
            properties="scope rule-number severity object-type object-id"
            test="if($is_aftak_from_existing_cable) then $connected_to_new_cable else true()">
            <value-of select="keronic:get-translation('existing-cable-not-connected-to-new-cable')"/>
        </assert>
    </rule>
</pattern>
