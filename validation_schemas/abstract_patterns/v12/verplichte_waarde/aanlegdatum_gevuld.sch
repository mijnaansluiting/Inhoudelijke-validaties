<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aanlegdatum-gevuld" abstract="true">
    <rule context="//nlcs:MSstation | //nlcs:MSkabel | //nlcs:MSmof | //nlcs:MSoverdrachtspunt | //nlcs:LSkabel | //nlcs:LSmof | //nlcs:LSoverdrachtspunt | //nlcs:Eaardpen | //nlcs:Eaarddraad | //nlcs:OVLoverdrachtspunt">

        <let name="datum-aanleg-present"
            value="ma:element-exists-and-not-empty(nlcs:DatumAanleg)"/>

        <assert id="date-exists"
            test="$datum-aanleg-present"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['DatumAanleg'])"/>
        </assert>

        <assert id="date-not-in-future"
            test="not($datum-aanleg-present) or (xs:date(nlcs:DatumAanleg) le current-date())"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('date-in-the-future', ['DatumAanleg'])"/>
        </assert>
    </rule>
</pattern>
