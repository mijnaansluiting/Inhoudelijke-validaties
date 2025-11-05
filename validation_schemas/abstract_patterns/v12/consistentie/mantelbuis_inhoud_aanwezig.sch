<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="mantelbuis-inhoud-aanwezig" abstract="true">
    <rule context="//nlcs:Amantelbuis">
        <let name="id"
            value="nlcs:ID"/>

        <let name="mantelbuisinhoud"
            value="//nlcs:AmantelbuisInhoud[nlcs:MantelbuisID = $id]"/>

        <let name="bedrijfstoestand"
            value="nlcs:Bedrijfstoestand"/>

        <assert id="inhoud_exists_when_in_bedrijf"
            test="if ($bedrijfstoestand = 'IN BEDRIJF') then $mantelbuisinhoud else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('inhoud-not-found')"/>
        </assert>

        <assert id="inhoud_does_not_exist_when_reserve"
            test="if ($bedrijfstoestand = 'RESERVE') then not($mantelbuisinhoud) else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation('inhoud-found')"/>
        </assert>
    </rule>
</pattern>
