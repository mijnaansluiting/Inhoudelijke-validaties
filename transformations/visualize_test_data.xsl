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
    <xsl:param name="nlcs_objects" as="element()*"/>

    <xsl:variable name="svgs" as="xs:string*">
      <xsl:for-each select="$nlcs_objects">
        <!-- Only geometries with srsName="EPSG:7415" -->
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
          <xsl:variable name="dim" select="number(@srsDimension)"/>
          <xsl:variable name="coords"
            select="tokenize(normalize-space(gml:exterior/gml:LinearRing/gml:posList), '\s+')"/>
          <xsl:variable name="pairs"
            select="
              for $i in 1 to count($coords) idiv $dim
              return
                if ($dim=3 and $i mod 3 = 0) then ()
                else concat($coords[($i - 1)*$dim+1], ',', $coords[($i - 1)*$dim+2])
            "/>
          <xsl:value-of select="concat('&#x09;&lt;polyline fill=&quot;red&quot; points=&quot;&#xa;&#x09;&#x09;', string-join($pairs, '&#xa;&#x09;&#x09;'), '&#xa;&#x09;&quot;/&gt;&#xa;&#x09;&lt;text x=&quot;', substring-before($pairs[1], ','), '&quot; y=&quot;', substring-after($pairs[1], ','), '&quot;&gt;', $nlcs_object/nlcs:ID,'&lt;/text&gt;')"/>
          
        </xsl:for-each>

      </xsl:for-each>
    </xsl:variable>

    <!-- <xsl:value-of select="string-join($wkts, '&#xa;')"/> -->
    <xsl:value-of select="string-join($svgs, '&#xa;')"/>
  </xsl:function>

  <xsl:template match="/">
    <xsl:value-of select="'&lt;svg viewBox=&quot;160 30 200 170&quot; width=&quot;400&quot; height=&quot;400&quot;&gt;&#xa;'"/>
    <xsl:value-of select="keronic:extract-geometries(//nlcs:NLCSnetbeheer/*)"/>
    <xsl:value-of select="'&#xa;&lt;/svg&gt;&#xa;'"/>
  </xsl:template>

</xsl:stylesheet>
