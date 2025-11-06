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
      <xsl:for-each select="$nlcs_objects">
        <xsl:variable name="nlcs_object" select="."/>
        <xsl:variable name="line"   select="nlcs:Geometry/gml:LineString"/>
        <xsl:variable name="point"  select="nlcs:Geometry/gml:Point"/>
        <xsl:variable name="poly"   select="nlcs:Geometry/gml:Polygon"/>

        <!-- Lines -->
        <xsl:for-each select="$line">
          <xsl:variable name="dim" select="number(@srsDimension)"/>
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:posList), '\s+')"/>
          <xsl:variable name="pairs"
            select="
              for $i in 1 to count($coords) idiv $dim
              return concat($coords[($i - 1)*$dim+1], ' ', $coords[($i - 1)*$dim+2])
            "/>
          <xsl:value-of select="concat('LINESTRING(', string-join($pairs, ', '), ')')"/>
        </xsl:for-each>

        <!-- Points -->
        <xsl:for-each select="$point">
          <xsl:variable name="dim" select="number(@srsDimension)"/>
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:pos), '\s+')"/>
          <xsl:variable name="pair"
            select="
              if ($dim=3) then concat($coords[1], ' ', $coords[2])
              else concat($coords[1], ' ', $coords[2])
            "/>
          <xsl:value-of select="concat('POINT(', $pair, ')')"/>
        </xsl:for-each>

        <!-- Polygons -->
        <xsl:for-each select="$poly">
          <xsl:variable name="dimension" select="number(@srsDimension)"/>
          <xsl:variable name="coords" select="tokenize(normalize-space(gml:exterior/gml:LinearRing/gml:posList), '\s+')"/>
          <Geom>
            <ID><xsl:value-of select="$nlcs_object/nlcs:ID"/></ID>
            <Type>polygon</Type>
            <Coords>
              <xsl:for-each select="1 to count($coords) idiv $dimension">
                <xsl:variable name="i" select="."/>
                <Coord>
                  <X><xsl:value-of select="$coords[($i - 1) * $dimension + 1]"/></X>
                  <Y><xsl:value-of select="$coords[($i - 1) * $dimension + 2]"/></Y>
                </Coord>
              </xsl:for-each>
            </Coords>
          </Geom>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:sequence>
  </xsl:function>

  <xsl:template match="/">
    <xsl:variable name="nlcs_geometries" as="element()*" select="keronic:extract-geometries(//nlcs:NLCSnetbeheer/*)"/>
    <xsl:variable name="x_coords" select="$nlcs_geometries/Coords/Coord/X"/>
    <xsl:variable name="y_coords" select="$nlcs_geometries/Coords/Coord/Y"/>
    <xsl:variable name="view_box_x" select="min($x_coords)"/>
    <xsl:variable name="view_box_y" select="min($y_coords)"/>
    <xsl:variable name="view_box_width" select="max($x_coords) - $view_box_x"/>
    <xsl:variable name="view_box_height" select="max($y_coords) - $view_box_y"/>

    <xsl:variable name="svg">
      <svg>
        <xsl:attribute name="viewBox">
          <xsl:value-of select="string-join([$view_box_x, $view_box_y, $view_box_width, $view_box_height], ' ')"/>
        </xsl:attribute>
        <xsl:attribute name="width" select="400"/>        
        <xsl:attribute name="height" select="400"/>        
        <xsl:for-each select="$nlcs_geometries">
          <xsl:element name="{Type}">
            <xsl:attribute name="fill" select="'red'"/>
            <xsl:attribute name="stroke" select="'black'"/>
            <xsl:attribute name="points">
              <xsl:for-each select="Coords/Coord">
                <xsl:value-of select="concat(string-join([X, Y], ','), ' ')"/>                
              </xsl:for-each>
            </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$nlcs_geometries">
          <text>
            <xsl:attribute name="x">
              <xsl:value-of select="Coords/Coord[1]/X"/>
            </xsl:attribute>
            <xsl:attribute name="y">
              <xsl:value-of select="Coords/Coord[1]/Y"/>
            </xsl:attribute>
            <xsl:attribute name="fill" select="'black'"/>
            <xsl:value-of select="./ID"/>
          </text>
        </xsl:for-each>
      </svg>
    </xsl:variable>
    <xsl:value-of select="serialize($svg, map{'method':'xml'})"/>
  </xsl:template>

</xsl:stylesheet>
