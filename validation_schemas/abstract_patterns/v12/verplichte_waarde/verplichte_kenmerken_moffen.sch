<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-moffen" abstract="true">
    <rule context="//nlcs:MSmof | //nlcs:HSmof">
        <assert id="functie_present"
            test="keronic:element-exists-and-not-empty(nlcs:Functie)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Functie'])"/>
        </assert>

        <assert id="verbindingnummer_present"
            test="keronic:element-exists-and-not-empty(nlcs:Verbindingnummer)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Verbindingnummer'])"/>
        </assert>

        <assert id="naam_monteur_present"
            test="keronic:element-exists-and-not-empty(nlcs:NaamMonteur)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['NaamMonteur'])"/>
        </assert>

        <assert id="cross_bounding_present"
            test="keronic:element-exists-and-not-empty(nlcs:CrossBondingAanwezig)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['CrossBondingAanwezig'])"/>
        </assert>
    </rule>
    <rule context="//nlcs:LSmof">
        <assert id="functie_present"
            test="keronic:element-exists-and-not-empty(nlcs:Functie)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Functie'])"/>
        </assert>

        <assert id="verbindingnummer_present"
            test="keronic:element-exists-and-not-empty(nlcs:Verbindingnummer)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Verbindingnummer'])"/>
        </assert>

        <assert id="bovengronds_present"
            test="keronic:element-exists-and-not-empty(nlcs:Bovengronds)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Bovengronds'])"/>
        </assert>
    </rule>
</pattern>
