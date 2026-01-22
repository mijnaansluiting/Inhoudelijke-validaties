<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:ma="http://example.com/mijnaansluiting"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	        version="3.0">
    
    <function name="ma:point-connected-to-point" as="xs:boolean">
        <param name="point_1" as="xs:double*"/>
        <param name="point_2" as="xs:double*"/>
        
        <sequence select="ma:point-distance-to-point($point_1, $point_2) = 0"/>
    </function>
    
    <function name="ma:point-touches-line" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        
        <sequence select="ma:point-on-line($point, $line)"/>
    </function>
    
    <function name="ma:point-on-line" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        
        <sequence select="
                    some $index in 1 to (count($line) idiv 2) - 1 
                    satisfies 
                        ma:point-on-segment(
                            $point, 
                            ma:line-get-slice($line, $index, $index + 1)
                        )"/>
    </function>
    
    <function name="ma:point-on-segment" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="segment" as="xs:double*"/>
        
        <variable name="start_point" as="xs:double*" select="ma:line-get-nth-point($segment, 1)"/>
        <variable name="end_point" as="xs:double*" select="ma:line-get-nth-point($segment, 2)"/>
        
        <variable name="segment_length" as="xs:double" select="ma:point-distance-to-point($start_point, $end_point)"/>
        <variable name="start_to_point_distance" as="xs:double" select="ma:point-distance-to-point($start_point, $point)"/>
        <variable name="end_to_point_distance" as="xs:double" select="ma:point-distance-to-point($end_point, $point)"/>
        
        <sequence select="$segment_length = $start_to_point_distance + $end_to_point_distance"/>
    </function>
    
    <function name="ma:point-touches-area" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        
        <sequence select="ma:point-touches-line($point, $area)"/>
    </function>
    
    <function name="ma:point-interacts-with-area" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        
        <variable name="area_x" select="$area[position() mod 2 = 1]" as="xs:double*"/>
        <variable name="area_y" select="$area[position() mod 2 = 0]" as="xs:double*"/>
        <variable name="area_point_count" select="count($area_x) - 1"/>
        
        <variable name="point_x" select="$point[1]"/>
        <variable name="point_y" select="$point[2]"/>
        
        <variable name="intersections" as="xs:integer*">
            <for-each select="1 to $area_point_count">
                <variable name="i" select="."/>
                <variable name="j" select="if ($i = 1) then $area_point_count else $i - 1"/>
                
                <variable name="area_point_1" select="ma:line-get-nth-point($area, $i)"/>
                <variable name="area_point_2" select="ma:line-get-nth-point($area, $j)"/>
                
                <variable name="area_point_1_x" select="$area_point_1[1]"/>
                <variable name="area_point_1_y" select="$area_point_1[2]"/>
                <variable name="area_point_2_x" select="$area_point_2[1]"/>
                <variable name="area_point_2_y" select="$area_point_2[2]"/>
                
                <if test="($area_point_1_y gt $point_y) != ($area_point_2_y gt $point_y)">
                    <variable name="x_intersect"
                              select="($area_point_2_x - $area_point_1_x) * ($point_y - $area_point_1_y) div ($area_point_2_y - $area_point_1_y) + $area_point_1_x"/>
                    <if test="$point_x lt $x_intersect">
                        <sequence select="1"/>
                    </if>
                </if>
            </for-each>
        </variable>
        
        <sequence select="count($intersections) mod 2 = 1"/>
    </function>
    
    <function name="ma:point-relative-orientation-to-segment" as="xs:integer">
        <param name="point" as="xs:double*"/>
        <param name="segment" as="xs:double*"/>
        
        <variable name="segment_start" as="xs:double*" select="ma:line-get-nth-point($segment, 1)"/>
        <variable name="segment_end" as="xs:double*" select="ma:line-get-nth-point($segment, 2)"/>
        
        <variable name="cross_product" select="
                    ($segment_end[2] - $segment_start[2]) * ($point[1] - $segment_end[1]) -
                    ($segment_end[1] - $segment_start[1]) * ($point[2] - $segment_end[2])"/>
        
        <sequence select="
                    if ($cross_product = 0) then 0
                    else if ($cross_product &gt; 0) then 1
                    else 2"/>
    </function>
    
    <function name="ma:point-distance-to-point" as="xs:double">
        <param name="point_1" as="xs:double*"/>
        <param name="point_2" as="xs:double*"/>
        
        <variable name="dx" select="$point_1[1] - $point_2[1]"/>
        <variable name="dy" select="$point_1[2] - $point_2[2]"/>
        <variable name="distance_squared" select="($dx * $dx) + ($dy * $dy)"/>
        <variable name="distance" select="math:sqrt($distance_squared)"/>
        <sequence select="$distance"/>
    </function>
    
    <function name="ma:line-segments-not-meeting-length-demands" as="node()*">
        <param name="line" as="xs:double*"/>
        
        <for-each select="1 to (count($line) idiv 2) - 1">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="point_1" as="xs:double*" select="ma:line-get-nth-point($line, $index)"/>
            <variable name="point_2" as="xs:double*" select="ma:line-get-nth-point($line, $index + 1)"/>
            
            <variable name="segment_length" as="xs:double" select="ma:point-distance-to-point($point_1, $point_2)"/>
            <if test="$segment_length le 0.1 or $segment_length ge 50">
                <sequence select="
                            ma:create-gml-line(
                                ($point_1, 0, $point_2, 0), 
                                3, 
                                7415
                            )"/>    
            </if>
        </for-each> 
    </function>
    
    <function name="ma:line-segments-not-meeting-angle-demands" as="node()*">
        <param name="line" as="xs:double*"/>      
        
        <for-each select="1 to (count($line) idiv 2) - 2">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="point_1" as="xs:double*" select="ma:line-get-nth-point($line, $index)"/>
            <variable name="point_2" as="xs:double*" select="ma:line-get-nth-point($line, $index + 1)"/>
            <variable name="point_3" as="xs:double*" select="ma:line-get-nth-point($line, $index + 2)"/>
            
            <variable name="segment_angle" as="xs:double" select="
                        ma:segment-angle-between-segment(
                            ($point_1, $point_2), 
                            ($point_2, $point_3) 
                        )"/>
            <if test="$segment_angle lt 135">
                <sequence select="
                            ma:create-gml-line(
                                ($point_1, 0, $point_2, 0, $point_3, 0), 
                                3, 
                                7415
                            )"/>    
            </if>
        </for-each> 
    </function>
    
    <function name="ma:line-interacts-with-area" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        
        <variable name="area_point_count" select="count($area) idiv 2"/>
        <variable name="line_point_count" select="count($line) idiv 2"/>
        
        <variable name="any_point_inside" select="
                    some $i in 1 to $line_point_count - 1
                    satisfies ma:point-interacts-with-area(
                        ma:line-get-nth-point($line, $i), 
                        $area
                    )"/>
        <choose>
            <when test="$any_point_inside">
                <sequence select="true()"/>
            </when>
            <otherwise>
                <sequence select="
                            some $line_index in 1 to $line_point_count - 1
                            satisfies 
                                some $area_index in 1 to $area_point_count - 1
                                satisfies ma:segment-intersects-segment(
                                    ma:line-get-slice($line, $line_index, $line_index + 1),
                                    ma:line-get-slice($area, $area_index, $area_index + 1)
                                )"/>
            </otherwise>
        </choose>
    </function>
    
    <function name="ma:area-interacts-with-area" as="xs:boolean">
        <param name="area_1" as="xs:double*"/>
        <param name="area_2" as="xs:double*"/>
        
        <sequence select="
                    ma:line-interacts-with-area($area_1, $area_2)
                    or
                    ma:line-interacts-with-area($area_2, $area_1)"/>
    </function>
    
    <function name="ma:segment-angle-between-segment" as="xs:double">
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
        
        <sequence select="$radian * 180 div math:pi()"/>
    </function>
    
    <function name="ma:segment-intersects-segment" as="xs:boolean">
        <param name="segment_1" as="xs:double*"/>
        <param name="segment_2" as="xs:double*"/>
        
        <variable name="segment_1_start" as="xs:double*" select="ma:line-get-nth-point($segment_1, 1)"/>
        <variable name="segment_1_end" as="xs:double*" select="ma:line-get-nth-point($segment_1, 2)"/>
        <variable name="segment_2_start" as="xs:double*" select="ma:line-get-nth-point($segment_2, 1)"/>
        <variable name="segment_2_end" as="xs:double*" select="ma:line-get-nth-point($segment_2, 2)"/>
        
        <variable name="relative_orientation_segment_1_start" select="ma:point-relative-orientation-to-segment($segment_1_start, $segment_2)"/>
        <variable name="relative_orientation_segment_1_end" select="ma:point-relative-orientation-to-segment($segment_1_end, $segment_2)"/>
        <variable name="relative_orientation_segment_2_start" select="ma:point-relative-orientation-to-segment($segment_2_start, $segment_1)"/>
        <variable name="relative_orientation_segment_2_end" select="ma:point-relative-orientation-to-segment($segment_2_end, $segment_1)"/>
        
        <sequence select="
                    $relative_orientation_segment_1_start != $relative_orientation_segment_1_end 
                    and
                    $relative_orientation_segment_2_start != $relative_orientation_segment_2_end"/>
    </function>
</stylesheet>
