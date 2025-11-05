<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="lijn-geometrie-hoek-van-segmenten" abstract="true">
     <rule context="//nlcs:MSkabel | //nlcs:Eaarddraad | //nlcs:AaanlegTechniek">
          <let name="geometry"
               value="tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList))"/>

          <let name="coords"
               value="for $geom in $geometry return xs:double($geom)"/>

          <let name="coords_amount"
               value="count($geometry) idiv 3"/>

          <let name="points_not_meeting_angle_demand"
               value="
                    for $i in 1 to $coords_amount - 2
                    return
                         if (
                              keronic:line-3d-contains-larger-angle-than(
                                   (
                                        $geometry[(3 * $i) - 2], $geometry[(3 * $i) - 1], $geometry[(3 * $i)],
                                        $geometry[(3 * ($i + 1)) - 2], $geometry[(3 * ($i + 1)) - 1], $geometry[(3 * ($i + 1))],
                                        $geometry[(3 * ($i + 2)) - 2], $geometry[(3 * ($i + 2)) - 1], $geometry[(3 * ($i + 2))]
                                   ), '45')
                         )
                         then keronic:create-gml-point(
                              (
                                   $geometry[(3 * ($i + 1)) - 2], $geometry[(3 * ($i + 1)) - 1], $geometry[(3 * ($i + 1))]
                              ), 3, 7415)
                         else ()"/>

          <let name="geometries"
               value="$points_not_meeting_angle_demand"/>

          <assert id="line-geometry-line-segments-meet-angle-demand"
               test="empty($points_not_meeting_angle_demand)"
               properties="scope rule-number severity object-type object-id geometries">
               <value-of select="keronic:get-translation('line-angle-larger-than-45')"/>
          </assert>
     </rule>
</pattern>
