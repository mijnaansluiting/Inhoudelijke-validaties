<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="geldig-eindpunt-kabel" abstract="true">
    <rule context="//nlcs:MSkabel">

        <let name="project_area_pos_list"
            value="tokenize(normalize-space(//nlcs:AprojectReferentie/nlcs:Geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList))"/>

        <let name="geometry"
            value="tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList))"/>

        <let name="moffen-geometries"
            value="//nlcs:MSmof/nlcs:Geometry/gml:Point/gml:pos"/>

        <let name="overdrachtspunt-geometries"
            value="//nlcs:MSoverdrachtspunt/nlcs:Geometry/gml:Point/gml:pos"/>

        <let name="station-geometries"
            value="//nlcs:MSstation/nlcs:Geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList"/>

        <let name="first-point"
            value="$geometry[1], $geometry[2], $geometry[3]"
            as="xs:string*"/>

        <let name="last-point"
            value="$geometry[count($geometry) - 2], $geometry[count($geometry) - 1], $geometry[count($geometry)]"
            as="xs:string*"/>

        <let name="first-connected-to-moffen"
            value="keronic:point-3d-connected-to-one-of-several-point-3d($first-point, $moffen-geometries)"/>

        <let name="last-connected-to-moffen"
            value="keronic:point-3d-connected-to-one-of-several-point-3d($last-point, $moffen-geometries)"/>

        <let name="first-connected-to-overdrachtspunt"
            value="keronic:point-3d-connected-to-one-of-several-point-3d($first-point, $overdrachtspunt-geometries)"/>

        <let name="last-connected-to-overdrachtspunt"
            value="keronic:point-3d-connected-to-one-of-several-point-3d($last-point, $overdrachtspunt-geometries)"/>

        <let name="first-connected-to-station"
            value="keronic:point-3d-connected-to-one-of-several-area-3d($first-point, $station-geometries)"/>

        <let name="last-connected-to-station"
            value="keronic:point-3d-connected-to-one-of-several-area-3d($last-point, $station-geometries)"/>

        <let name="first-connected"
            value="$first-connected-to-moffen or $first-connected-to-overdrachtspunt or $first-connected-to-station"/>

        <let name="last-connected"
            value="$last-connected-to-moffen or $last-connected-to-overdrachtspunt or $last-connected-to-station"/>

                <assert id="first_point_connected" test="if(nlcs:Bedrijfstoestand ne 'VERLATEN' and keronic:point-3d-interacts-with-area-2d($first-point, $project_area_pos_list)) then $first-connected else true()"
                properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:Handle])"/>
        </assert>

        <assert id="last_point_connected" test="if(nlcs:Bedrijfstoestand ne 'VERLATEN' and keronic:point-3d-interacts-with-area-2d($last-point, $project_area_pos_list)) then $last-connected else true()"
                properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:ID])"/>
        </assert>
    </rule>
</pattern>
