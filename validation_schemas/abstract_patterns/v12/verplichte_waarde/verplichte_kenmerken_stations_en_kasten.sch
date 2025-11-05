<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-stations-en-kasten" abstract="true">
    <rule context="//nlcs:LSkast | //nlcs:MSstation | //nlcs:HSstation">
        <assert id="object-has-functie"
            test="keronic:element-exists-and-not-empty(nlcs:Functie)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Functie'])"/>
        </assert>

        <assert id="object-has-number"
            test="keronic:element-exists-and-not-empty(nlcs:Nummer)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Nummer'])"/>
        </assert>
    </rule>
</pattern>
