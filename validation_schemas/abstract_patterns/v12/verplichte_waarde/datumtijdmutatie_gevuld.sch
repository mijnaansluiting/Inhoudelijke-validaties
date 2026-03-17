<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="datumtijdmutatie-gevuld" abstract="true">
    <rule context="/nlcs:NLCSnetbeheer/*[not(self::nlcs:AprojectReferentie or nlcs:Status = 'BESTAAND') or ma:element-exists-and-not-empty(nlcs:Bewerking)]">

        <let name="datum_tijd_mutatie_present"
            value="ma:element-exists-and-not-empty(nlcs:DatumTijdMutatie)"/>

        <assert id="date-exists"
            test="$datum_tijd_mutatie_present"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['DatumTijdMutatie'])"/>
        </assert>

        <assert id="date-not-in-future"
            test="if(datum_tijd_mutatie_present) then (xs:date(nlcs:DatumTijdMutatie) le current-date()) else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('date-in-the-future', ['DatumTijdMutatie'])"/>
        </assert>
    </rule>

    <rule context="/nlcs:NLCSnetbeheer/*[not(self::nlcs:AprojectReferentie) and nlcs:Status = 'BESTAAND']">

        <let name="datum_tijd_mutatie_present"
            value="ma:element-exists-and-not-empty(nlcs:DatumTijdMutatie)"/>

        <assert id="date-exists"
            test="not($datum_tijd_mutatie_present)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-present', ['DatumTijdMutatie'])"/>
        </assert>
    </rule>
</pattern>
