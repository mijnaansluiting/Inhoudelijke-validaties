<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aanwezigheid-bestand-bijlage-akunstwerk" abstract="true">
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
             value="some $soortkunstwerk_to_test in ma:get-soortkunstwerken-with-required-abestandsbijlage() satisfies
                    $soortkunstwerk_to_test = $soort_kunstwerk"/>
        
        <assert id="soort_bestand_correct"
                properties="scope rule-number severity object-type object-id"
                test="if($should_be_tested) then $soort_bestand = 'Zinkertekening' else true()"></assert>
            <value-of select="ma:get-translation-and-replace-placeholders()"/> <!--Will replace this if R.31 is through and use the same message-->
    </rule>
</pattern>
