<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="geometrie-binnen-projectvlak" abstract="true">
    <!-- Point geometries -->
    <rule context="//nlcs:MSmof | //nlcs:MSoverdrachtspunt">
        <let name="point" 
            value="ma:parse-point(nlcs:Geometry)"/>
        
        <let name="project_area" 
            value="ma:parse-area(//nlcs:AprojectReferentie/nlcs:Geometry)"/>

        <assert id="assert-point-inside-project-area"
            test="ma:point-interacts-with-area($point, $project_area)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>

    <!-- Line geometries -->
    <rule context="//nlcs:MSkabel | //nlcs:Amantelbuis | //nlcs:Akunstwerk | //nlcs:Eaarddraad | //nlcs:Aaanlegtechniek">
        <let name="line" 
            value="ma:parse-line(nlcs:Geometry)"/>

        <let name="project_area" 
            value="ma:parse-area(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <assert id="assert-line-inside-project-area"
            test="ma:line-interacts-with-area($line, $project_area)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>

    <!-- Area geometries -->
    <rule context="//nlcs:MSstation | //nlcs:AbeschermingVlak">
        <let name="area"
            value="ma:parse-area(nlcs:Geometry)"/>

        <let name="project_area" 
            value="ma:parse-area(//nlcs:AprojectReferentie/nlcs:Geometry)"/>       

        <assert id="assert-area-interacts-with-project-area"
            test="ma:area-interacts-with-area($area, $project_area)"
            properties="scope rule-number severity object-type object-id">
            <value-of select="ma:get-translation('object-outside-project-area')"/>
        </assert>
    </rule>
</pattern>
