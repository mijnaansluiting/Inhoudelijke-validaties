<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:ma="http://example.com/mijnaansluiting"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	        version="3.0">
    
    <function name="ma:point-connected-to-point" as="xs:boolean">
        <param name="point_1" as="node()"/>
        <param name="point_2" as="node()"/>
        
        <sequence select="ma:point-distance-to-point($point_1, $point_2) = 0"/>
    </function>
    
    <function name="ma:point-touches-line" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="line" as="node()*"/>
        
        <sequence select="ma:point-on-line($point, $line)"/>
    </function>
    
    <function name="ma:point-on-line" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="line" as="node()*"/>
        
        <sequence select="some $index in 1 to count($line) - 1 satisfies ma:point-on-segment($point, subsequence($line, $index, 2))"/>
    </function>
    
    <function name="ma:point-on-segment" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="segment" as="node()*"/>
        
        <variable name="start_to_point_distance" select="ma:point-distance-to-point($segment[1], $point)"/>
        <variable name="end_to_point_distance" select="ma:point-distance-to-point($segment[2], $point)"/>
        
        <sequence select="$start_to_point_distance + $end_to_point_distance = ma:segment-length($segment)"/>
    </function>
    
    <function name="ma:point-touches-area" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="area" as="node()*"/>
        
        <sequence select="ma:point-touches-line($point, $area)"/>
    </function>
    
    <function name="ma:point-interacts-with-area" as="xs:boolean">
        <param name="point" as="node()"/>
        <param name="area" as="node()*"/>
        
        <variable name="intersections" as="xs:integer*">
            <for-each select="1 to count($area) - 1">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($area, $index, 2)"/>
                
                <if test="(xs:double($segment[1]/Y) gt xs:double($point/Y)) != (xs:double($segment[2]/Y) gt xs:double($point/Y))">
                    <variable name="x_intersect" select="($segment[2]/X - $segment[1]/X) * ($point/Y - $segment[1]/Y) div ($segment[2]/Y - $segment[1]/Y) + $segment[1]/X"/>
                    <if test="xs:double($point/X) lt $x_intersect">
                        <sequence select="1"/>
                    </if>
                </if>
            </for-each>
        </variable>

        <sequence select="count($intersections) mod 2 = 1"/>
    </function>
    
    <function name="ma:point-relative-orientation-to-segment" as="xs:integer">
        <param name="point" as="node()"/>
        <param name="segment" as="node()*"/>
        
        <variable name="cross_product" select="
                    ($segment[2]/Y - $segment[1]/Y) * ($point/X - $segment[2]/X) -
                    ($segment[2]/X - $segment[1]/X) * ($point/Y - $segment[2]/Y)"/>
        
        <sequence select="
                    if ($cross_product = 0) then 0
                    else if ($cross_product &gt; 0) then 1
                    else 2"/>
    </function>
    
    <function name="ma:point-distance-to-point" as="xs:double">
        <param name="point_1" as="node()"/>
        <param name="point_2" as="node()"/>
        
        <variable name="dx" select="$point_1/X - $point_2/X"/>
        <variable name="dy" select="$point_1/Y - $point_2/Y"/>
        <variable name="distance_squared" select="($dx * $dx) + ($dy * $dy)"/>
        <variable name="distance" select="math:sqrt($distance_squared)"/>
        <sequence select="$distance"/>
    </function>
    
    <function name="ma:segment-length" as="xs:double">
        <param name="segment" as="node()*"/>
        
        <sequence select="ma:point-distance-to-point($segment[1], $segment[2])"/>
    </function>
    
    <function name="ma:line-segments-not-meeting-length-demands" as="node()*">
        <param name="line" as="node()*"/>
        
        <for-each select="1 to count($line) - 1">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="segment" select="subsequence($line, $index, 2)"/>
            
            <variable name="segment_length" as="xs:double" select="ma:segment-length($segment)"/>
            
            <if test="$segment_length le 0.1 or $segment_length ge 50">
                <sequence select="ma:create-gml-line($segment)"/>    
            </if>
         </for-each>
    </function>
    
    <function name="ma:line-segments-not-meeting-angle-demands" as="node()*">
        <param name="line" as="node()*"/>      
        
        <for-each select="1 to count($line) - 2">
            <variable name="index" as="xs:integer" select="."/>
            <variable name="segment_1" select="subsequence($line, $index, 2)"/>
            <variable name="segment_2" select="subsequence($line, $index + 1, 2)"/>
            
            <variable name="segment_angle" select="ma:segment-angle-between-segment($segment_1, $segment_2)"/>
            
            <if test="$segment_angle lt 135">
                <sequence select="ma:create-gml-line(subsequence($line, $index, 3))"/>    
            </if>
        </for-each> 
    </function>
    
    <function name="ma:line-interacts-with-area" as="xs:boolean">
        <param name="line" as="node()*"/>
        <param name="area" as="node()*"/>
        
        <choose>
            <when test="some $point in $line satisfies ma:point-interacts-with-area($point, $area)">
                <sequence select="true()"/>
            </when>
            <otherwise>
                <sequence select="
                            some $line_index in 1 to count($line) - 1
                            satisfies 
                                some $area_index in 1 to count($area) - 1
                                satisfies ma:segment-intersects-segment(subsequence($line, $line_index, 2), subsequence($area, $area_index, 2))"/>
            </otherwise>
        </choose>
    </function>
    
    <function name="ma:area-interacts-with-area" as="xs:boolean">
        <param name="area_1" as="node()*"/>
        <param name="area_2" as="node()*"/>
        
        <sequence select="
                    ma:line-interacts-with-area($area_1, $area_2)
                    or
                    ma:line-interacts-with-area($area_2, $area_1)"/>
    </function>
    
    <function name="ma:segment-angle-between-segment" as="xs:double">
        <param name="segment_1" as="node()*"/>
        <param name="segment_2" as="node()*"/>
        
        <variable name="vx1" select="$segment_1[1]/X - $segment_1[2]/X"/>
        <variable name="vy1" select="$segment_1[1]/Y - $segment_1[2]/Y"/>
        <variable name="vx2" select="$segment_2[2]/X - $segment_2[1]/X"/>
        <variable name="vy2" select="$segment_2[2]/Y - $segment_2[1]/Y"/>
        
        <variable name="dot_product" select="$vx1 * $vx2 + $vy1 * $vy2"/>
        
        <variable name="length_v1" select="math:sqrt($vx1 * $vx1 + $vy1 * $vy1)"/>
        <variable name="length_v2" select="math:sqrt($vx2 * $vx2 + $vy2 * $vy2)"/>
        
        <variable name="radian" select="math:acos($dot_product div ($length_v1 * $length_v2))"/>
        
        <sequence select="$radian * 180 div math:pi()"/>
    </function>
    
    <function name="ma:segment-intersects-segment" as="xs:boolean">
        <param name="segment_1" as="node()*"/>
        <param name="segment_2" as="node()*"/>
        
        <variable name="relative_orientation_segment_1_start" select="ma:point-relative-orientation-to-segment($segment_1[1], $segment_2)"/>
        <variable name="relative_orientation_segment_1_end" select="ma:point-relative-orientation-to-segment($segment_1[2], $segment_2)"/>
        <variable name="relative_orientation_segment_2_start" select="ma:point-relative-orientation-to-segment($segment_2[1], $segment_1)"/>
        <variable name="relative_orientation_segment_2_end" select="ma:point-relative-orientation-to-segment($segment_2[2], $segment_1)"/>
        
        <sequence select="
                    $relative_orientation_segment_1_start != $relative_orientation_segment_1_end 
                    and
                    $relative_orientation_segment_2_start != $relative_orientation_segment_2_end"/>
    </function>
    
    <!-- Returns an orthogonal segment from the first point of the segment with a given buffer distance from the first point -->
    <function name="ma:point-get-orthogonal-segment" as="node()*">
        <param name="segment" as="node()*"/>
        <param name="buffer_distance" as="xs:double"/>
        
        <variable name="segment_length" select="ma:segment-length($segment)"/>
        
        <variable name="dx" select="$segment[2]/X - $segment[1]/X"/>
        <variable name="dy" select="$segment[2]/Y - $segment[1]/Y"/>
        
        <variable name="ux" select="-$dy div $segment_length"/>
        <variable name="uy" select="$dx div $segment_length"/>
        
        <variable name="x_left" select="$segment[1]/X + $buffer_distance * $ux"/>
        <variable name="y_left" select="$segment[1]/Y + $buffer_distance * $uy"/>
        <variable name="x_right" select="$segment[1]/X - $buffer_distance * $ux"/>
        <variable name="y_right" select="$segment[1]/Y - $buffer_distance * $uy"/>
        
        <sequence select="ma:coord($x_left, $y_left), ma:coord($x_right, $y_right)"/>
    </function>
    
    <function name="ma:line-within-range-of-line" as="xs:boolean">
        <param name="line" as="node()*"/>
        <param name="control_line" as="node()*"/>
        <param name="range" as="xs:double"/>
        
        <variable name="line_buffer" select="ma:buffer-line($line, $range)"/>
               
        <variable name="check_step" select="0.5"/>
        
        <variable name="control_line_within_bounds" as="xs:boolean*">
            <for-each select="1 to count($control_line) - 1">
                <variable name="segment_index" select="."/>
                <variable name="segment" select="subsequence($control_line, $segment_index, 2)"/>

                <variable name="segment_length" select="ma:segment-length($segment)"/>
                
                <variable name="dx" select="$segment[2]/X - $segment[1]/X"/>
                <variable name="dy" select="$segment[2]/Y - $segment[1]/Y"/>
                
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
                                <variable name="point_x" select="$segment[1]/X + $scaling_factor * ($point_index - 1) * $dx"/>
                                <variable name="point_y" select="$segment[1]/Y + $scaling_factor * ($point_index - 1) * $dy"/>
                                <sequence select="ma:coord($point_x, $point_y)"/>
                            </otherwise>
                        </choose>    
                    </variable>
                    
                    <sequence select="ma:point-interacts-with-area($point, $line_buffer)"/>
                </for-each>
            </for-each>
        </variable>
        
        <sequence select="not($control_line_within_bounds = false())"/>
    </function>
        
    <function name="ma:intersection-of-segments" as="node()?">
        <param name="segment_1" as="node()*"/>
        <param name="segment_2" as="node()*"/>
        
        <variable name="den" select="
                    ($segment_1[1]/X - $segment_1[2]/X) * ($segment_2[1]/Y - $segment_2[2]/Y) -
                    ($segment_1[1]/Y - $segment_1[2]/Y) * ($segment_2[1]/X - $segment_2[2]/X)"/>
        
        <if test="$den ne 0">
            <variable name="scaling_factor" select="
                        (($segment_1[1]/X - $segment_2[1]/X) * ($segment_2[1]/Y - $segment_2[2]/Y) - 
                        ($segment_1[1]/Y - $segment_2[1]/Y) * ($segment_2[1]/X - $segment_2[2]/X)) div $den"/>
            
            <variable name="intersect_x" select="$segment_1[1]/X + $scaling_factor * ($segment_1[2]/X - $segment_1[1]/X)"/>
            <variable name="intersect_y" select="$segment_1[1]/Y + $scaling_factor * ($segment_1[2]/Y - $segment_1[1]/Y)"/>
            <sequence select="ma:coord($intersect_x, $intersect_y)"/>
        </if>
    </function>
    
    <function name="ma:buffer-line" as="node()*">
        <param name="line" as="node()*"/>
        <param name="buffer_distance" as="xs:double"/>
        
        <variable name="segment_count" select="count($line) - 1"/>
        
        <variable name="left_bounds_segments" as="node()*">
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($line, $index, 2)"/>             
                <variable name="orthogonal_start_segment" select="ma:point-get-orthogonal-segment($segment, $buffer_distance)"/>
                <variable name="orthogonal_end_segment" select="ma:point-get-orthogonal-segment(reverse($segment), $buffer_distance)"/>
                
                <sequence select="$orthogonal_start_segment[2], $orthogonal_end_segment[1]"/>
            </for-each>
        </variable>
        
        <variable name="right_bounds_segments" as="node()*">
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($line, $index, 2)"/>             
                <variable name="orthogonal_start_segment" select="ma:point-get-orthogonal-segment($segment, $buffer_distance)"/>
                <variable name="orthogonal_end_segment" select="ma:point-get-orthogonal-segment(reverse($segment), $buffer_distance)"/>
                
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
                <sequence select="ma:intersection-of-segments($bound_segment, $bound_next_segment)"/>
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
                <sequence select="ma:intersection-of-segments($bound_segment, $bound_next_segment)"/>
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
