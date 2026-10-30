<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-mantelbuis" abstract="true">
    <rule context="//nlcs:Amantelbuis">
        <let name="missing_attributes"
            value="ma:missing-attributes(., (
                'Thema',
                'Materiaal',
                'Diameter'))"/>

        <assert id="mantelbuis-has-required-attributes"
            test="empty($missing_attributes)"
            properties="scope rule-number severity object-type object-id missing-attributes">
            <value-of select="ma:missing-attributes-message($missing_attributes)"/>
        </assert>
    </rule>
</pattern>
