<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aanwezigheid-bestand-bijlage-aardpen" abstract="true">
    <rule context="//nlcs:Eaardpen">
        <let name="id"
             value="nlcs:ID"/>
        
        <let name="bestand_bijlage"
             value="//nlcs:AbestandBijlage[nlcs:AssetObjectID = $id]"/>
        
        <let name="bestandbijlage_type"
             value="$bestand_bijlage/nlcs:SoortBestand"/>
          
          <let name="bestandbijlage_present"
             value="ma:element-exists-and-not-empty($bestand_bijlage)"/>
          
          <assert id="check-bestandbijlage-present"
                  test="$bestandbijlage_present"
                  properties="scope rule-number severity object-type object-id">
               <value-of select="ma:get-translation-and-replace-placeholders('object-not-present', ['Abestandbijlage'])"/>
          </assert>
          
          <assert id="check-correct-bestandsoort"
               test="not($bestandbijlage_present) or $bestandbijlage_type = 'Aardingsrapport'"
               properties="scope rule-number severity object-type object-id">
               <value-of select="ma:get-translation-and-replace-placeholders('soort-bestand-not-correct', ['Aardingsrapport', $bestandbijlage_type])"/>
          </assert>
    </rule>
</pattern>
