<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="fase-ms-kabel" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="fase"
            value="nlcs:FaseAanduiding"/>

        <let name="uitvoering"
            value="nlcs:Uitvoering"/>

        <let name="expected_uitvoering_prefix"
            value="if ($fase = '3 Fasen') then '3x'
                else if ($fase = 'L1' or $fase = 'L2' or $fase = 'L3') then '1x'
                else ''"/>

        <let name="uitvoering_omschrijving"
            value="nlcs:OmschrijvingUitvoering"/>

        <assert id="fase-and-uitvoering-same"
                properties="scope rule-number severity object-type object-id"
            test="starts-with(if($uitvoering != 'KEUZE ONTBREEKT IN LIJST') then $uitvoering else $uitvoering_omschrijving, $expected_uitvoering_prefix)">
            <value-of select="keronic:get-translation('fase-not-the-same-as-uitvoering')"/>
        </assert>
    </rule>
</pattern>
