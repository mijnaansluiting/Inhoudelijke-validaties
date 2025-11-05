<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="geometrie-binnen-projectvlak" abstract="true">
    <!-- Point geometries -->
    <rule context="//nlcs:MSmof | //nlcs:MSoverdrachtspunt">
        <let name="project_area_pos_list"
            value="tokenize(normalize-space(//nlcs:AprojectReferentie/nlcs:Geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList))"/>

        <let name="point_pos"
            value="tokenize(normalize-space((nlcs:Geometry/gml:Point/gml:pos)))"/>

        <assert id="assert-point-inside-project-area"
            test="keronic:point-3d-interacts-with-area-2d($point_pos, $project_area_pos_list)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>

    <!-- Line geometries -->
    <rule context="//nlcs:MSkabel | //nlcs:Amantelbuis | //nlcs:Akunstwerk | //nlcs:Eaarddraad | //nlcs:Aaanlegtechniek">
        <let name="project_area_pos_list"
            value="tokenize(normalize-space(//nlcs:AprojectReferentie/nlcs:Geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList))"/>

        <let name="line_pos_list"
            value="tokenize(normalize-space((nlcs:Geometry/gml:LineString/gml:posList)))"/>

        <assert id="assert-line-inside-project-area"
            test="keronic:line-3d-interacts-with-area-2d($line_pos_list, $project_area_pos_list)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>

    <!-- Area geometries -->
    <rule context="//nlcs:MSstation | //nlcs:AbeschermingVlak">
        <let name="project_area_pos_list"
            value="tokenize(normalize-space(//nlcs:AprojectReferentie/nlcs:Geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList))"/>

        <let name="area_pos_list"
            value="tokenize(normalize-space((nlcs:Geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList)))"/>

        <assert id="assert-area-interacts-with-project-area"
            test="keronic:area-2d-interacts-with-area-2d($area_pos_list, $project_area_pos_list)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>
</pattern>
