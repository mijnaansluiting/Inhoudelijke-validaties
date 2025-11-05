<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="mantelbuis-inhoud-referenties" abstract="true">
    <rule context="//nlcs:AmantelbuisInhoud">
        <let name="mantelbuis_id"
            value="nlcs:MantelbuisID"/>

        <let name="inhoud_id"
            value="nlcs:InhoudID"/>

        <assert id="mantelbuis-inhoud-is-not-self"
            properties="scope rule-number severity object-type object-id"
            test="$mantelbuis_id ne $inhoud_id">
            <value-of select="keronic:get-translation('mantelbuis-inhoud-is-self')"/>
        </assert>

        <let name="mantelbuis"
            value="//nlcs:Amantelbuis[nlcs:ID = $mantelbuis_id]"/>

        <assert id="mantelbuis-id-refers-to-mantelbuis"
            properties="scope rule-number severity object-type object-id"
            test="$mantelbuis">
            <value-of select="keronic:get-translation-and-replace-placeholders('mantelbuis-id-does-not-refer-to-mantelbuis', [$mantelbuis_id])"/>
        </assert>

        <let name="inhoud"
            value="//nlcs:NLCSnetbeheer/*[nlcs:ID = $inhoud_id]"/>

        <let name="inhoud_type"
            value="name($inhoud)"/>

        <let name="expected_inhoud_type"
            value="nlcs:ObjectTypeInhoud"/>

        <assert id="object-type-inhoud-matches-inhoud"
            properties="scope rule-number severity object-type object-id"
            test="$expected_inhoud_type = $inhoud_type">
            <value-of select="keronic:get-translation-and-replace-placeholders('object-type-inhoud-does-not-match-inhoud', [$expected_inhoud_type, $inhoud_type])"/>
        </assert>
    </rule>
</pattern>
