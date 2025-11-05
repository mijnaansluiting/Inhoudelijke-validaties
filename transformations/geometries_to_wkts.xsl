<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:nlcs="NS_NLCSnetbeheer"
                xmlns:keronic="http://example.com/my-functions"
                exclude-result-prefixes="gml keronic">

  <xsl:output method="text" />

  <xsl:function name="keronic:extract-geometries" as="xs:string">
    <xsl:param name="geoms" as="element(nlcs:Geometry)*"/>

    <xsl:variable name="wkts" as="xs:string*">
      <xsl:for-each select="$geoms">
        <!-- Only geometries with srsName="EPSG:7415" -->
        <xsl:variable name="line"   select="gml:LineString"/>
        <xsl:variable name="point"  select="gml:Point"/>
        <xsl:variable name="poly"   select="gml:Polygon"/>

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
          <xsl:variable name="dim" select="number(@srsDimension)"/>
          <xsl:variable name="coords"
            select="tokenize(normalize-space(gml:exterior/gml:LinearRing/gml:posList), '\s+')"/>
          <xsl:variable name="pairs"
            select="
              for $i in 1 to count($coords) idiv $dim
              return
                if ($dim=3 and $i mod 3 = 0) then ()
                else concat($coords[($i - 1)*$dim+1], ' ', $coords[($i - 1)*$dim+2])
            "/>
          <xsl:value-of select="concat('POLYGON((', string-join($pairs, ', '), '))')"/>
        </xsl:for-each>

      </xsl:for-each>
    </xsl:variable>

    <!-- Wrap in a GEOMETRYCOLLECTION -->
    <xsl:value-of select="concat('GEOMETRYCOLLECTION(', string-join($wkts, ', '), ')')"/>
  </xsl:function>

  <xsl:template match="/">
    <xsl:value-of select="keronic:extract-geometries(//nlcs:Geometry)"/>
  </xsl:template>

</xsl:stylesheet>
