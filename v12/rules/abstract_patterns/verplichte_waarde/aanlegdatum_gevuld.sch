<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aanlegdatum-gevuld" abstract="true">
    <rule context="//nlcs:MSstation | //nlcs:MSkabel | //nlcs:MSmof | //nlcs:MSoverdrachtspunt | //nlcs:LSkabel | //nlcs:LSmof | //nlcs:LSoverdrachtspunt | //nlcs:Eaardpen | //nlcs:Eaarddraad | //nlcs:OVLoverdrachtspunt">

        <let name="missing_attributes"
            value="ma:missing-attributes(., 'DatumAanleg')"/>

        <assert id="date-exists"
            test="empty($missing_attributes)"
            properties="scope rule-number severity object-type object-id missing-attributes">
            <value-of select="ma:missing-attributes-message($missing_attributes)"/>
        </assert>

        <assert id="date-not-in-future"
            test="exists($missing_attributes) or (xs:date(nlcs:DatumAanleg) le current-date())"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('date-in-the-future', ['DatumAanleg'])"/>
        </assert>
    </rule>
</pattern>
