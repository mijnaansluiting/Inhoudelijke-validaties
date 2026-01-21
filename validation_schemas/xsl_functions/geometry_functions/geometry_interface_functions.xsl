<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:ma="http://example.com/mijnaansluiting"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	        version="3.0">
    
    <function name="ma:point-interacts-with-area" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        
        <value-of select="ma:point-2d-interacts-with-area-2d($point, $area)"/>
    </function>
    
    <function name="ma:line-interacts-with-area" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        
        <value-of select="ma:line-2d-interacts-with-area-2d($line, $area)"/>
    </function>
    
    <function name="ma:area-interacts-with-area" as="xs:boolean">
        <param name="area_1" as="xs:double*"/>
        <param name="area_2" as="xs:double*"/>
        
        <value-of select="ma:area-2d-interacts-with-area-2d($area_1, $area_2)"/>
    </function>
    
    <function name="ma:line-segments-not-meeting-length-demands" as="node()*">
        <param name="line" as="xs:double*"/>
        
        <for-each select="1 to (count($line) idiv 2) - 1">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="x1" as="xs:double" select="$line[2 * $index - 1]"/>
            <variable name="y1" as="xs:double" select="$line[2 * $index]"/>
            <variable name="x2" as="xs:double" select="$line[2 * ($index + 1) - 1]"/>
            <variable name="y2" as="xs:double" select="$line[2 * ($index + 1)]"/>
            
            <variable name="segment_length" as="xs:double" select="ma:point-2d-to-point-2d-distance(($x1, $y1), ($x2, $y2))"/>
            <if test="$segment_length le 0.1 or $segment_length ge 50">
                <sequence select="ma:create-gml-line(($x1, $y1, 0, $x2, $y2, 0), 3, 7415)"/>    
            </if>
        </for-each> 
    </function>
    
    <function name="ma:line-segments-not-meeting-angle-demands" as="node()*">
        <param name="line" as="xs:double*"/>      
        
        <for-each select="1 to (count($line) idiv 2) - 2">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="x1" as="xs:double" select="$line[2 * $index - 1]"/>
            <variable name="y1" as="xs:double" select="$line[2 * $index]"/>
            <variable name="x2" as="xs:double" select="$line[2 * ($index + 1) - 1]"/>
            <variable name="y2" as="xs:double" select="$line[2 * ($index + 1)]"/>
            <variable name="x3" as="xs:double" select="$line[2 * ($index + 2) - 1]"/>
            <variable name="y3" as="xs:double" select="$line[2 * ($index + 2)]"/>
            
            <variable name="segment_angle" as="xs:double" select="ma:angle-between-segments(($x1, $y1, $x2, $y2), ($x2, $y2, $x3, $y3))"/>
            <if test="$segment_angle lt 135">
                <sequence select="ma:create-gml-line(($x1, $y1, $x2, $y2, $x3, $y3), 2, 28992)"/>    
            </if>
        </for-each> 
    </function>
    
    <function name="ma:angle-between-segments" as="xs:double">
        <param name="segment_1" as="xs:double*"/>
        <param name="segment_2" as="xs:double*"/>
        
        <variable name="vx1" select="$segment_1[1] - $segment_1[3]"/>
        <variable name="vy1" select="$segment_1[2] - $segment_1[4]"/>
        <variable name="vx2" select="$segment_2[3] - $segment_2[1]"/>
        <variable name="vy2" select="$segment_2[4] - $segment_2[2]"/>
        
        <variable name="dot_product" select="$vx1 * $vx2 + $vy1 * $vy2"/>
        
        <variable name="length_v1" select="math:sqrt($vx1 * $vx1 + $vy1 * $vy1)"/>
        <variable name="length_v2" select="math:sqrt($vx2 * $vx2 + $vy2 * $vy2)"/>
        
        <variable name="radian" select="math:acos($dot_product div ($length_v1 * $length_v2))"/>
        
        <value-of select="$radian * 180 div math:pi()"/>
    </function>
    
    <function name="ma:point-connected-to-point" as="xs:boolean">
        <param name="point_1" as="xs:double*"/>
        <param name="point_2" as="xs:double*"/>
        
        <value-of select="$point_1[1] = $point_2[1] and $point_1[2] = $point_2[2]"/>
    </function>
    
    <function name="ma:point-touches-area" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        
        <value-of select="ma:point-touches-line($point, $area)"/>
    </function>
    
    <function name="ma:point-touches-line" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        
        <value-of select="ma:point-on-line($point, $line)"/>
    </function>
    
    <function name="ma:point-on-line" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        
        <sequence select="
                some $index in 1 to (count($line) idiv 2) - 1 
                satisfies 
                    ma:point-on-segment($point, (
                        $line[2 * $index - 1],
                        $line[2 * $index],
                        $line[2 * $index + 1],
                        $line[2 * $index + 2]
                    ))
                "/>
    </function>
    
    <function name="ma:point-on-segment" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="segment" as="xs:double*"/>
        
        <variable name="segment_length" as="xs:double" select="ma:point-2d-to-point-2d-distance(($segment[1], $segment[2]), ($segment[3], $segment[4]))"/>
        <variable name="start_to_point_distance" as="xs:double" select="ma:point-2d-to-point-2d-distance(($point[1], $point[2]), ($segment[1], $segment[2]))"/>
        <variable name="end_to_point_distance" as="xs:double" select="ma:point-2d-to-point-2d-distance(($point[1], $point[2]), ($segment[3], $segment[4]))"/>
        
        <value-of select="$segment_length = $start_to_point_distance + $end_to_point_distance"/>
    </function>
</stylesheet>
