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

        <let name="geometries"
            value="$inhoud_objects/nlcs:Geometry[not(ma:mantelbuis-entry-check($line, ma:parse-line(.), 20))]"/>

        <assert id="inhoud-enters-and-leaves-mantelbuis"
            properties="scope rule-number severity object-type object-id geometries"
            test="empty($geometries)">
            1 of meer inhoudobjecten gaan de mantelbuis niet in of uit.
        </assert>

        <assert id="inhoud-not-too-far-from-mantelbuis"
            properties="scope rule-number severity object-type object-id geometries"
            test="false()">
            WAAAh
        </assert>
        


        <!-- 
            (Snijdt de kabellijn de orthogonaal van het start- of eindpunt van de mantelbuis *niet*, faal dan direct)
            Bereken voor elk inhoudsegment de inhoud bounding box (IBB), verleng/verkort deze om aan te sluiten op het volgende inhoudsegment.
            Filter de IBBs op interactie met de mantelbuislijn.
            Voor elke overgebleven IBB:
                Filter de mantelbuissegmenten die interactie hebben met de IBB.
                Minimaal 1 van de overgebleven mantelbuissegmenten mag de linker en rechterzijde van de IBB *niet* raken.
        -->

        <!-- 
        <assert id="mantelbuis-inhoud-within-range"
            properties="scope rule-number severity object-type object-id"
            test="$all_inhoud_objects_within_range">
            Mantelbuisinhoud ligt te ver van mantelbuis vandaan.
        </assert>
        <let name="a_left"
            value="ma:parse-line(//nlcs:MSkabel[nlcs:ID = 'A-LEFT']/nlcs:Geometry)"/>

        <let name="a_right"
            value="ma:parse-line(//nlcs:MSkabel[nlcs:ID = 'A-RIGHT']/nlcs:Geometry)"/>

        <let name="b_left"
            value="ma:parse-line(//nlcs:MSkabel[nlcs:ID = 'B-LEFT']/nlcs:Geometry)"/>

        <let name="b_right"
            value="ma:parse-line(//nlcs:MSkabel[nlcs:ID = 'B-RIGHT']/nlcs:Geometry)"/>

        <assert id="mantelbuis-related-asset-too-far-away"
            test="false()"
            properties="scope rule-number severity object-type object-id">
         -->
            <!-- 
            Passing within 100: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Passing']/nlcs:Geometry), 100)"/>
            Failing within 100: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Failing']/nlcs:Geometry), 100)"/>
            Circle: <value-of select="ma:approximate-circle((569.7056274847714, 440), 260, 50)"/>
             -->
             <!-- 
            LEFT:<value-of select="ma:intersection-of-segments($a_left, $b_left)"/>
            RIGHT:<value-of select="ma:intersection-of-segments($a_right, $b_right)"/>

            Passing within 120: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Passing']/nlcs:Geometry), 120)"/>
            Passing edge case within 120: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Passing-Edge-Case']/nlcs:Geometry), 120)"/>
            Failing within 120: <value-of select="ma:line-within-range-of-line($line, ma:parse-line($inhoud_objects[nlcs:ID = 'Failing']/nlcs:Geometry), 120)"/>
            Test: <value-of select="$all_inhoud_objects_within_range"/>
        </assert>
        -->
    </rule>
</pattern>
