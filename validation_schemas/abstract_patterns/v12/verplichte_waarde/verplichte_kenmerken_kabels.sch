<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-kabels" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:HSkabel | nlcs:LSkabel">
        <let name="uitvoering"
            value="nlcs:Uitvoering"/>

        <assert id="kabel-has-uitvoering"
            test="ma:element-exists-and-not-empty($uitvoering)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Uitvoering'])"/>
        </assert>

        <assert id="kabel-uitvoering-keuze-ontbreekt-uit-lijst-has-omschrijving-uitvoering"
            test="not($uitvoering = 'KEUZE ONTBREEKT IN LIJST') or ma:element-exists-and-not-empty(nlcs:OmschrijvingUitvoering)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['OmschrijvingUitvoering'])"/>
        </assert>

        <assert id="kabel-has-kabelopbouw"
            test="ma:element-exists-and-not-empty(nlcs:Kabelopbouw)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Kabelopbouw'])"/>
        </assert>

        <assert id="kabel-has-fabrikant"
            test="ma:element-exists-and-not-empty(nlcs:Fabrikant)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Fabrikant'])"/>
        </assert>

        <assert id="kabel-has-verbindingnummer"
            test="ma:element-exists-and-not-empty(nlcs:Verbindingnummer)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Verbindingnummer'])"/>
        </assert>

        <assert id="kabel-has-spanningsniveau"
            test="ma:element-exists-and-not-empty(nlcs:Spanningsniveau)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Spanningsniveau'])"/>
        </assert>

        <assert id="kabel-has-fase-aanduiding"
            test="ma:element-exists-and-not-empty(nlcs:FaseAanduiding)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['FaseAanduiding'])"/>
        </assert>
    </rule>
</pattern>
