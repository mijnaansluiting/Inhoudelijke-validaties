<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="lijn-geometrie-afstand-van-inmeetpunten" abstract="true">
     <rule context="//nlcs:MSkabel">
          <let name="line"
               value="tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList))"/>

          <let name="coords"
               value="for $line_segment in $line return xs:double($line_segment)"/>

          <let name="coords_amount"
               value="count($coords) idiv 3"/>

          <let name="line_segments_not_meeting_length_demands"
               value="
                    for $i in 1 to $coords_amount - 1
                    return
                         if (
                              keronic:point-3d-to-point-3d-distance(
                                   $coords[(3 * $i) - 2], $coords[(3 * $i) - 1], $coords[(3 * $i)],
                                   $coords[(3 * ($i + 1)) - 2], $coords[(3 * ($i + 1)) - 1], $coords[(3 * ($i + 1))]
                              ) le 0.1
                              or
                              keronic:point-3d-to-point-3d-distance(
                                   $coords[(3 * $i) - 2], $coords[(3 * $i) - 1], $coords[(3 * $i)],
                                   $coords[(3 * ($i + 1)) - 2], $coords[(3 * ($i + 1)) - 1], $coords[(3 * ($i + 1))]
                              ) ge 50
                         )
                         then keronic:create-gml-line(
                              (
                                   $coords[(3 * $i) - 2], $coords[(3 * $i) - 1], $coords[(3 * $i)],
                                   $coords[(3 * ($i + 1)) - 2], $coords[(3 * ($i + 1)) - 1], $coords[(3 * ($i + 1))]
                              ), 3, 7415)
                         else ()"/>

          <let name="geometries"
               value="$line_segments_not_meeting_length_demands"/>

          <assert id="line-geometry-line-segments-meet-length-demand"
               test="empty($line_segments_not_meeting_length_demands)"
               properties="scope rule-number severity object-type object-id geometries">
               <value-of select="keronic:get-translation('line-segment-measurement-incorrect')"/>
          </assert>
     </rule>

     <rule context="//nlcs:MSstation">
          <let name="area"
               value="tokenize(normalize-space(nlcs:Geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList))"/>

          <let name="coords"
               value="for $line_segment in $area return xs:double($line_segment)"/>

          <let name="coords_amount"
               value="count($coords) idiv 3"/>

          <let name="line_segments_not_meeting_length_demands"
               value="
                    for $i in 1 to $coords_amount - 1
                    return
                         if (
                              keronic:point-3d-to-point-3d-distance(
                                   $coords[(3 * $i) - 2], $coords[(3 * $i) - 1], $coords[(3 * $i)],
                                   $coords[(3 * ($i + 1)) - 2], $coords[(3 * ($i + 1)) - 1], $coords[(3 * ($i + 1))]
                              ) le 0.1
                              or
                              keronic:point-3d-to-point-3d-distance(
                                   $coords[(3 * $i) - 2], $coords[(3 * $i) - 1], $coords[(3 * $i)],
                                   $coords[(3 * ($i + 1)) - 2], $coords[(3 * ($i + 1)) - 1], $coords[(3 * ($i + 1))]
                              ) ge 50
                         )
                         then keronic:create-gml-line(
                              (
                                   $coords[(3 * $i) - 2], $coords[(3 * $i) - 1], $coords[(3 * $i)],
                                   $coords[(3 * ($i + 1)) - 2], $coords[(3 * ($i + 1)) - 1], $coords[(3 * ($i + 1))]
                              ), 3, 7415)
                         else ()"/>

          <let name="geometries"
               value="$line_segments_not_meeting_length_demands"/>

          <assert id="area-geometry-line-segments-meet-length-demand"
               test="empty($line_segments_not_meeting_length_demands)"
               properties="scope rule-number severity object-type object-id geometries">
               <value-of select="keronic:get-translation('line-segment-measurement-incorrect')"/>
          </assert>
     </rule>
</pattern>
