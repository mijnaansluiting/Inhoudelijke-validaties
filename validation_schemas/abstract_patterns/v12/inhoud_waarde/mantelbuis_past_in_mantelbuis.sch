<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="mantelbuis-past-in-mantelbuis" abstract="true">
    <rule context="//nlcs:Amantelbuis">
        <let name="id"
            value="nlcs:ID"/>

        <let name="parent_mantelbuis_inhouden"
            value="//nlcs:AmantelbuisInhoud[nlcs:InhoudID = $id]"/>

        <let name="parent_mantelbuizen"
            value="//nlcs:Amantelbuis[nlcs:ID = $parent_mantelbuis_inhouden/nlcs:MantelbuisID]"/>

        <let name="inner_diameter"
            value="nlcs:Diameter"/>

        <let name="outer_diameters"
            value="$parent_mantelbuizen/nlcs:Diameter[. ne 'KEUZE ONTBREEKT IN LIJST']"/>

        <let name="inner_diameter_fits_all_outer_diameters"
            value="every $outer_diameter in $outer_diameters satisfies number($outer_diameter) > number($inner_diameter)"/>

        <assert id="mantelbuis-inside-mantelbuis-has-smaller-diameter"
            properties="scope rule-number severity object-type object-id"
            test="if($inner_diameter ne 'KEUZE ONTBREEKT IN LIJST') then $inner_diameter_fits_all_outer_diameters else true()">
            <value-of select="keronic:get-translation-and-replace-placeholders('mantelbuis-inhoud-diameter-larger-than-own', [$inner_diameter, string-join($outer_diameters, ', ')])"/>
        </assert>
    </rule>
</pattern>
