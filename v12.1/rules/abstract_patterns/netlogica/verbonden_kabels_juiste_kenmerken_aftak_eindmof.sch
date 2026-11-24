<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="verbonden-kabels-juiste-kenmerken" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="mskabel"
            value="."/>

        <let name="connected_msmoffen"
            value="ma:touching-moffen($mskabel)[self::nlcs:MSmof]"/>

        <let name="connected_mskabels"
            value="ma:touching-kabels-via-moffen($connected_msmoffen, 'MSkabel')[. ne $mskabel]"/>

        <let name="overlap_point"
            value="$overlapping_moffen/nlcs:Geometry"/>

        <assert id="subnettype_correct"
            test="every $connected_mof in $connected_msmoffen satisfies if ($connected_mof/nlcs:Functie = 'AANSLUIT AFTAK') then $connected_mof/nlcs:Subnettype = 'AANSLUITNET' else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
        </assert>

        <assert id="every_cable_is_distribution"
            test="every $connected_kabel in $connected_mskabels satisfies $connected_kabel/nlcs:Subnettype = 'DISTRIBUTIE'"
            properties="scope rule-number severity object-type object-id overlap-point">
        </assert>

    </rule>

    <rule context="//nlcs:LSkabel">
        <let name="lskabel"
            value="."/>

        <let name="connected_lsmoffen"
            value="ma:touching-moffen($lskabel)[self::nlcs:LSmof]"/>

        <let name="connected_lskabels"
            value="ma:touching-kabels-via-moffen($connected_lsmoffen, 'LSkabel')[. ne $lskabel]"/>

        <let name="overlap_point"
            value="$overlapping_moffen/nlcs:Geometry"/>

        <assert id="subnettype_correct"
            test="every $connected_mof in $connected_lsmoffen satisfies if ($connected_mof/nlcs:Functie = 'AANSLUIT AFTAK') then $connected_mof/nlcs:Subnettype = 'AANSLUITNET' else true()"
            properties="scope rule-number severity object-type object-id overlap-point">
        </assert>

        <assert id="every_cable_is_distribution"
            test="every $connected_kabel in $connected_lskabels satisfies $connected_kabel/nlcs:Subnettype = 'DISTRIBUTIE'"
            properties="scope rule-number severity object-type object-id overlap-point">
        </assert>
    </rule>
</pattern>
