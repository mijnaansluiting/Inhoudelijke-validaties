<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="datumtijdmutatie-gevuld" abstract="true">
    <rule context="/nlcs:NLCSnetbeheer/*[not(self::nlcs:AprojectReferentie)]">
        <let name="datum_tijd_mutatie_present"
            value="ma:element-exists-and-not-empty(nlcs:DatumTijdMutatie)"/>

        <let name="datum_tijd_mutatie_expected"
            value="nlcs:Status ne 'BESTAAND' or ma:element-exists-and-not-empty(nlcs:Bewerking)"/>

        <assert id="date-time-present"
            test="if($datum_tijd_mutatie_expected) then $datum_tijd_mutatie_present else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['DatumTijdMutatie'])"/>
        </assert>

        <assert id="date-time-not-present"
            properties="scope rule-number severity object-type object-id"
            test="if(not($datum_tijd_mutatie_expected)) then not($datum_tijd_mutatie_present) else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-present', ['DatumTijdMutatie'])"/>            
        </assert>

        <assert id="date-time-not-in-future"
            test="not(xs:dateTime(nlcs:DatumTijdMutatie) gt current-dateTime())"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('date-in-the-future', ['DatumTijdMutatie'])"/>
        </assert>
    </rule>
</pattern>
