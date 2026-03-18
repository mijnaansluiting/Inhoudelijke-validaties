<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aanwezigheid-bestand-bijlage-kunstwerk" abstract="true">
     <rule context="//nlcs:Akunstwerk">
          <let name="soort_kunstwerk"
               value="nlcs:SoortKunstwerk"/>
          
          <let name="id"
               value="nlcs:ID"/>
          
          <let name="bestand_bijlage"
               value="//nlcs:AbestandBijlage[nlcs:AssetObjectID = $id]"/>
          
          <let name="soort_bestand"
               value="$bestand_bijlage/nlcs:SoortBestand"/>
          
          <let name="should_be_tested"
               value="$soort_kunstwerk = ma:get-soortkunstwerken-with-required-abestandsbijlage()"/>
          
          <let name="bestand_bijlage_present"
               value="ma:element-exists-and-not-empty($bestand_bijlage)"/>
          
          <assert id="check-bestand-bijlage-present"
                  test="if($should_be_tested) then $bestand_bijlage_present else true()"
                  properties="scope rule-number severity object-type object-id">
               <value-of select="ma:get-translation-and-replace-placeholders('object-not-present', ['Abestandbijlage'])"/>
          </assert>
          
          <assert id="soort_bestand_correct"
                  properties="scope rule-number severity object-type object-id"
                  test="if($should_be_tested) then $soort_bestand = 'Zinkertekening' else true()">
          <value-of select="ma:get-translation-and-replace-placeholders('soort-bestand-not-correct', ['Zinkertekening', $soort_bestand])"/>
          </assert>
     </rule>
</pattern>
