<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-mantelbuis" abstract="true">
    <rule context="//nlcs:Amantelbuis">
        <assert id="mantelbuis-has-thema"
            test="keronic:element-exists-and-not-empty(nlcs:Thema)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Thema'])"/>
        </assert>

        <assert id="mantelbuis-has-materiaal"
            test="keronic:element-exists-and-not-empty(nlcs:Materiaal)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Materiaal'])"/>
        </assert>

        <assert id="mantelbuis-has-diameter"
            test="keronic:element-exists-and-not-empty(nlcs:Diameter)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('attribute-not-present', ['Diameter'])"/>
        </assert>
    </rule>
</pattern>
