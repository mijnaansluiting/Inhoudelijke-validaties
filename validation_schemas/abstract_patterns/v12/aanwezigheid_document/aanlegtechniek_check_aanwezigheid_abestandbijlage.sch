<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="abestandbijlage_aanwezig" abstract="true">
     <rule context="//nlcs:Aaanlegtechniek[nlcs:SoortAanlegTechniek = 'GESTUURDE TECHNIEK']">

    <let name="id"
        value="nlcs:ID"/>>
          
     <let name="abestandbijlage"
               value="//nlcs:Abestandbijlage[nlcs:AssetObjectID = $id]"/>
          
          <assert id="abeestandbijlage_must_be_gestuurdeboring"
                  properties="scope rule-number severity object-type object-id"
                  test="$abestandbijlage/nlcs:SoortBestand = 'Gestuurde boring'">
               <value-of select="ma:get-translation-and-replace-placeholders()"/> <!--Will replace this if R.31 is through and use the same message-->
          </assert>
     </rule>
</pattern>
