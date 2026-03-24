<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="lijn-geometrie-afstand-van-inmeetpunten" abstract="true">
     <rule context="//nlcs:MSkabel | //nlcs:LSkabel | //nlcs:Eaarddraad | //nlcs:Aaanlegtechniek | //nlcs:Amantelbuis">
          <let name="coords" value="ma:parse-line-alt(nlcs:Geometry)"/>

          <let name="geometries" value="ma:line-segments-not-meeting-length-demands-alt($coords)"/>

          <assert id="line-geometry-line-segments-meet-length-demand"
               test="empty($geometries)"
               properties="scope rule-number severity object-type object-id geometries">
               <value-of select="ma:get-translation('line-segment-measurement-incorrect')"/>
          </assert>
     </rule>

     <rule context="//nlcs:MSstation">
          <let name="coords" value="ma:parse-area-alt(nlcs:Geometry)"/>

          <let name="geometries" value="ma:line-segments-not-meeting-length-demands-alt($coords)"/>

          <assert id="area-geometry-line-segments-meet-length-demand"
               test="empty($geometries)"
               properties="scope rule-number severity object-type object-id geometries">
               <value-of select="ma:get-translation('line-segment-measurement-incorrect')"/>
          </assert>
     </rule>
</pattern>
