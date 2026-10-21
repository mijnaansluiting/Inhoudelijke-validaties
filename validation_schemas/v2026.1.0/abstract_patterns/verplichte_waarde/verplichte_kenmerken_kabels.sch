<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-kabels" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:HSkabel | nlcs:LSkabel">
        <let name="uitvoering_keuze_ontbreekt"
            value="nlcs:Uitvoering = 'KEUZE ONTBREEKT IN LIJST'"/>

        <let name="missing_attributes"
            value="ma:missing-attributes(., (
                'Uitvoering',
                if ($uitvoering_keuze_ontbreekt) then 'OmschrijvingUitvoering' else (),
                'Kabelopbouw',
                'Fabrikant',
                'Verbindingnummer',
                'Spanningsniveau',
                'FaseAanduiding'))"/>

        <assert id="kabel-has-required-attributes"
            test="empty($missing_attributes)"
            properties="scope rule-number severity object-type object-id missing-attributes">
            <value-of select="ma:missing-attributes-message($missing_attributes)"/>
        </assert>
    </rule>
</pattern>
