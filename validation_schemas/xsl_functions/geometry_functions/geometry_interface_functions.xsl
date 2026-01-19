<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	        xmlns:keronic="http://example.com/my-functions"
            xmlns:keronic-geom="http://example.com/my-functions-test"
            xmlns:ma="http://example.com/mijnaansluiting"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	        version="3.0">
    
    <function name="ma:point-interacts-with-area" as="xs:boolean">
        <param name="point_geometry" as="node()"/>
        <param name="area_geometry" as="node()"/>
        
        <variable name="point" as="xs:double*" select="ma:parse-point($point_geometry)"/>
        <variable name="area" as="xs:double*" select="ma:parse-area($area_geometry)"/>
        
        <value-of select="keronic-geom:point-2d-interacts-with-area-2d($point, $area)"/>
    </function>
    
    <function name="ma:line-interacts-with-area" as="xs:boolean">
        <param name="line_geometry" as="node()"/>
        <param name="area_geometry" as="node()"/>
        
        <variable name="line" as="xs:double*" select="ma:parse-line($line_geometry)"/>
        <variable name="area" as="xs:double*" select="ma:parse-area($area_geometry)"/>
        
        <value-of select="keronic-geom:line-2d-interacts-with-area-2d($line, $area)"/>
    </function>
    
    <function name="ma:area-interacts-with-area" as="xs:boolean">
        <param name="area_1_geometry" as="node()"/>
        <param name="area_2_geometry" as="node()"/>
        
        <variable name="area_1" as="xs:double*" select="ma:parse-area($area_1_geometry)"/>
        <variable name="area_2" as="xs:double*" select="ma:parse-area($area_2_geometry)"/>
        
        <value-of select="keronic-geom:area-2d-interacts-with-area-2d($area_1, $area_2)"/>
    </function>
    
    <function name="ma:line-segments-not-meeting-length-demands" as="node()*">
        <param name="line_coords" as="xs:double*"/>
        
        <for-each select="1 to (count($line_coords) idiv 2) - 1">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="x1" as="xs:double" select="$line_coords[2 * $index - 1]"/>
            <variable name="y1" as="xs:double" select="$line_coords[2 * $index]"/>
            <variable name="x2" as="xs:double" select="$line_coords[2 * ($index + 1) - 1]"/>
            <variable name="y2" as="xs:double" select="$line_coords[2 * ($index + 1)]"/>
            
            <variable name="segment_length" as="xs:double" select="keronic:point-2d-to-point-2d-distance($x1, $y1, $x2, $y2)"/>
            <if test="$segment_length le 0.1 or $segment_length ge 50">
                <sequence select="keronic:create-gml-line(($x1, $y1, $x2, $y2), 2, 28992)"/>    
            </if>
        </for-each> 
    </function>
    
    <function name="ma:line-segments-not-meeting-angle-demands" as="node()*">
        <param name="line_coords" as="xs:double*"/>      
        
        <for-each select="1 to (count($line_coords) idiv 2) - 2">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="x1" as="xs:double" select="$line_coords[2 * $index - 1]"/>
            <variable name="y1" as="xs:double" select="$line_coords[2 * $index]"/>
            <variable name="x2" as="xs:double" select="$line_coords[2 * ($index + 1) - 1]"/>
            <variable name="y2" as="xs:double" select="$line_coords[2 * ($index + 1)]"/>
            <variable name="x3" as="xs:double" select="$line_coords[2 * ($index + 2) - 1]"/>
            <variable name="y3" as="xs:double" select="$line_coords[2 * ($index + 2)]"/>
            
            <variable name="segment_angle" as="xs:double" select="ma:angle-between-two-lines($x1, $y1, $x2, $y2, $x3, $y3)"/>
            <if test="$segment_angle lt 135">
                <sequence select="keronic:create-gml-line(($x1, $y1, $x2, $y2, $x3, $y3), 2, 28992)"/>    
            </if>
        </for-each> 
    </function>
    
    <!-- FROM POINT FUNCTIONS -->
    <function name="keronic:point-connected-to-point" as="xs:boolean">
        <param name="point_1" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-connected-to-point-2d(
                                          $point_1,
                                          $point_2,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-point-2d(
                                          $point_2,
                                          $point_1,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-connected-to-point-3d(
                                          $point_1,
                                          $point_2,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-point-2d(
                                          $point_1,
                                          $point_2,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:point-connected-to-line" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-connected-to-line-2d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-point-2d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-connected-to-line-3d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-line-2d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:point-touches-line" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-touches-line-2d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>

                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-point-2d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-touches-line-3d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-touches-line-2d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:point-connected-to-area" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="area" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-connected-to-area-2d(
                                          $point,
                                          $area,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-point-2d(
                                          $area,
                                          $point,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-connected-to-area-3d(
                                          $point,
                                          $area,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-area-2d(
                                          $point,
                                          $area,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>


    <!-- FROM LINE FUNCTIONS -->
    <function name="keronic:line-connected-to-point" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-connected-to-point-2d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-point-2d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>

                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-connected-to-point-3d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-point-2d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-touches-point" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-touches-point-2d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-touches-line-2d(
                                          $point,
                                          $line,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-touches-point-3d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-point-2d(
                                          $line,
                                          $point,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-connected-to-line" as="xs:boolean">
        <param name="line_1" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-connected-to-line-2d(
                                          $line_1,
                                          $line_2,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-line-2d(
                                          $line_2,
                                          $line_1,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-connected-to-line-3d(
                                          $line_1,
                                          $line_2,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-line-2d(
                                          $line_1,
                                          $line_2,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-touches-line" as="xs:boolean">
        <param name="line_1" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-touches-line-2d(
                                          $line_1,
                                          $line_2,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-line-2d(
                                          $line_2,
                                          $line_1,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-touches-line-3d(
                                          $line_1,
                                          $line_2,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-line-2d(
                                          $line_1,
                                          $line_2,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-connected-to-area" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="area" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-connected-to-area-2d(
                                          $line,
                                          $area,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-line-2d(
                                          $area,
                                          $line,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-connected-to-area-3d(
                                          $line,
                                          $area,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-area-2d(
                                          $line,
                                          $area,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>


    <!-- FROM AREA FUNCTIONS -->
    <function name="keronic:area-connected-to-point" as="xs:boolean">
        <param name="area" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:area-2d-connected-to-point-2d(
                                          $area,
                                          $point,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-area-2d(
                                          $point,
                                          $area,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:area-3d-connected-to-point-3d(
                                          $area,
                                          $point,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-point-2d(
                                          $area,
                                          $point,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:area-connected-to-line" as="xs:boolean">
        <param name="area" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:area-2d-connected-to-line-2d(
                                          $area,
                                          $line,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-area-2d(
                                          $line,
                                          $area,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:area-3d-connected-to-line-3d(
                                          $area,
                                          $line,
                                          ()
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-line-2d(
                                          $area,
                                          $line,
                                          ()
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

        <!-- FROM POINT FUNCTIONS WITH THRESHOLD-->
    <function name="keronic:point-connected-to-point-with-threshold" as="xs:boolean">
        <param name="point_1" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-connected-to-point-2d(
                                          $point_1,
                                          $point_2,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-point-2d(
                                          $point_2,
                                          $point_1,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-connected-to-point-3d(
                                          $point_1,
                                          $point_2,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-point-2d(
                                          $point_1,
                                          $point_2,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:point-connected-to-line-with-threshold" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-connected-to-line-2d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-point-2d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-connected-to-line-3d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-line-2d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:point-touches-line-with-threshold" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-touches-line-2d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>

                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-point-2d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-touches-line-3d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-touches-line-2d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:point-connected-to-area-with-threshold" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="area" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:point-2d-connected-to-area-2d(
                                          $point,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-point-2d(
                                          $area,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:point-3d-connected-to-area-3d(
                                          $point,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-area-2d(
                                          $point,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>


    <!-- FROM LINE FUNCTIONS WITH THRESHOLD -->
    <function name="keronic:line-connected-to-point-with-threshold" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-connected-to-point-2d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-point-2d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>

                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-connected-to-point-3d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-point-2d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-touches-point-with-threshold" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-touches-point-2d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-touches-line-2d(
                                          $point,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-touches-point-3d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-point-2d(
                                          $line,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-connected-to-line-with-threshold" as="xs:boolean">
        <param name="line_1" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-connected-to-line-2d(
                                          $line_1,
                                          $line_2,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-line-2d(
                                          $line_2,
                                          $line_1,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-connected-to-line-3d(
                                          $line_1,
                                          $line_2,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-line-2d(
                                          $line_1,
                                          $line_2,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-touches-line-with-threshold" as="xs:boolean">
        <param name="line_1" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-touches-line-2d(
                                          $line_1,
                                          $line_2,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-line-2d(
                                          $line_2,
                                          $line_1,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-touches-line-3d(
                                          $line_1,
                                          $line_2,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-touches-line-2d(
                                          $line_1,
                                          $line_2,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:line-connected-to-area-with-threshold" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="area" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:line-2d-connected-to-area-2d(
                                          $line,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-line-2d(
                                          $area,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:line-3d-connected-to-area-3d(
                                          $line,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-area-2d(
                                          $line,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>


    <!-- FROM AREA FUNCTIONS WITH THRESHOLD-->
    <function name="keronic:area-connected-to-point-with-threshold" as="xs:boolean">
        <param name="area" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:area-2d-connected-to-point-2d(
                                          $area,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:point-3d-connected-to-area-2d(
                                          $point,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:area-3d-connected-to-point-3d(
                                          $area,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-point-2d(
                                          $area,
                                          $point,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:area-connected-to-line-with-threshold" as="xs:boolean">
        <param name="area" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <param name="threshold" as="xs:string"/>

        <variable name="d_threshold" select="xs:double($threshold)" as="xs:double"/>
        <variable name="d_dimension_1" select="xs:double($dimension_1)" as="xs:double"/>
        <variable name="d_dimension_2" select="xs:double($dimension_2)" as="xs:double"/>

        <choose>
            <when test="$d_dimension_1 = 2">
                <choose>
                    <when test="$d_dimension_2 = 2">
                        <value-of select="keronic:area-2d-connected-to-line-2d(
                                          $area,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:line-3d-connected-to-area-2d(
                                          $line,
                                          $area,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <when test="$d_dimension_1 = 3">
                <choose>
                    <when test="$d_dimension_2 = 3">
                        <value-of select="keronic:area-3d-connected-to-line-3d(
                                          $area,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic:area-3d-connected-to-line-2d(
                                          $area,
                                          $line,
                                          $d_threshold
                                          )"/>
                    </otherwise>
                </choose>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>


    <function name="keronic:line-start-connected-to-point" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

       <variable name="line_start_point">
            <choose>
                <when test="xs:double($dimension_1) = 3">
                    <sequence select="$line[
                                      position() = 1 or
                                      position() = 2 or
                                      position() = 3 ]"/>
                </when>
                <otherwise>
                    <sequence select="$line[
                                      position() = 1 or
                                      position() = 2 ]"/>
                </otherwise>
            </choose>
        </variable>
        <value-of select="keronic:point-connected-to-point(
                          tokenize($line_start_point, ' '),
                          $dimension_1,
                          $point,
                          $dimension_2)"/>
    </function>

    <function name="keronic:line-end-connected-to-point" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="point" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <variable name="line_end_point">
            <choose>
                <when test="xs:double($dimension_1) = 3">
                    <sequence select="$line[
                                      position() = last() - 2 or
                                      position() = last() - 1 or
                                      position() = last() ]"/>
                </when>
                <otherwise>
                    <sequence select="$line[
                                      position() = last() - 1 or
                                      position() = last() ]"/>
                </otherwise>
            </choose>
        </variable>
        <value-of select="keronic:point-connected-to-point(
                          tokenize($line_end_point, ' '),
                          $dimension_1,
                          $point,
                          $dimension_2)"/>
    </function>

    <function name="keronic:line-start-connected-to-line" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="line_start_point">
            <choose>
                <when test="xs:double($dimension_1) = 3">
                    <sequence select="$line[
                                      position() = 1 or
                                      position() = 2 or
                                      position() = 3 ]"/>
                </when>
                <otherwise>
                    <sequence select="$line[
                                      position() = 1 or
                                      position() = 2 ]"/>
                </otherwise>
            </choose>
        </variable>
        <value-of select="keronic:point-connected-to-line(
                          tokenize($line_start_point, ' '),
                          $dimension_1,
                          $line_2,
                          $dimension_2)"/>
    </function>

    <function name="keronic:line-end-connected-to-line" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="line_2" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="line_end_point">
            <choose>
                <when test="xs:double($dimension_1) = 3">
                    <sequence select="$line[
                                      position() = last() - 2 or
                                      position() = last() - 1 or
                                      position() = last() ]"/>
                </when>
                <otherwise>
                    <sequence select="$line[
                                      position() = last() - 1 or
                                      position() = last() ]"/>
                </otherwise>
            </choose>
        </variable>
        <value-of select="keronic:point-connected-to-line(
                          tokenize($line_end_point, ' '),
                          $dimension_1,
                          $line_2,
                          $dimension_2)"/>
    </function>

    <function name="keronic:line-start-connected-to-area" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="area" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>
        <variable name="line_start_point">
            <choose>
                <when test="xs:double($dimension_1) = 3">
                    <sequence select="$line[
                                      position() = 1 or
                                      position() = 2 or
                                      position() = 3 ]"/>
                </when>
                <otherwise>
                    <sequence select="$line[
                                      position() = 1 or
                                      position() = 2 ]"/>
                </otherwise>
            </choose>
        </variable>
        <value-of select="keronic:point-connected-to-area(
                          tokenize($line_start_point, ' '),
                          $dimension_1,
                          $area,
                          $dimension_2)"/>
    </function>

    <function name="keronic:line-end-connected-to-area" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="dimension_1" as="xs:string"/>
        <param name="area" as="xs:string*"/>
        <param name="dimension_2" as="xs:string"/>

        <variable name="line_end_point">
            <choose>
                <when test="xs:double($dimension_1) = 3">
                    <sequence select="$line[
                                      position() = last() - 2 or
                                      position() = last() - 1 or
                                      position() = last() ]"/>
                </when>
                <otherwise>
                    <sequence select="$line[
                                      position() = last() - 1 or
                                      position() = last() ]"/>
                </otherwise>
            </choose>
        </variable>
        <value-of select="keronic:point-connected-to-area(
                          tokenize($line_end_point, ' '),
                          $dimension_1,
                          $area,
                          $dimension_2)"/>
    </function>
</stylesheet>
