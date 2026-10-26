<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="inmeetwijze-en-nauwkeurigheid-assets-elec" abstract="true">
    <rule context="//nlcs:MSkabel | //nlcs:Amantelbuis | //nlcs:LSkabel | //nlcs:Eaarddraad">
        <let name="missing_attributes"
            value="ma:missing-attributes(., (
                'Inmeetwijze',
                'Nauwkeurigheid'))"/>

        <assert id="elec-object-has-required-attributes"
            test="empty($missing_attributes)"
            properties="scope rule-number severity object-type object-id missing-attributes">
            <value-of select="ma:missing-attributes-message($missing_attributes)"/>
        </assert>
    </rule>
</pattern>
