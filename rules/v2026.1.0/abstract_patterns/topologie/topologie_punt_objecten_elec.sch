<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="topologie-punt-objecten-elec" abstract="true">
    <rule context="//nlcs:MSmof | //nlcs:MSoverdrachtspunt">
        <let name="point_connected"
            value="exists(ma:touching-kabels(.)[self::nlcs:MSkabel])"/>

        <assert id="point-connected-to-kabel"
            test="$point_connected"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('point-not-connected-to-any-line')"/>
        </assert>
    </rule>
    
    <rule context="//nlcs:LSmof | //nlcs:LSoverdrachtspunt | //nlcs:Eaardmof | //nlcs:OVLoverdrachtspunt">
        <let name="point_connected"
            value="exists(ma:touching-kabels(.)[self::nlcs:LSkabel])"/>

        <assert id="point-connected-to-kabel"
            test="$point_connected"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('point-not-connected-to-any-line')"/>
        </assert>
    </rule>
</pattern>