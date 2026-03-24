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
    
    <function name="ma:point-connected-to-point-alt" as="xs:boolean">
        <param name="point_1" as="node()"/>
        <param name="point_2" as="node()"/>
        
        <sequence select="ma:point-distance-to-point-alt($point_1, $point_2) = 0"/>
    </function>
    
    <function name="ma:point-touches-line" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        
        <sequence select="ma:point-on-line($point, $line)"/>
    </function>
    
    <function name="ma:point-touches-line-alt" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="line" as="node()*"/>
        
        <sequence select="ma:point-on-line-alt($point, $line)"/>
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
    
    <function name="ma:point-on-line-alt" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="line" as="node()*"/>
        
        <sequence select="some $index in 1 to count($line) - 1 satisfies ma:point-on-segment-alt($point, subsequence($line, $index, 2))"/>
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
    
    <function name="ma:point-on-segment-alt" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="segment" as="node()*"/>
        
        <variable name="start_to_point_distance" select="ma:point-distance-to-point-alt($segment[1], $point)"/>
        <variable name="end_to_point_distance" select="ma:point-distance-to-point-alt($segment[2], $point)"/>
        
        <sequence select="$start_to_point_distance + $end_to_point_distance = ma:segment-length-alt($segment)"/>
    </function>
    
    <function name="ma:point-touches-area" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        
        <sequence select="ma:point-touches-line($point, $area)"/>
    </function>
    
    <function name="ma:point-touches-area-alt" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="area" as="node()*"/>
        
        <sequence select="ma:point-touches-line-alt($point, $area)"/>
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
    
    <function name="ma:point-interacts-with-area-alt" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="area" as="node()*"/>
        
        <variable name="intersections" as="xs:integer*">
            <for-each select="1 to count($area) - 1">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($area, $index, 2)"/>
                
                <if test="(xs:double($segment[1]/ma:Y) gt xs:double($point/ma:Y)) != (xs:double($segment[2]/ma:Y) gt xs:double($point/ma:Y))">
                    <variable name="x_intersect" select="($segment[2]/ma:X - $segment[1]/ma:X) * ($point/ma:Y - $segment[1]/ma:Y) div ($segment[2]/ma:Y - $segment[1]/ma:Y) + $segment[1]/ma:X"/>
                    <if test="xs:double($point/ma:X) lt $x_intersect">
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
    
    <function name="ma:point-relative-orientation-to-segment-alt" as="xs:integer">
        <param name="point" as="node()"/>
        <param name="segment" as="node()*"/>
        
        <variable name="cross_product" select="
                    ($segment[2]/ma:Y - $segment[1]/ma:Y) * ($point/ma:X - $segment[2]/ma:X) -
                    ($segment[2]/ma:X - $segment[1]/ma:X) * ($point/ma:Y - $segment[2]/ma:Y)"/>
        
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
    
    <function name="ma:point-distance-to-point-alt" as="xs:double">
        <param name="point_1" as="node()"/>
        <param name="point_2" as="node()"/>
        
        <variable name="dx" select="$point_1/ma:X - $point_2/ma:X"/>
        <variable name="dy" select="$point_1/ma:Y - $point_2/ma:Y"/>
        <variable name="distance_squared" select="($dx * $dx) + ($dy * $dy)"/>
        <variable name="distance" select="math:sqrt($distance_squared)"/>
        <sequence select="$distance"/>
    </function>
    
    <function name="ma:segment-length-alt" as="xs:double">
        <param name="segment" as="node()*"/>
        
        <sequence select="ma:point-distance-to-point-alt($segment[1], $segment[2])"/>
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
    
    <function name="ma:line-segments-not-meeting-length-demands-alt" as="node()*">
        <param name="line" as="node()*"/>
        
        <for-each select="1 to count($line) - 1">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="segment" select="subsequence($line, $index, 2)"/>
            
            <variable name="segment_length" as="xs:double" select="ma:segment-length-alt($segment)"/>
            
            <if test="$segment_length le 0.1 or $segment_length ge 50">
                <sequence select="ma:create-gml-line-alt($segment)"/>    
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
    
    <function name="ma:line-segments-not-meeting-angle-demands-alt" as="node()*">
        <param name="line" as="node()*"/>      
        
        <for-each select="1 to count($line) - 2">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="segment_1" select="subsequence($line, $index, 2)"/>
            <variable name="segment_2" select="subsequence($line, $index + 1, 2)"/>
            
            <variable name="segment_angle" select="ma:segment-angle-between-segment-alt($segment_1, $segment_2)"/>
            
            <if test="$segment_angle lt 135">
                <sequence select="ma:create-gml-line-alt(subsequence($line, $index, 3))"/>    
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
    
    <function name="ma:line-interacts-with-area-alt" as="xs:boolean">
        <param name="line" as="node()*"/>
        <param name="area" as="node()*"/>
        
        <choose>
            <when test="some $point in $line satisfies ma:point-interacts-with-area-alt($point, $area)">
                <sequence select="true()"/>
            </when>
            <otherwise>
                <sequence select="
                            some $line_index in 1 to count($line) - 1
                            satisfies 
                                some $area_index in 1 to count($area) - 1
                                satisfies ma:segment-intersects-segment-alt(subsequence($line, $line_index, 2), subsequence($area, $area_index, 2))"/>
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
    
    <function name="ma:area-interacts-with-area-alt" as="xs:boolean">
        <param name="area_1" as="node()*"/>
        <param name="area_2" as="node()*"/>
        
        <sequence select="
                    ma:line-interacts-with-area-alt($area_1, $area_2)
                    or
                    ma:line-interacts-with-area-alt($area_2, $area_1)"/>
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
    
    <function name="ma:segment-angle-between-segment-alt" as="xs:double">
        <param name="segment_1" as="node()*"/>
        <param name="segment_2" as="node()*"/>
        
        <variable name="vx1" select="$segment_1[1]/ma:X - $segment_1[2]/ma:X"/>
        <variable name="vy1" select="$segment_1[1]/ma:Y - $segment_1[2]/ma:Y"/>
        <variable name="vx2" select="$segment_2[2]/ma:X - $segment_2[1]/ma:X"/>
        <variable name="vy2" select="$segment_2[2]/ma:Y - $segment_2[1]/ma:Y"/>
        
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
    
    <function name="ma:segment-intersects-segment-alt" as="xs:boolean">
        <param name="segment_1" as="node()*"/>
        <param name="segment_2" as="node()*"/>
        
        <variable name="relative_orientation_segment_1_start" select="ma:point-relative-orientation-to-segment-alt($segment_1[1], $segment_2)"/>
        <variable name="relative_orientation_segment_1_end" select="ma:point-relative-orientation-to-segment-alt($segment_1[2], $segment_2)"/>
        <variable name="relative_orientation_segment_2_start" select="ma:point-relative-orientation-to-segment-alt($segment_2[1], $segment_1)"/>
        <variable name="relative_orientation_segment_2_end" select="ma:point-relative-orientation-to-segment-alt($segment_2[2], $segment_1)"/>
        
        <sequence select="
                    $relative_orientation_segment_1_start != $relative_orientation_segment_1_end 
                    and
                    $relative_orientation_segment_2_start != $relative_orientation_segment_2_end"/>
    </function>
    
    <function name="ma:point-get-orthogonal-segment">
        <param name="point" as="xs:double*"/>
        <param name="direction_point" as="xs:double*"/>
        <param name="buffer_distance" as="xs:double"/>
        
        <variable name="segment_length" as="xs:double" select="ma:point-distance-to-point($point, $direction_point)"/>
        
        <variable name="dx" select="$direction_point[1] - $point[1]"/>
        <variable name="dy" select="$direction_point[2] - $point[2]"/>
        
        <variable name="ux" select="-$dy div $segment_length"/>
        <variable name="uy" select="$dx div $segment_length"/>
        
        <sequence select="($point[1] + $buffer_distance * $ux, $point[2] + $buffer_distance * $uy, $point[1] - $buffer_distance * $ux, $point[2] - $buffer_distance * $uy)"/>
    </function>
    
    <!-- Returns an orthogonal segment from the first point of the segment with a given buffer distance from the first point -->
    <function name="ma:point-get-orthogonal-segment-alt" as="node()*">
        <param name="segment" as="node()*"/>
        <param name="buffer_distance" as="xs:double"/>
        
        <variable name="segment_length" select="ma:segment-length-alt($segment)"/>
        
        <variable name="dx" select="$segment[2]/ma:X - $segment[1]/ma:X"/>
        <variable name="dy" select="$segment[2]/ma:Y - $segment[1]/ma:Y"/>
        
        <variable name="ux" select="-$dy div $segment_length"/>
        <variable name="uy" select="$dx div $segment_length"/>
        
        <sequence>
            <ma:Coord>
                <ma:X><value-of select="$segment[1]/ma:X + $buffer_distance * $ux"/></ma:X>
                <ma:Y><value-of select="$segment[1]/ma:Y + $buffer_distance * $uy"/></ma:Y>
            </ma:Coord>
            <ma:Coord>
                <ma:X><value-of select="$segment[1]/ma:X - $buffer_distance * $ux"/></ma:X>
                <ma:Y><value-of select="$segment[1]/ma:Y - $buffer_distance * $uy"/></ma:Y>
            </ma:Coord>
        </sequence>
    </function>
    
    <function name="ma:line-within-range-of-line" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="control_line" as="xs:double*"/>
        <param name="range" as="xs:double"/>
        
        <variable name="line_buffer" select="ma:buffer-line($line, $range)"/>
        
        <variable name="check_step" select="0.5"/>
        
        <variable name="control_line_within_bounds" as="xs:boolean*">
            <for-each select="1 to (count($control_line) idiv 2) - 1">
                <variable name="control_line_segment_index" select="."/>
                <variable name="control_line_segment_start" select="ma:line-get-nth-point($control_line, $control_line_segment_index)"/>   
                <variable name="control_line_segment_end" select="ma:line-get-nth-point($control_line, $control_line_segment_index + 1)"/>   

                <variable name="control_line_segment_length" as="xs:double" select="ma:point-distance-to-point($control_line_segment_start, $control_line_segment_end)"/>
                
                <variable name="dx" select="$control_line_segment_end[1] - $control_line_segment_start[1]"/>
                <variable name="dy" select="$control_line_segment_end[2] - $control_line_segment_start[2]"/>
                
                <variable name="points_in_segment" select="xs:integer(ceiling($control_line_segment_length div $check_step))"/>
                <variable name="distance_between_points" select="$control_line_segment_length div $points_in_segment"/>
                <variable name="scaling_factor" select="$distance_between_points div $control_line_segment_length"/>
                
                <variable name="points_to_check">
                    <choose>
                        <when test="$control_line_segment_index = last()">
                            <sequence select="$points_in_segment + 1"/>    
                        </when>
                        <otherwise>
                            <sequence select="$points_in_segment"/>
                        </otherwise>
                    </choose>
                </variable>

                <for-each select="1 to $points_to_check">
                    <variable name="point_index" select="."/>
                    <variable name="point" as="xs:double*">
                        <choose>
                            <when test="$point_index = 1">
                                <sequence select="$control_line_segment_start"/>    
                            </when>
                            <when test="$point_index = last() and $control_line_segment_index = last()">
                                <sequence select="$control_line_segment_end"/>    
                            </when>
                            <otherwise>
                                <variable name="point_x" select="$control_line_segment_start[1] + $scaling_factor * ($point_index - 1) * $dx"/>
                                <variable name="point_y" select="$control_line_segment_start[2] + $scaling_factor * ($point_index - 1) * $dy"/>
                                <sequence select="$point_x, $point_y"/>
                            </otherwise>
                        </choose>    
                    </variable>
                    
                    <sequence select="ma:point-interacts-with-area($point, $line_buffer)"/>
                </for-each>
            </for-each>
        </variable>
        
        <sequence select="not($control_line_within_bounds = false())"/>
    </function>
        
    <function name="ma:line-within-range-of-line-alt" as="xs:boolean">
        <param name="line" as="node()*"/>
        <param name="control_line" as="node()*"/>
        <param name="range" as="xs:double"/>
        
        <variable name="line_buffer" select="ma:buffer-line-alt($line, $range)"/>
               
        <variable name="check_step" select="0.5"/>
        
        <variable name="control_line_within_bounds" as="xs:boolean*">
            <for-each select="1 to count($control_line) - 1">
                <variable name="segment_index" select="."/>
                <variable name="segment" select="subsequence($control_line, $segment_index, 2)"/>

                <variable name="segment_length" select="ma:segment-length-alt($segment)"/>
                
                <variable name="dx" select="$segment[2]/ma:X - $segment[1]/ma:X"/>
                <variable name="dy" select="$segment[2]/ma:Y - $segment[1]/ma:Y"/>
                
                <variable name="points_in_segment" select="xs:integer(ceiling($segment_length div $check_step))"/>
                <variable name="distance_between_points" select="$segment_length div $points_in_segment"/>
                <variable name="scaling_factor" select="$distance_between_points div $segment_length"/>
                
                <variable name="is_last_segment" select="$segment_index = last()"/>
                <variable name="points_to_check" select="if($is_last_segment) then $points_in_segment + 1 else $points_in_segment"/>
                
                <for-each select="1 to $points_to_check">
                    <variable name="point_index" select="."/>
                    <variable name="point" as="node()">
                        <choose>
                            <when test="$point_index = 1">
                                <sequence select="$segment[1]"/>
                            </when>
                            <when test="$point_index = last() and $is_last_segment">
                                <sequence select="$segment[2]"/>
                            </when>
                            <otherwise>
                                <variable name="point_x" select="$segment[1]/ma:X + $scaling_factor * ($point_index - 1) * $dx"/>
                                <variable name="point_y" select="$segment[1]/ma:Y + $scaling_factor * ($point_index - 1) * $dy"/>
                                <sequence>
                                    <ma:Coord>
                                        <ma:X><value-of select="$point_x"/></ma:X>
                                        <ma:Y><value-of select="$point_y"/></ma:Y>
                                    </ma:Coord>
                                </sequence>
                            </otherwise>
                        </choose>    
                    </variable>
                    
                    <sequence select="ma:point-interacts-with-area-alt($point, $line_buffer)"/>
                </for-each>
            </for-each>
        </variable>
        
        <sequence select="not($control_line_within_bounds = false())"/>
    </function>
        
    <function name="ma:intersection-of-segments" as="xs:double*">
        <param name="segment_1" as="xs:double*"/>
        <param name="segment_2" as="xs:double*"/>
        
        <variable name="den" select="
                    ($segment_1[1] - $segment_1[3]) * ($segment_2[2] - $segment_2[4]) -
                    ($segment_1[2] - $segment_1[4]) * ($segment_2[1] - $segment_2[3])"/>
        
        <if test="$den ne 0">
            <variable name="t" select="
                        (($segment_1[1] - $segment_2[1]) * ($segment_2[2] - $segment_2[4]) - 
                        ($segment_1[2] - $segment_2[2]) * ($segment_2[1] - $segment_2[3])) div $den"/>
            <variable name="u" select="
                        (($segment_1[1] - $segment_2[1]) * ($segment_1[2] - $segment_1[4]) - 
                        ($segment_1[2] - $segment_2[2]) * ($segment_1[1] - $segment_1[3])) div $den"/>
            
            <variable name="intersect_x" select="$segment_1[1] + $t * ($segment_1[3] - $segment_1[1])"/>
            <variable name="intersect_y" select="$segment_1[2] + $t * ($segment_1[4] - $segment_1[2])"/>
            <sequence select="($intersect_x, $intersect_y)"/>
        </if>
    </function>
        
    <function name="ma:intersection-of-segments-alt" as="node()?">
        <param name="segment_1" as="node()*"/>
        <param name="segment_2" as="node()*"/>
        
        <variable name="den" select="
                    ($segment_1[1]/ma:X - $segment_1[2]/ma:X) * ($segment_2[1]/ma:Y - $segment_2[2]/ma:Y) -
                    ($segment_1[1]/ma:Y - $segment_1[2]/ma:Y) * ($segment_2[1]/ma:X - $segment_2[2]/ma:X)"/>
        
        <if test="$den ne 0">
            <variable name="scaling_factor" select="
                        (($segment_1[1]/ma:X - $segment_2[1]/ma:X) * ($segment_2[1]/ma:Y - $segment_2[2]/ma:Y) - 
                        ($segment_1[1]/ma:Y - $segment_2[1]/ma:Y) * ($segment_2[1]/ma:X - $segment_2[2]/ma:X)) div $den"/>
            
            <variable name="intersect_x" select="$segment_1[1]/ma:X + $scaling_factor * ($segment_1[2]/ma:X - $segment_1[1]/ma:X)"/>
            <variable name="intersect_y" select="$segment_1[1]/ma:Y + $scaling_factor * ($segment_1[2]/ma:Y - $segment_1[1]/ma:Y)"/>
            <sequence>
                <ma:Coord>
                    <ma:X><value-of select="$intersect_x"/></ma:X>
                    <ma:Y><value-of select="$intersect_y"/></ma:Y>
                </ma:Coord>
            </sequence>
        </if>
    </function>
    
    <function name="ma:buffer-line" as="xs:double*">
        <param name="line" as="xs:double*"/>
        <param name="buffer_distance" as="xs:double"/>
        
        <variable name="segment_count" select="(count($line) idiv 2) - 1"/>
        
        <variable name="left_bounds_segments" as="xs:double*">
            <for-each select="1 to $segment_count">
                <variable name="segment_index" select="."/>
                <variable name="segment_start" select="ma:line-get-nth-point($line, $segment_index)"/>
                <variable name="segment_end" select="ma:line-get-nth-point($line, $segment_index + 1)"/>
                <variable name="segment_length" select="ma:point-distance-to-point($segment_start, $segment_end)"/>
                <variable name="start_segment" select="ma:point-get-orthogonal-segment($segment_start, $segment_end, $buffer_distance)"/>
                <variable name="end_segment" select="ma:point-get-orthogonal-segment($segment_end, $segment_start, $buffer_distance)"/>
                
                <sequence select="$start_segment[3], $start_segment[4], $end_segment[1], $end_segment[2]"/>
            </for-each>
        </variable>
        
        <variable name="right_bounds_segments" as="xs:double*">
            <for-each select="1 to $segment_count">
                <variable name="segment_index" select="."/>
                <variable name="segment_start" select="ma:line-get-nth-point($line, $segment_index)"/>
                <variable name="segment_end" select="ma:line-get-nth-point($line, $segment_index + 1)"/>
                <variable name="segment_length" select="ma:point-distance-to-point($segment_start, $segment_end)"/>
                <variable name="start_segment" select="ma:point-get-orthogonal-segment($segment_start, $segment_end, $buffer_distance)"/>
                <variable name="end_segment" select="ma:point-get-orthogonal-segment($segment_end, $segment_start, $buffer_distance)"/>
                
                <sequence select="$start_segment[1], $start_segment[2], $end_segment[3], $end_segment[4]"/>
            </for-each>
        </variable>
        
        <variable name="left_bounds" as="xs:double*">
            <for-each select="1 to $segment_count">
                <variable name="segment_index" select=". * 2 - 1"/>
                <variable name="left_bound_segment" select="ma:line-get-slice($left_bounds_segments, $segment_index, $segment_index + 1)"/>
                <variable name="left_bound_next_segment" select="ma:line-get-slice($left_bounds_segments, $segment_index + 2, $segment_index + 3)"/>
                
                <if test=". = 1">
                    <sequence select="$left_bound_segment[1], $left_bound_segment[2]"/>                
                </if>
                <sequence select="ma:intersection-of-segments($left_bound_segment, $left_bound_next_segment)"/>
                <if test=". = last()">
                    <sequence select="$left_bound_segment[3], $left_bound_segment[4]"/>                
                </if>
            </for-each>
        </variable>
        
        <variable name="right_bounds" as="xs:double*">    
            <for-each select="1 to $segment_count">
                <variable name="segment_index" select=". * 2 - 1"/>
                <variable name="right_bound_segment" select="ma:line-get-slice($right_bounds_segments, $segment_index, $segment_index + 1)"/>
                <variable name="right_bound_next_segment" select="ma:line-get-slice($right_bounds_segments, $segment_index + 2, $segment_index + 3)"/>
                
                <if test=". = 1">
                    <sequence select="$right_bound_segment[1], $right_bound_segment[2]"/>                
                </if>
                <sequence select="ma:intersection-of-segments($right_bound_segment, $right_bound_next_segment)"/>
                <if test=". = last()">
                    <sequence select="$right_bound_segment[3], $right_bound_segment[4]"/>                
                </if>
            </for-each>
        </variable>
        
        <for-each select="1 to $segment_count + 1">
            <sequence select="ma:line-get-nth-point($left_bounds, .)"/>    
        </for-each>
        <for-each select="0 to $segment_count + 1">
            <variable name="reverse_index" select="$segment_count + 1 - ."/>
            <sequence select="ma:line-get-nth-point($right_bounds, $reverse_index)"/>    
        </for-each>
        <sequence select="ma:line-get-nth-point($left_bounds, 1)"/>
    </function>
    
    <function name="ma:buffer-line-alt" as="node()*">
        <param name="line" as="node()*"/>
        <param name="buffer_distance" as="xs:double"/>
        
        <variable name="segment_count" select="count($line) - 1"/>
        
        <variable name="left_bounds_segments" as="node()*">
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($line, $index, 2)"/>             
                <variable name="orthogonal_start_segment" select="ma:point-get-orthogonal-segment-alt($segment, $buffer_distance)"/>
                <variable name="orthogonal_end_segment" select="ma:point-get-orthogonal-segment-alt(reverse($segment), $buffer_distance)"/>
                
                <sequence select="$orthogonal_start_segment[2], $orthogonal_end_segment[1]"/>
            </for-each>
        </variable>
        
        <variable name="right_bounds_segments" as="node()*">
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($line, $index, 2)"/>             
                <variable name="orthogonal_start_segment" select="ma:point-get-orthogonal-segment-alt($segment, $buffer_distance)"/>
                <variable name="orthogonal_end_segment" select="ma:point-get-orthogonal-segment-alt(reverse($segment), $buffer_distance)"/>
                
                <sequence select="$orthogonal_start_segment[1], $orthogonal_end_segment[2]"/>
            </for-each>
        </variable>
        
        <variable name="left_bounds" as="node()*">
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="compensated_index" select="$index * 2 - 1"/>
                <variable name="bound_segment" select="subsequence($left_bounds_segments, $compensated_index, 2)"/>
                <variable name="bound_next_segment" select="subsequence($left_bounds_segments, $compensated_index + 2, 2)"/>
                
                <if test="$index = 1">
                    <sequence select="$bound_segment[1]"/>                
                </if>
                <sequence select="ma:intersection-of-segments-alt($bound_segment, $bound_next_segment)"/>
                <if test="$index = last()">
                    <sequence select="$bound_segment[2]"/>                
                </if>
            </for-each>
        </variable>
        
        <variable name="right_bounds" as="node()*">    
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="compensated_index" select="$index * 2 - 1"/>
                <variable name="bound_segment" select="subsequence($right_bounds_segments, $compensated_index, 2)"/>
                <variable name="bound_next_segment" select="subsequence($right_bounds_segments, $compensated_index + 2, 2)"/>
                
                <if test="$index = 1">
                    <sequence select="$bound_segment[1]"/>                
                </if>
                <sequence select="ma:intersection-of-segments-alt($bound_segment, $bound_next_segment)"/>
                <if test="$index = last()">
                    <sequence select="$bound_segment[2]"/>                
                </if>
            </for-each>
        </variable>
        
        <sequence select="$left_bounds"/>    
        <sequence select="reverse($right_bounds)"/>    
        <sequence select="$left_bounds[1]"/>
    </function>
</stylesheet>
