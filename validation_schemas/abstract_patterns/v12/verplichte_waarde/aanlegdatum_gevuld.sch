<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aanlegdatum-gevuld" abstract="true">
    <rule context="//nlcs:MSstation | //nlcs:MSkabel | //nlcs:MSmof | //nlcs:MSoverdrachtspunt">

        <let name="datum-aanleg-present"
            value="keronic:element-exists-and-not-empty(nlcs:DatumAanleg)"/>

        <assert id="date-exists"
            test="$datum-aanleg-present"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['DatumAanleg'])"/>
        </assert>

        <assert id="date-not-in-future"
            test="not($datum-aanleg-present) or (xs:date(nlcs:DatumAanleg) le current-date())"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('date-in-the-future')"/>
        </assert>
    </rule>
</pattern>
