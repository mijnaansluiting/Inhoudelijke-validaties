<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" xmlns:gml="http://www.opengis.net/gml/3.2" 
         xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="lijn-geometrie-afstand-van-inmeetpunten-aanlegtechniek"
         abstract="true">
     <rule context="//nlcs:Aaanlegtechniek | //nlcs:Amantelbuis | //nlcs:MSkabel | //nlcs:LSkabel | 
                    //nlcs:HSkabel | //nlcs:Eaarddraad">
          <let name="coords" value="ma:parse-line(nlcs:Geometry)"/>

          <let name="max_distance" value="1"/>

          <let name="near_aanlegtechniek"
               value="exists(self::nlcs:Aaanlegtechniek)
                      or (some $aanlegtechniek in //nlcs:Aaanlegtechniek
                      satisfies ma:line-within-range-of-line(ma:parse-line($aanlegtechniek/nlcs:Geometry), 
                      $coords, $max_distance))"/>

          <let name="geometries"
               value="if ($near_aanlegtechniek) then ma:line-segments-not-meeting-length-demands($coords) else 
                      ()"/>

          <assert id="line-geometry-line-segments-meet-length-demand"
                  test="empty($geometries)"
                  properties="scope rule-number severity object-type object-id geometries">
               <value-of select="ma:get-translation('line-segment-measurement-incorrect')"/>
          </assert>
     </rule>
</pattern>
