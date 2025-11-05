<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-lsoverdrachtspunt" abstract="true">
    <rule context="//nlcs:LSoverdrachtspunt">
        <assert id="functie-present"
            test="keronic:element-exists-and-not-empty(nlcs:Functie)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Functie'])"/>
        </assert>

        <assert id="eigen-richting-present"
            test="keronic:element-exists-and-not-empty(nlcs:EigenRichting)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['EigenRichting'])"/>
        </assert>

        <assert id="fase-aanduiding-present"
            test="keronic:element-exists-and-not-empty(nlcs:FaseAanduiding)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['FaseAanduiding'])"/>
        </assert>

        <assert id="aardingsysteem-present"
            test="keronic:element-exists-and-not-empty(nlcs:Aardingsysteem)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Aardingsysteem'])"/>
        </assert>
    </rule>
</pattern>
