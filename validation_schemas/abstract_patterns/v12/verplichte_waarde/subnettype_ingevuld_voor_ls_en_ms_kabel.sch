<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="subnettype-ingevuld-voor-ls-en-ms-kabel" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:LSkabel | nlcs:LSmof">
        <assert id="subnettype-present"
            test="keronic:element-exists-and-not-empty(nlcs:Subnettype)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Subnettype'])"/>
        </assert>
    </rule>
</pattern>
