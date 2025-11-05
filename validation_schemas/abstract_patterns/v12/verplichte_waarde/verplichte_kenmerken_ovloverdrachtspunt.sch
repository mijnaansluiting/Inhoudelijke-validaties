<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-ovloverdrachtspunt" abstract="true">
    <rule context="//nlcs:OVLoverdrachtspunt">
        <assert id="aansluitset-present"
            test="keronic:element-exists-and-not-empty(nlcs:Aansluitset)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Aansluitset'])"/>
        </assert>

        <assert id="functie-present"
            test="keronic:element-exists-and-not-empty(nlcs:Functie)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Functie'])"/>
        </assert>

        <assert id="spanningsniveau-present"
            test="keronic:element-exists-and-not-empty(nlcs:Spanningsniveau)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Spanningsniveau'])"/>
        </assert>

        <assert id="aansluitwijze-present"
            test="keronic:element-exists-and-not-empty(nlcs:Aansluitwijze)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Aansluitwijze'])"/>
        </assert>

        <assert id="schakeling-present"
            test="keronic:element-exists-and-not-empty(nlcs:Schakeling)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Schakeling'])"/>
        </assert>

        <assert id="mastnummer-present"
            test="keronic:element-exists-and-not-empty(nlcs:Mastnummer)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Mastnummer'])"/>
        </assert>
    </rule>
</pattern>
