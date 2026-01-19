<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="geometrie-binnen-projectvlak" abstract="true">
    <!-- Point geometries -->
    <rule context="//nlcs:MSmof | //nlcs:MSoverdrachtspunt">
        <assert id="assert-point-inside-project-area"
            test="ma:point-interacts-with-area(nlcs:Geometry, //nlcs:AprojectReferentie/nlcs:Geometry)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>

    <!-- Line geometries -->
    <rule context="//nlcs:MSkabel | //nlcs:Amantelbuis | //nlcs:Akunstwerk | //nlcs:Eaarddraad | //nlcs:Aaanlegtechniek">
        <assert id="assert-line-inside-project-area"
            test="ma:line-interacts-with-area(nlcs:Geometry, //nlcs:AprojectReferentie/nlcs:Geometry)"
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
            test="ma:area-interacts-with-area(nlcs:Geometry, //nlcs:AprojectReferentie/nlcs:Geometry)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>
</pattern>
