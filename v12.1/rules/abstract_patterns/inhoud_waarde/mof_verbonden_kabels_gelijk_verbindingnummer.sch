<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="mof-verbonden-kabels-gelijk-verbindingnummer" abstract="true">
    <rule context="//nlcs:LSmof">
        <let name="lsmof"
            value="."/>

        <let name="connected_lskabels"
            value="ma:touching-kabels($lsmof)[self::nlcs:LSkabel]"/>
        
        <let name="cables_with_different_verbindingnummer"
            value="$connected_lskabels[nlcs:Verbindingnummer ne $lsmof/nlcs:Verbindingnummer]"/>

        <assert id="kabels-have-same-verbindingnummer"
                properties="scope rule-number severity object-type object-id"
            test="empty($cables_with_different_verbindingnummer)">
            <value-of select="ma:get-translation-and-replace-placeholders('connected-cables-have-different-verbindingnummer', [$lsmof/nlcs:Verbindingnummer])"/>
        </assert>
    </rule>

        <rule context="//nlcs:MSmof">
        <let name="msmof"
            value="."/>

        <let name="connected_mskabels"
            value="ma:touching-kabels($msmof)[self::nlcs:MSkabel]"/>
        
        <let name="cables_with_different_verbindingnummer"
            value="$connected_mskabels[nlcs:Verbindingnummer ne $msmof/nlcs:Verbindingnummer]"/>

        <assert id="kabels-have-same-verbindingnummer"
                properties="scope rule-number severity object-type object-id"
            test="empty($cables_with_different_verbindingnummer)">
            <value-of select="ma:get-translation-and-replace-placeholders('connected-cables-have-different-verbindingnummer', [$msmof/nlcs:Verbindingnummer])"/>
        </assert>
    </rule>
</pattern>
