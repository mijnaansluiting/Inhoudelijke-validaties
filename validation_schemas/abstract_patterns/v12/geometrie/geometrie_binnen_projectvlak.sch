<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="geometrie-binnen-projectvlak" abstract="true">
    <!-- Point geometries -->
    <rule context="//nlcs:MSmof | //nlcs:MSoverdrachtspunt | //nlcs:LSmof | //nlcs:LSoverdrachtspunt | //nlcs:OVLoverdrachtspunt | //nlcs:Eaardpen">
        <let name="point" 
            value="ma:parse-point-alt(nlcs:Geometry)"/>
        
        <let name="project_area" 
            value="ma:parse-area-alt(//nlcs:AprojectReferentie/nlcs:Geometry)"/>

        <assert id="assert-point-inside-project-area"
            test="ma:point-interacts-with-area-alt($point, $project_area)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>

    <!-- Line geometries -->
    <rule context="//nlcs:MSkabel | //nlcs:Amantelbuis | //nlcs:Akunstwerk | //nlcs:Eaarddraad | //nlcs:Aaanlegtechniek | //nlcs:LSkabel">
        <let name="line" 
            value="ma:parse-line-alt(nlcs:Geometry)"/>

        <let name="project_area" 
            value="ma:parse-area-alt(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <assert id="assert-line-inside-project-area"
            test="ma:line-interacts-with-area-alt($line, $project_area)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>

    <!-- Area geometries -->
    <rule context="//nlcs:MSstation | //nlcs:AbeschermingVlak">
        <let name="area"
            value="ma:parse-area-alt(nlcs:Geometry)"/>

        <let name="project_area" 
            value="ma:parse-area-alt(//nlcs:AprojectReferentie/nlcs:Geometry)"/>       

        <assert id="assert-area-interacts-with-project-area"
            test="ma:area-interacts-with-area-alt($area, $project_area)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>
</pattern>
