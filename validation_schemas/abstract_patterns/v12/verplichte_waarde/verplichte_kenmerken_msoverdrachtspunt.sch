<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verplichte-kenmerken-msoverdrachtspunt" abstract="true">
    <rule context="//nlcs:MSoverdrachtspunt">
        <assert id="v12-msoverdrachtspunt-has-identification"
            test="ma:element-exists-and-not-empty(nlcs:Identificatie)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation-and-replace-placeholders('attribute-not-present', ['Identificatie'])"/>
        </assert>
    </rule>
</pattern>
