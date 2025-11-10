<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:nlcs="NS_NLCSnetbeheer"
                xmlns:keronic="http://example.com/my-functions"
                exclude-result-prefixes="gml keronic nlcs xs">

  <xsl:output method="xml" />
  
  <xsl:variable name="anchor_offset" select="7"/>

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
          <xsl:variable name="x" select="number($coords[1])"/>
          <xsl:variable name="y" select="number($coords[2])"/>
          <xsl:variable name="radius" select="5"/>
          <xsl:variable name="color" select="keronic:color-for-index($i)"/>
          <SVGBlueprint id="{$nlcs_object/nlcs:ID}" type="circle" color="{$color}">
            <Measurements 
              minX="{$x - $radius}" 
              minY="{$y - $radius}"
              maxX="{$x + $radius}"
              maxY="{$y + $radius}"
            />
            <Anchor x="{$x}" y="{$y - $anchor_offset}"/>
            <Attribute key="cx" value="{$x}"/>
            <Attribute key="cy" value="{$y}"/>
            <Attribute key="r" value="{$radius}"/>
            <Attribute key="stroke" value="black"/>
            <Attribute key="fill" value="{$color}"/>
          </SVGBlueprint>
        </xsl:for-each>
        
        <xsl:for-each select="$lines">
          <xsl:variable name="dimension" select="number(@srsDimension)"/>
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:posList), '\s+')"/>
          <xsl:variable name="x_coords" select="$coords[position() mod $dimension = 1] ! xs:double(.)"/>
          <xsl:variable name="y_coords" select="$coords[position() mod $dimension = (2 mod $dimension)] ! xs:double(.)"/>
          <xsl:variable name="coord_pairs" select="
            for $j in 1 to count($x_coords)
            return concat($x_coords[$j], ',', $y_coords[$j])"/>
          <xsl:variable name="color" select="keronic:color-for-index($i)"/>

          <SVGBlueprint type="polyline">
            <Attribute key="stroke" value="black"/>
            <Attribute key="stroke-width" value="5"/>
            <Attribute key="stroke-linecap" value="round"/>
            <Attribute key="fill" value="none"/>
            <Attribute key="points" value="{string-join($coord_pairs, ' ')}"/>
          </SVGBlueprint>   
          <SVGBlueprint id="{$nlcs_object/nlcs:ID}" type="polyline" color="{$color}">
            <Measurements
              minX="{min($x_coords) - 5}"  
              minY="{min($y_coords) - 5}"  
              maxX="{max($x_coords) + 5}"  
              maxY="{max($y_coords) + 5}"  
            />
            <Anchor x="{avg($x_coords)}" y="{avg($y_coords) - $anchor_offset}"/>
            <Attribute key="stroke" value="{$color}"/>
            <Attribute key="stroke-width" value="3"/>
            <Attribute key="stroke-linecap" value="round"/>
            <Attribute key="fill" value="none"/>
            <Attribute key="points" value="{string-join($coord_pairs, ' ')}"/>
          </SVGBlueprint>   
        </xsl:for-each>

        <xsl:for-each select="$polygons">
          <xsl:variable name="dimension" select="number(@srsDimension)"/>
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:exterior/gml:LinearRing/gml:posList), '\s+')"/>
          <xsl:variable name="x_coords" select="$coords[position() mod $dimension = 1] ! xs:double(.)"/>
          <xsl:variable name="y_coords" select="$coords[position() mod $dimension = (2 mod $dimension)] ! xs:double(.)"/>
          <xsl:variable name="coord_pairs" select="
            for $j in 1 to count($x_coords)
            return concat($x_coords[$j], ',', $y_coords[$j])"/>
          <xsl:variable name="color" select="keronic:color-for-index($i)"/>

          <SVGBlueprint id="{$nlcs_object/nlcs:ID}" type="polygon" color="{$color}">
            <Measurements
              minX="{min($x_coords)}"  
              minY="{min($y_coords)}"  
              maxX="{max($x_coords)}"  
              maxY="{max($y_coords)}"  
            />
            <Anchor x="{avg($x_coords[position() ne last()])}" y="{avg($y_coords[position() ne last()])}"/>
            <Attribute key="stroke" value="black"/>
            <Attribute key="fill" value="{$color}"/>
            <Attribute key="fill-opacity" value="30%"/>
            <Attribute key="points" value="{string-join($coord_pairs, ' ')}"/>
            <xsl:if test="name($nlcs_object) = 'AprojectReferentie'">
              <Attribute key="stroke-dasharray" value="10,10"/>
            </xsl:if>            
          </SVGBlueprint>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:sequence>
  </xsl:function>
  
  <xsl:function name="keronic:generate-svg" as="element()*">
    <xsl:param name="svg_blueprints" as="element()*"/>
    <xsl:sequence>
      <xsl:for-each select="1 to count($svg_blueprints)">
        <xsl:variable name="i" select="."/>
        <xsl:variable name="nlcs_geometry" select="$svg_blueprints[$i]"/>
        <xsl:element name="{$nlcs_geometry/@type}">
          <xsl:for-each select="$nlcs_geometry/Attribute">
            <xsl:attribute name="{@key}" select="@value"/>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
    </xsl:sequence>
  </xsl:function>
  
  <xsl:function name="keronic:color-for-index" as="xs:string">
    <xsl:param name="index" as="xs:numeric"/>
    <xsl:variable name="hue" select="($index * 137.508) mod 360"/>
    <xsl:sequence select="concat('hsl(', format-number($hue, '0'), ',70%,50%)')"/>
  </xsl:function>

  <xsl:template match="/">
    <xsl:variable name="svg_blueprints" as="element()*" select="keronic:extract-geometries(//nlcs:NLCSnetbeheer/*)"/>
    <xsl:variable name="measurements" select="$svg_blueprints/Measurements"/>
    <xsl:variable name="view_box_padding" select="2 * $anchor_offset"/>
    <xsl:variable name="view_box_x" select="min($measurements/@minX) - $view_box_padding"/>
    <xsl:variable name="view_box_y" select="min($measurements/@minY) - $view_box_padding"/>
    <xsl:variable name="view_box_width" select="max($measurements/@maxX) - $view_box_x + $view_box_padding"/>
    <xsl:variable name="view_box_height" select="max($measurements/@maxY) - $view_box_y + $view_box_padding"/>

    <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="auto">
      <xsl:attribute name="viewBox">
        <xsl:value-of select="string-join([$view_box_x, $view_box_y, $view_box_width, $view_box_height], ' ')"/>
      </xsl:attribute>

      <xsl:variable name="polygon_blueprints" select="$svg_blueprints[@type = 'polygon']"/>
      <xsl:for-each select="1 to count($polygon_blueprints)">
        <xsl:variable name="i" select="."/>
        <xsl:variable name="nlcs_geometry" select="$polygon_blueprints[$i]"/>
        <xsl:element name="{$nlcs_geometry/@type}">
          <xsl:for-each select="$nlcs_geometry/Attribute">
            <xsl:attribute name="{@key}" select="@value"/>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
      
      <xsl:variable name="line_blueprints" select="$svg_blueprints[@type = 'polyline']"/>
      <xsl:for-each select="1 to count($line_blueprints)">
        <xsl:variable name="i" select="."/>
        <xsl:variable name="nlcs_geometry" select="$line_blueprints[$i]"/>
        <xsl:element name="{$nlcs_geometry/@type}">
          <xsl:for-each select="$nlcs_geometry/Attribute">
            <xsl:attribute name="{@key}" select="@value"/>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
      
      <xsl:variable name="point_blueprints" select="$svg_blueprints[@type = 'circle']"/>
      <xsl:for-each select="1 to count($point_blueprints)">
        <xsl:variable name="i" select="."/>
        <xsl:variable name="nlcs_geometry" select="$point_blueprints[$i]"/>
        <xsl:element name="{$nlcs_geometry/@type}">
          <xsl:for-each select="$nlcs_geometry/Attribute">
            <xsl:attribute name="{@key}" select="@value"/>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>

      <xsl:for-each select="$svg_blueprints">
        <text 
          x="{Anchor/@x}" 
          y="{Anchor/@y}" 
          fill="{@color}"
          font-size="1.0rem"
          text-anchor="middle"
          font-family="monospace"
          font-weight="bold"
        >
          <xsl:value-of select="@id"/>
        </text>
      </xsl:for-each>
    </svg>
  </xsl:template>

</xsl:stylesheet>
