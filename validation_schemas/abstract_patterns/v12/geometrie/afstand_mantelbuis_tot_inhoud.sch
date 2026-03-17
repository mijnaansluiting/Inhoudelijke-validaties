<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="afstand-mantelbuis-tot-inhoud" abstract="true">
    <rule context="//nlcs:Amantelbuis">
        <let name="id"
            value="nlcs:ID"/>

        <let name="mantelbuis_inhoud_ids"
            value="//nlcs:AmantelbuisInhoud[nlcs:MantelbuisID = $id]/nlcs:InhoudID"/>

        <let name="inhoud_objects"
            value="//nlcs:NLCSnetbeheer/*[nlcs:ID = $mantelbuis_inhoud_ids]"/>

        <let name="mantelbuis_geometry"
            value="ma:parse-line(nlcs:Geometry)"/>

        <let name="max_distance"
            value="ma:mantelbuis-inhoud-asset-max-distance()"/>

        <let name="inhoud_objects_too_far_removed"
            value="$inhoud_objects[not(ma:line-within-range-of-mantelbuis(ma:parse-line(nlcs:Geometry), $mantelbuis_geometry, $max_distance))]"/>

        <let name="geometries"
            value="$inhoud_objects_too_far_removed/nlcs:Geometry"/>

        <assert id="inhoud-not-too-far-from-mantelbuis"
            properties="scope rule-number severity object-type object-id geometries"
            test="empty($inhoud_objects_too_far_removed)">
            <value-of select="count($inhoud_objects_too_far_removed)"/> inhoudsassets liggen te ver van de mantelbuis vandaan.
        </assert>
    </rule>
</pattern>
