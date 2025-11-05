<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="inmeetwijze-en-nauwkeurigheid-assets-elec" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:Amantelbuis">
        <assert id="elec-object-has-inmeetwijze"
            test="keronic:element-exists-and-not-empty(nlcs:Inmeetwijze)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Inmeetwijze'])"/>
        </assert>

        <assert id="elec-object-has-nauwkeurigheid"
            test="keronic:element-exists-and-not-empty(nlcs:Nauwkeurigheid)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Nauwkeurigheid'])"/>
        </assert>
    </rule>
</pattern>
