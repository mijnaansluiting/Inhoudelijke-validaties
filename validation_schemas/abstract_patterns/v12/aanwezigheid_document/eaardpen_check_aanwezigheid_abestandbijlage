<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="eaardpen-check-aanwezigheid-abestandbijlage" abstract="true">
    <rule context="//nlcs:Eaardpen[nlcs:Status = 'NIEUW' and nlcs:BedrijfsToestand = 'IN BEDRIJF']">
        <let name="id"
             value="nlcs:ID"/>
        
        <let name="bestandbijlage"
             value="//nlcs:ABestandBijlage[nlcs:AssetObjectID = $id]"/>
        
        <let name ="bestandbijlage_type"
             value="$bestandbijlage/nlcs:SoortBestand"/>
          
          <assert id="check-correct-bestandsoort"
               test="$bestandbijlage_type = 'Aardingsrapport'"
               properties="scope rule-number severity object-type object-id">
               <value-of select="ma:get-translation-and-replace-placeholders('soort-bestand-not-correct', ['Aardingsrapport'])"/>
          </assert>
    </rule>
</pattern>
