<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="reden-niet-verwijderd-ingebuld" abstract="true">
    <rule context="//nlcs:MSkabel[nlcs:Status = 'REVISIE' and nlcs:BedrijfsToestand = 'VERLATEN'] | //nlcs:LSkabel[nlcs:Status = 'REVISIE' and nlcs:BedrijfsToestand = 'VERLATEN']">
        <assert id="reden-niet-verwijderd-present"
                test="ma:element-exists-and-not-empty(nlcs:RedenNietVerwijderd)"
                properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['RedenNietVerwijderd'])"/>
        </assert>
    </rule>
</pattern>
