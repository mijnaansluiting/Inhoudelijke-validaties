<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="afstand-mantelbuis-tot-inhoud" abstract="true">
    <rule context="//nlcs:Amantelbuis">
        <let name="id"
            value="nlcs:ID"/>

        <let name="mantelbuis_inhoud_ids"
            value="//nlcs:AmantelbuisInhoud[nlcs:MantelbuisID = $id]/nlcs:InhoudID"/>

        <let name="inhoud_objects"
            value="//nlcs:NLCSnetbeheer/*[nlcs:ID = $mantelbuis_inhoud_ids]"/>

        <let name="line"
            value="ma:parse-line(nlcs:Geometry)"/>

        <let name="all_inhoud_objects_within_range"
            value="
                every $line_geometry in $inhoud_objects/nlcs:Geometry
                satisfies ma:line-within-range-of-line($line, ma:parse-line($line_geometry), 100)
            "/>

        <assert id="mantelbuis-related-asset-too-far-away"
            test="false()"
            properties="scope rule-number severity object-type object-id">
            <!-- 
            Passing within 100: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Passing']/nlcs:Geometry), 100)"/>
            Failing within 100: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Failing']/nlcs:Geometry), 100)"/>
             -->
            Circle: <value-of select="ma:approximate-circle((520, 560), 120, 32)"/>
            Passing within 120: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Passing']/nlcs:Geometry), 120)"/>
            Failing within 120: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Failing']/nlcs:Geometry), 120)"/>
            Test: <value-of select="$all_inhoud_objects_within_range"/>
        </assert>
    </rule>
</pattern>
