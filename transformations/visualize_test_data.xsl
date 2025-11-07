<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:nlcs="NS_NLCSnetbeheer"
                xmlns:keronic="http://example.com/my-functions"
                exclude-result-prefixes="gml keronic nlcs xs">

  <xsl:output method="text" />

  <xsl:function name="keronic:extract-geometries" as="element()*">
    <xsl:param name="nlcs_objects" as="element()*"/>
    <xsl:sequence>
      <xsl:for-each select="1 to count($nlcs_objects)">
        <xsl:variable name="i" select="."/>
        <xsl:variable name="nlcs_object" select="$nlcs_objects[$i]"/>
        <xsl:variable name="points" select="$nlcs_object/nlcs:Geometry/gml:Point"/>
        <xsl:variable name="lines" select="$nlcs_object/nlcs:Geometry/gml:LineString"/>
        <xsl:variable name="polygons" select="$nlcs_object/nlcs:Geometry/gml:Polygon"/>

        <xsl:for-each select="$points">
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:pos), '\s+')"/>
          <SVGBlueprint id="{$nlcs_object/nlcs:ID}" type="circle">
            <Attribute key="cx" value="{$coords[1]}"/>
            <Attribute key="cy" value="{$coords[2]}"/>
            <Attribute key="stroke" value="black"/>
            <Attribute key="fill" value="{keronic:color-for-index($i)}"/>
            <Attribute key="r" value="5"/>
            <Coord x="{$coords[1]}" y="{$coords[2]}"/>
          </SVGBlueprint>
        </xsl:for-each>
        
        <xsl:for-each select="$lines">
          <xsl:variable name="dimension" select="number(@srsDimension)"/>
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:posList), '\s+')"/>
          
          <SVGBlueprint id="{$nlcs_object/nlcs:ID}" type="polyline">
            <Attribute key="stroke" value="{keronic:color-for-index($i)}"/>
            <Attribute key="stroke-width" value="5"/>
            <Attribute key="stroke-linecap" value="round"/>
            <Attribute key="fill" value="none"/>
            <xsl:for-each select="1 to count($coords) idiv $dimension">
              <xsl:variable name="j" select="."/>
              <xsl:variable name="x" select="$coords[($j - 1) * $dimension + 1]"/>
              <xsl:variable name="y" select="$coords[($j - 1) * $dimension + 2]"/>
              <Coord x="{$x}" y="{$y}"/>
            </xsl:for-each>
          </SVGBlueprint>   
        </xsl:for-each>

        <xsl:for-each select="$polygons">
          <xsl:variable name="dimension" select="number(@srsDimension)"/>
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:exterior/gml:LinearRing/gml:posList), '\s+')"/>
          
          <SVGBlueprint id="{$nlcs_object/nlcs:ID}" type="polygon">
            <Attribute key="stroke" value="black"/>
            <Attribute key="fill" value="{keronic:color-for-index($i)}"/>
            <Attribute key="fill-opacity" value="30%"/>
            <xsl:if test="name($nlcs_object) = 'AprojectReferentie'">
              <Attribute key="stroke-dasharray" value="10,10"/>
            </xsl:if>
            <xsl:for-each select="1 to count($coords) idiv $dimension">
              <xsl:variable name="j" select="."/>
              <xsl:variable name="x" select="$coords[($j - 1) * $dimension + 1]"/>
              <xsl:variable name="y" select="$coords[($j - 1) * $dimension + 2]"/>
              <Coord x="{$x}" y="{$y}"/>
            </xsl:for-each>
          </SVGBlueprint>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:sequence>
  </xsl:function>
  
  <xsl:function name="keronic:color-for-index" as="xs:string">
    <xsl:param name="index" as="xs:numeric"/>
    <xsl:variable name="hue" select="($index * 137.508) mod 360"/>
    <xsl:sequence select="concat('hsl(', format-number($hue, '0'), ',70%,50%)')"/>
  </xsl:function>

  <xsl:template match="/">
    <xsl:variable name="nlcs_geometries" as="element()*" select="keronic:extract-geometries(//nlcs:NLCSnetbeheer/*)"/>
    <xsl:variable name="x_coords" select="$nlcs_geometries/Coord/@x"/>
    <xsl:variable name="y_coords" select="$nlcs_geometries/Coord/@y"/>
    <xsl:variable name="view_box_x" select="min($x_coords) - 6"/>
    <xsl:variable name="view_box_y" select="min($y_coords) - 6"/>
    <xsl:variable name="view_box_width" select="max($x_coords) - min($x_coords) + 12"/>
    <xsl:variable name="view_box_height" select="max($y_coords) - min($y_coords) + 12"/>

    <xsl:variable name="svg">
      <svg>
        <xsl:attribute name="viewBox">
          <xsl:value-of select="string-join([$view_box_x, $view_box_y, $view_box_width, $view_box_height], ' ')"/>
        </xsl:attribute>
        <xsl:attribute name="width" select="400"/>        
        <xsl:attribute name="height" select="400"/>        
        <xsl:for-each select="1 to count($nlcs_geometries)">
          <xsl:variable name="i" select="."/>
          <xsl:variable name="nlcs_geometry" select="$nlcs_geometries[$i]"/>
          <xsl:element name="{$nlcs_geometry/@type}">
            <xsl:for-each select="$nlcs_geometry/Attribute">
              <xsl:attribute name="{@key}" select="@value"/>
            </xsl:for-each>
            <xsl:attribute name="points">
              <xsl:for-each select="$nlcs_geometry/Coord">
                <xsl:value-of select="concat(string-join([@x, @y], ','), ' ')"/>                
              </xsl:for-each>
            </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$nlcs_geometries">
          <text>
            <xsl:attribute name="x">
              <xsl:value-of select="Coord[1]/@x"/>
            </xsl:attribute>
            <xsl:attribute name="y">
              <xsl:value-of select="Coord[1]/@y"/>
            </xsl:attribute>
            <xsl:attribute name="fill" select="'black'"/>
            <xsl:value-of select="@id"/>
          </text>
        </xsl:for-each>
      </svg>
    </xsl:variable>
    <xsl:value-of select="serialize($svg, map{'method':'xml'})"/>
  </xsl:template>

</xsl:stylesheet>
