<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="aanwezigheid-maaiveldhoogte" abstract="true">
    <rule context="//nlcs:NLCSnetbeheer">
        <let name="amaaiveldhoogtes"
            value="nlcs:Amaaiveldhoogte"/>

        <let name="revisie_tekeningtypes"
            value="('DEELREVISIE', 'EINDREVISIE')"/>

        <let name="is_revisie"
            value="nlcs:AprojectReferentie/nlcs:Tekeningtype = $revisie_tekeningtypes"/>

        <assert id="revisie-has-maaiveldhoogte"
            test="if($is_revisie) then count($amaaiveldhoogtes) > 0 else true()"
            properties="rule-number severity">
            <value-of select="ma:get-translation-and-replace-placeholders('revisie-no-maaiveldhoogte-present', [string-join($revisie_tekeningtypes, ', ')])"/>
        </assert>

        <assert id=""
            properties="scope rule-number severity"
            test="">
            
        </assert>
    </rule>
</pattern>
