<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:ma="http://example.com/mijnaansluiting"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:nlcs="NS_NLCSnetbeheer"
            xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	        version="3.0">

    <function name="ma:create-gml-point" as="node()">
        <param name="coord" as="node()"/>

        <choose>
            <when test="empty($coord/Z)">
                <gml:Point srsDimension="2" srsName="EPSG:28992">
                    <gml:pos>
                        <value-of select="$coord/X, $coord/Y"/>
                    </gml:pos>
                </gml:Point>
            </when>
            <otherwise>
                <gml:Point srsDimension="3" srsName="EPSG:7415">
                    <gml:pos>
                        <value-of select="$coord/X, $coord/Y, $coord/Z"/>
                    </gml:pos>
                </gml:Point>
            </otherwise>
        </choose>
    </function>

    <function name="ma:create-gml-line" as="node()">
        <param name="coords" as="node()*"/>
        <choose>
            <when test="empty($coords[1]/Z)">
                <gml:LineString srsDimension="2" srsName="EPSG:28992">
                    <gml:posList>
                        <for-each select="$coords">
                            <value-of select="X, Y, ''"/>
                        </for-each>
                    </gml:posList>
                </gml:LineString>
            </when>
            <otherwise>
                <gml:LineString srsDimension="3" srsName="EPSG:7415">
                    <gml:posList>
                        <for-each select="$coords">
                            <value-of select="X, Y, Z, ''"/>
                        </for-each>
                    </gml:posList>
                </gml:LineString>
            </otherwise>
        </choose>
    </function>

    <function name="ma:create-gml-area" as="node()">
        <param name="coords" as="node()*"/>
        <choose>
            <when test="empty($coords[1]/Z)">
                <gml:Polygon srsDimension="2" srsName="EPSG:28992">
                    <gml:exterior>
                        <gml:LinearRing>
                            <gml:posList>
                                <for-each select="$coords">
                                    <value-of select="X, Y, ''"/>
                                </for-each>
                            </gml:posList>
                        </gml:LinearRing>
                    </gml:exterior>
                </gml:Polygon>
            </when>
            <otherwise>
                <gml:Polygon srsDimension="3" srsName="EPSG:7415">
                    <gml:exterior>
                        <gml:LinearRing>
                            <gml:posList>
                                <for-each select="$coords">
                                    <value-of select="X, Y, Z, ''"/>
                                </for-each>
                            </gml:posList>
                        </gml:LinearRing>
                    </gml:exterior>
                </gml:Polygon>
            </otherwise>
        </choose>
    </function>

    <function name="ma:element-exists-and-not-empty" as="xs:boolean">
        <param name="element"/>
        <sequence select="$element and normalize-space($element)"/>
    </function>

    <function name="ma:parse-coords" as="node()*">
        <param name="string_array" as="xs:string*"/>
        <param name="dimension" as="xs:integer"/>
        <choose>
            <when test="$dimension = 2">
                <for-each select="1 to count($string_array) idiv 2">
                    <variable name="index" select=". * 2 - 1"/>
                    <variable name="x" select="$string_array[$index]"/>
                    <variable name="y" select="$string_array[$index + 1]"/>
                    <sequence select="ma:coord($x, $y)"/>
                </for-each>
            </when>
            <when test="$dimension = 3">
                <for-each select="1 to count($string_array) idiv 3">
                    <variable name="index" select=". * 3 - 2"/>
                    <variable name="x" select="$string_array[$index]"/>
                    <variable name="y" select="$string_array[$index + 1]"/>
                    <variable name="z" select="$string_array[$index + 2]"/>
                    <sequence select="ma:coord($x, $y, $z)"/>
                </for-each>
            </when>
        </choose>
    </function>
    
    <function name="ma:coord" as="node()">
        <param name="x"/>
        <param name="y"/>
        
        <Coord xmlns="">
            <X type="xs:double"><value-of xmlns="http://www.w3.org/1999/XSL/Transform" select="$x"/></X>
            <Y type="xs:double"><value-of xmlns="http://www.w3.org/1999/XSL/Transform" select="$y"/></Y>
        </Coord>  
    </function>
    
    <function name="ma:coord" as="node()">
        <param name="x"/>
        <param name="y"/>
        <param name="z"/>
        
        <Coord xmlns="">
            <X type="xs:double"><value-of xmlns="http://www.w3.org/1999/XSL/Transform" select="$x"/></X>
            <Y type="xs:double"><value-of xmlns="http://www.w3.org/1999/XSL/Transform" select="$y"/></Y>
            <Z type="xs:double"><value-of xmlns="http://www.w3.org/1999/XSL/Transform" select="$z"/></Z>
        </Coord>  
    </function>
    
    <!-- ==========================================================
         Memoized geometry parsing. ma:parse-coords/ma:coord rebuild a
         fresh <Coord> element per vertex on every call; without caching,
         re-parsing the same nlcs:Geometry node (e.g. once per candidate
         in an O(n*m) rule such as R.21's kabel<->mof endpoint scan, or
         once per point in connectivity_functions.xsl's touch-index build)
         redoes that work from scratch every time. Each cache is a
         lazily-evaluated global map keyed by generate-id() of the
         nlcs:Geometry node, built once per validation run by scanning
         every geometry of the relevant shape - same pure map/map-entry
         style as connectivity_functions.xsl's touch index (no constructed
         element tree indexed via xsl:key for the cache itself; see
         connectivity_functions.xsl's header comment for why that
         combination is unsafe at this codebase's scale). Only the cache
         wrapper is new - the tokenize/dimension/parse-coords logic below
         is unchanged from before. -->
    <variable name="parsed_point_cache" as="map(xs:string, node())">
        <map>
            <for-each select="//nlcs:Geometry[gml:Point]">
                <variable name="dimension" as="xs:integer" select="gml:Point/@srsDimension"/>
                <variable name="coords_raw" as="xs:string*" select="tokenize(normalize-space(gml:Point/gml:pos))"/>
                <map-entry key="generate-id(.)" select="ma:parse-coords($coords_raw, $dimension)"/>
            </for-each>
        </map>
    </variable>

    <variable name="parsed_line_cache" as="map(xs:string, node()*)">
        <map>
            <for-each select="//nlcs:Geometry[gml:LineString]">
                <variable name="dimension" as="xs:integer" select="gml:LineString/@srsDimension"/>
                <variable name="coords_raw" as="xs:string*" select="tokenize(normalize-space(gml:LineString/gml:posList))"/>
                <map-entry key="generate-id(.)" select="ma:parse-coords($coords_raw, $dimension)"/>
            </for-each>
        </map>
    </variable>

    <variable name="parsed_area_cache" as="map(xs:string, node()*)">
        <map>
            <for-each select="//nlcs:Geometry[gml:Polygon]">
                <variable name="dimension" as="xs:integer" select="gml:Polygon/@srsDimension"/>
                <variable name="coords_raw" as="xs:string*" select="tokenize(normalize-space(gml:Polygon/gml:exterior/gml:LinearRing/gml:posList))"/>
                <map-entry key="generate-id(.)" select="ma:parse-coords($coords_raw, $dimension)"/>
            </for-each>
        </map>
    </variable>

    <function name="ma:parse-point" as="node()">
        <param name="point_geometry" as="node()"/>

        <sequence select="map:get($parsed_point_cache, generate-id($point_geometry))"/>
    </function>

    <function name="ma:parse-line" as="node()*">
        <param name="line_geometry" as="node()"/>

        <sequence select="map:get($parsed_line_cache, generate-id($line_geometry))"/>
    </function>

    <function name="ma:parse-area" as="node()*">
        <param name="area_geometry" as="node()"/>

        <sequence select="map:get($parsed_area_cache, generate-id($area_geometry))"/>
    </function>
    
    <variable name="precision_factor" select="math:pow(10, ma:decimal-precision())"/>
    <function name="ma:trim-decimals" as="xs:double">
        <param name="number" as="xs:double"/>
        
        <sequence select="round($number * $precision_factor) div $precision_factor"/>
    </function>
</stylesheet>
