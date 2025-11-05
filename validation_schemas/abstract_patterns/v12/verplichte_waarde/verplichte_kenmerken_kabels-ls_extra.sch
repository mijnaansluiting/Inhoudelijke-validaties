<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-kabels-ls-extra" abstract="true">
    <rule context="//nlcs:LSkabel">
        <assert id="kabel-has-aardingsysteem"
            test="keronic:element-exists-and-not-empty(nlcs:Aardingsysteem)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Aardingsysteem'])"/>
        </assert>

        <assert id="lskabel-has-bovengronds"
            test="keronic:element-exists-and-not-empty(nlcs:Bovengronds)">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Bovengronds'])"/>
        </assert>

        <assert id="lskabel-has-functie"
            test="keronic:element-exists-and-not-empty(nlcs:Functie)">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Functie'])"/>
        </assert>
    </rule>
</pattern>
