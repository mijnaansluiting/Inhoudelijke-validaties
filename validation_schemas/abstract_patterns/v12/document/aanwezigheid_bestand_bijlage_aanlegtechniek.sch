<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="aanwezigheid-bestand-bijlage-aanlegtechniek" abstract="true">
     <rule context="//nlcs:Aaanlegtechniek[nlcs:SoortAanlegTechniek = 'GESTUURDE TECHNIEK']">
          
          <let name="id"
               value="nlcs:ID"/>
          
          <let name="bestand_bijlage"
               value="//nlcs:AbestandBijlage[nlcs:AssetObjectID = $id]"/>
          
          <let name="bestand_bijlage_present"
               value="ma:element-exists-and-not-empty($bestand_bijlage)"/>
          
          <let name="bestand_bijlage_type"
               value="$bestand_bijlage/nlcs:SoortBestand"/>
          
          <assert id="check-bestand-bijlage-present"
                  test="$bestand_bijlage_present"
                  properties="scope rule-number severity object-type object-id">
               <value-of select="ma:get-translation-and-replace-placeholders('object-not-present', ['Abestandbijlage'])"/>
          </assert>
          
          <assert id="bestandbijlage-must-be-gestuurde-boring"
                  properties="scope rule-number severity object-type object-id"
                  test="$bestand_bijlage_type = 'Gestuurde boring'">
               <value-of select="ma:get-translation-and-replace-placeholders('soort-bestand-not-correct', ['Gestuurde boring', $bestand_bijlage_type])"/>
          </assert>
     </rule>
</pattern>
