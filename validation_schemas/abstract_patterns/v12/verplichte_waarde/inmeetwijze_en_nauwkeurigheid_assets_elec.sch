<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="inmeetwijze-en-nauwkeurigheid-assets-elec" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:Amantelbuis | //nlcs:LSkabel | //nlcs:Eaarddraad">
        <assert id="elec-object-has-inmeetwijze"
            test="ma:element-exists-and-not-empty(nlcs:Inmeetwijze)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Inmeetwijze'])"/>
        </assert>

        <assert id="elec-object-has-nauwkeurigheid"
            test="ma:element-exists-and-not-empty(nlcs:Nauwkeurigheid)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Nauwkeurigheid'])"/>
        </assert>
    </rule>
</pattern>
