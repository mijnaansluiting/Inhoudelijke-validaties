<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="topologie-punt-objecten-elec" abstract="true">
    <rule context="//nlcs:MSmof | //nlcs:MSoverdrachtspunt">
        <let name="mskabel_pos_lists"
            value="//nlcs:MSkabel/nlcs:Geometry/gml:LineString/gml:posList"/>

        <let name="point"
            value="tokenize(normalize-space(nlcs:Geometry/gml:Point/gml:pos))"/>

        <let name="point_connected"
            value="some $pos_list in $mskabel_pos_lists satisfies keronic:point-3d-touches-line-3d($point, tokenize(normalize-space($pos_list)), 0)"/>

        <assert id="point-connected-to-kabel"
            test="$point_connected"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('point-not-connected-to-any-line')"/>
        </assert>
    </rule>
</pattern>
