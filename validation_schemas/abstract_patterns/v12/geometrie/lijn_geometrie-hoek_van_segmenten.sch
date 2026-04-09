<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="lijn-geometrie-hoek-van-segmenten" abstract="true">
     <rule context="//nlcs:MSkabel | //nlcs:Eaarddraad | //nlcs:LSkabel | //nlcs:Aaanlegtechniek | //nlcs:Amantelbuis">
          <let name="coords" value="ma:parse-line(nlcs:Geometry)"/>
          
          <let name="geometries" value="ma:line-segments-not-meeting-angle-demands($coords)"/>

          <assert id="line-geometry-line-segments-meet-angle-demand"
               test="empty($geometries)"
               properties="scope rule-number severity object-type object-id geometries">
               <value-of select="ma:get-translation('line-angle-larger-than-45')"/>
          </assert>
     </rule>
</pattern>
