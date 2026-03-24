<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:ma="http://example.com/mijnaansluiting"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
	        version="3.0">

    <function name="ma:create-gml-point" as="node()">
        <param name="coord" as="node()"/>

        <choose>
            <when test="empty($coord/ma:Z)">
                <gml:Point srsDimension="2" srsName="EPSG:28992">
                    <gml:pos>
                        <value-of select="$coord/ma:X, $coord/ma:Y"/>
                    </gml:pos>
                </gml:Point>
            </when>
            <otherwise>
                <gml:Point srsDimension="3" srsName="EPSG:7415">
                    <gml:pos>
                        <value-of select="$coord/ma:X, $coord/ma:Y, $coord/ma:Z"/>
                    </gml:pos>
                </gml:Point>
            </otherwise>
        </choose>
    </function>

    <function name="ma:create-gml-line" as="node()">
        <param name="coords" as="node()*"/>
        <choose>
            <when test="empty($coords[1]/ma:Z)">
                <gml:LineString srsDimension="2" srsName="EPSG:28992">
                    <gml:posList>
                        <for-each select="$coords">
                            <value-of select="ma:X, ma:Y, ''"/>
                        </for-each>
                    </gml:posList>
                </gml:LineString>
            </when>
            <otherwise>
                <gml:LineString srsDimension="3" srsName="EPSG:7415">
                    <gml:posList>
                        <for-each select="$coords">
                            <value-of select="ma:X, ma:Y, ma:Z, ''"/>
                        </for-each>
                    </gml:posList>
                </gml:LineString>
            </otherwise>
        </choose>
    </function>

    <function name="ma:create-gml-area" as="node()">
        <param name="coords" as="node()*"/>
        <choose>
            <when test="empty($coords[1]/ma:Z)">
                <gml:Polygon srsDimension="2" srsName="EPSG:28992">
                    <gml:exterior>
                        <gml:LinearRing>
                            <gml:posList>
                                <for-each select="$coords">
                                    <value-of select="ma:X, ma:Y, ''"/>
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
                                    <value-of select="ma:X, ma:Y, ma:Z, ''"/>
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
                    <sequence>
                        <ma:Coord>
                            <ma:X type="xs:double"><value-of select="$string_array[$index]"/></ma:X>
                            <ma:Y type="xs:double"><value-of select="$string_array[$index + 1]"/></ma:Y>
                        </ma:Coord>    
                    </sequence>
                </for-each>
            </when>
            <when test="$dimension = 3">
                <for-each select="1 to count($string_array) idiv 3">
                    <variable name="index" select=". * 3 - 2"/>
                    <sequence>
                        <ma:Coord>
                            <ma:X type="xs:double"><value-of select="$string_array[$index]"/></ma:X>
                            <ma:Y type="xs:double"><value-of select="$string_array[$index + 1]"/></ma:Y>
                            <ma:Z type="xs:double"><value-of select="$string_array[$index + 2]"/></ma:Z>
                        </ma:Coord>    
                    </sequence>
                </for-each>
            </when>
        </choose>
        
    </function>
    
    <function name="ma:parse-point" as="node()">
        <param name="point_geometry" as="node()"/>

        <variable name="dimension" as="xs:integer" select="$point_geometry/gml:Point/@srsDimension"/>        
        <variable name="coords_raw" as="xs:string*" select="tokenize(normalize-space($point_geometry/gml:Point/gml:pos))"/>
        
        <sequence select="ma:parse-coords($coords_raw, $dimension)"/>
    </function>
    
    <function name="ma:parse-line" as="node()*">
        <param name="line_geometry" as="node()"/>

        <variable name="dimension" as="xs:integer" select="$line_geometry/gml:LineString/@srsDimension"/>        
        <variable name="coords_raw" as="xs:string*" select="tokenize(normalize-space($line_geometry/gml:LineString/gml:posList))"/>
        
        <sequence select="ma:parse-coords($coords_raw, $dimension)"/>
    </function>

    <function name="ma:parse-area" as="node()*">
        <param name="area_geometry" as="node()"/>

        <variable name="dimension" as="xs:integer" select="$area_geometry/gml:Polygon/@srsDimension"/> 
        <variable name="coords_raw" as="xs:string*" select="tokenize(normalize-space($area_geometry/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList))"/>
        
        <sequence select="ma:parse-coords($coords_raw, $dimension)"/>
    </function>
</stylesheet>
