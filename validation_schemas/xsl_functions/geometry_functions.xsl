<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:ma="http://example.com/mijnaansluiting"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	        version="3.0">

    <!-- EXPERIMENTAL: points/lines/areas represented as array(xs:double) /
         array(xs:double)* (a plain list of doubles per vertex) instead of
         <Coord> element nodes. See COORD_PARSING_BENCHMARK.md at the repo
         root. This is a temporary experimental variant, not a permanent
         change. -->

    <function name="ma:point-connected-to-point" as="xs:boolean">
        <param name="point_1" as="array(xs:double)"/>
        <param name="point_2" as="array(xs:double)"/>

        <sequence select="ma:trim-decimals(ma:point-distance-to-point($point_1, $point_2)) = 0"/>
    </function>

    <function name="ma:point-touches-line" as="xs:boolean">
        <param name="point" as="array(xs:double)"/>
        <param name="line" as="array(xs:double)*"/>

        <sequence select="ma:point-on-line($point, $line)"/>
    </function>

    <function name="ma:point-on-line" as="xs:boolean">
        <param name="point" as="array(xs:double)"/>
        <param name="line" as="array(xs:double)*"/>

        <choose>
            <when test="ma:point-within-bounding-box-of-line($point, $line)">
                <sequence select="some $index in 1 to count($line) - 1 satisfies ma:point-on-segment($point, subsequence($line, $index, 2))"/>
            </when>
            <otherwise>
                <sequence select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="ma:point-within-bounding-box-of-line" as="xs:boolean">
        <param name="point" as="array(xs:double)"/>
        <param name="line" as="array(xs:double)*"/>

        <variable name="x" select="$point(1)" as="xs:double"/>
        <variable name="y" select="$point(2)" as="xs:double"/>
        <variable name="min_x" select="min($line ! .(1))"/>
        <variable name="max_x" select="max($line ! .(1))"/>
        <variable name="min_y" select="min($line ! .(2))"/>
        <variable name="max_y" select="max($line ! .(2))"/>

        <sequence select="$x ge $min_x and $x le $max_x and $y ge $min_y and $y le $max_y"/>
    </function>

    <function name="ma:point-on-segment" as="xs:boolean">
        <param name="point" as="array(xs:double)"/>
        <param name="segment" as="array(xs:double)*"/>

        <variable name="cross_product" select="ma:cross-product($point, $segment)"/>
        <variable name="collinear" select="ma:trim-decimals(abs($cross_product)) = 0"/>

        <choose>
            <when test="$collinear">
                <sequence select="ma:point-within-bounding-box-of-line($point, $segment)"/>
            </when>
            <otherwise>
                <sequence select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="ma:point-touches-area" as="xs:boolean">
        <param name="point" as="array(xs:double)"/>
        <param name="area" as="array(xs:double)*"/>

        <sequence select="ma:point-touches-line($point, $area)"/>
    </function>

    <function name="ma:point-interacts-with-area" as="xs:boolean">
        <param name="point" as="array(xs:double)"/>
        <param name="area" as="array(xs:double)*"/>

        <sequence select="ma:point-on-line($point, $area) or ma:winding-number($point, $area) != 0"/>
    </function>

    <function name="ma:point-relative-orientation-to-segment" as="xs:integer">
        <param name="point" as="array(xs:double)"/>
        <param name="segment" as="array(xs:double)*"/>

        <variable name="cross_product" select="ma:cross-product($point, $segment)"/>

        <sequence select="
                    if ($cross_product = 0) then 0
                    else if ($cross_product &gt; 0) then 1
                    else 2"/>
    </function>

    <function name="ma:point-distance-to-point" as="xs:double">
        <param name="point_1" as="array(xs:double)"/>
        <param name="point_2" as="array(xs:double)"/>

        <variable name="dx" select="$point_1(1) - $point_2(1)"/>
        <variable name="dy" select="$point_1(2) - $point_2(2)"/>
        <variable name="distance_squared" select="($dx * $dx) + ($dy * $dy)"/>
        <variable name="distance" select="math:sqrt($distance_squared)"/>
        <sequence select="$distance"/>
    </function>

    <function name="ma:segment-length" as="xs:double">
        <param name="segment" as="array(xs:double)*"/>

        <sequence select="ma:point-distance-to-point($segment[1], $segment[2])"/>
    </function>

    <function name="ma:line-segments-not-meeting-length-demands" as="node()*">
        <param name="line" as="array(xs:double)*"/>

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
        <param name="line" as="array(xs:double)*"/>

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
        <param name="line" as="array(xs:double)*"/>
        <param name="area" as="array(xs:double)*"/>

        <choose>
            <when test="some $point in $line satisfies ma:point-interacts-with-area($point, $area)">
                <sequence select="true()"/>
            </when>
            <when test="some $point in $area satisfies ma:point-touches-line($point, $line)">
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
        <param name="area_1" as="array(xs:double)*"/>
        <param name="area_2" as="array(xs:double)*"/>

        <sequence select="
                    ma:line-interacts-with-area($area_1, $area_2)
                    or
                    ma:line-interacts-with-area($area_2, $area_1)"/>
    </function>

    <function name="ma:segment-angle-between-segment" as="xs:double">
        <param name="segment_1" as="array(xs:double)*"/>
        <param name="segment_2" as="array(xs:double)*"/>

        <variable name="vx1" select="$segment_1[1](1) - $segment_1[2](1)"/>
        <variable name="vy1" select="$segment_1[1](2) - $segment_1[2](2)"/>
        <variable name="vx2" select="$segment_2[2](1) - $segment_2[1](1)"/>
        <variable name="vy2" select="$segment_2[2](2) - $segment_2[1](2)"/>

        <variable name="dot_product" select="$vx1 * $vx2 + $vy1 * $vy2"/>

        <variable name="length_v1" select="math:sqrt($vx1 * $vx1 + $vy1 * $vy1)"/>
        <variable name="length_v2" select="math:sqrt($vx2 * $vx2 + $vy2 * $vy2)"/>

        <variable name="radian" select="math:acos($dot_product div ($length_v1 * $length_v2))"/>

        <sequence select="$radian * 180 div math:pi()"/>
    </function>

    <function name="ma:segment-intersects-segment" as="xs:boolean">
        <param name="segment_1" as="array(xs:double)*"/>
        <param name="segment_2" as="array(xs:double)*"/>

        <variable name="relative_orientation_segment_1_start" select="ma:point-relative-orientation-to-segment($segment_1[1], $segment_2)"/>
        <variable name="relative_orientation_segment_1_end" select="ma:point-relative-orientation-to-segment($segment_1[2], $segment_2)"/>
        <variable name="relative_orientation_segment_2_start" select="ma:point-relative-orientation-to-segment($segment_2[1], $segment_1)"/>
        <variable name="relative_orientation_segment_2_end" select="ma:point-relative-orientation-to-segment($segment_2[2], $segment_1)"/>

        <sequence select="
                    $relative_orientation_segment_1_start != $relative_orientation_segment_1_end
                    and
                    $relative_orientation_segment_2_start != $relative_orientation_segment_2_end"/>
    </function>

    <function name="ma:cross-product" as="xs:double">
        <param name="point" as="array(xs:double)"/>
        <param name="segment" as="array(xs:double)*"/>

        <sequence select="
                    ($segment[2](1) - $segment[1](1)) * ($point(2) - $segment[1](2)) -
                    ($segment[2](2) - $segment[1](2)) * ($point(1) - $segment[1](1))"/>
    </function>

    <function name="ma:edge-winding" as="xs:integer">
        <param name="point" as="array(xs:double)"/>
        <param name="segment" as="array(xs:double)*"/>

        <variable name="cross_product" select="ma:cross-product($point, $segment)"/>

        <choose>
            <when test="xs:double($segment[1](2)) le xs:double($point(2)) and xs:double($segment[2](2)) gt xs:double($point(2))">
                <sequence select="if($cross_product gt 0) then 1 else 0"/>
            </when>
            <when test="xs:double($segment[2](2)) le xs:double($point(2)) and xs:double($segment[1](2)) gt xs:double($point(2))">
                <sequence select="if($cross_product lt 0) then -1 else 0"/>
            </when>
            <otherwise>
                <sequence select="0"/>
            </otherwise>
        </choose>
    </function>

    <function name="ma:winding-number" as="xs:integer">
        <param name="point" as="array(xs:double)"/>
        <param name="area" as="array(xs:double)*"/>

        <variable name="segment_count" select="count($area) - 1"/>

        <variable name="edge_windings" as="xs:integer*">
            <for-each select="1 to $segment_count">
                <variable name="segment" select="subsequence($area, ., 2)"/>
                <sequence select="ma:edge-winding($point, $segment)"/>
            </for-each>
        </variable>

        <sequence select="xs:integer(sum($edge_windings))"/>
    </function>

    <!-- Returns an orthogonal segment from the first point of the segment with a given buffer distance from the first point -->
    <function name="ma:point-get-orthogonal-segment" as="array(xs:double)*">
        <param name="segment" as="array(xs:double)*"/>
        <param name="buffer_distance" as="xs:double"/>

        <variable name="segment_length" select="ma:segment-length($segment)"/>

        <variable name="dx" select="$segment[2](1) - $segment[1](1)"/>
        <variable name="dy" select="$segment[2](2) - $segment[1](2)"/>

        <variable name="ux" select="-$dy div $segment_length"/>
        <variable name="uy" select="$dx div $segment_length"/>

        <variable name="x_left" select="$segment[1](1) + $buffer_distance * $ux"/>
        <variable name="y_left" select="$segment[1](2) + $buffer_distance * $uy"/>
        <variable name="x_right" select="$segment[1](1) - $buffer_distance * $ux"/>
        <variable name="y_right" select="$segment[1](2) - $buffer_distance * $uy"/>

        <sequence select="ma:coord($x_left, $y_left), ma:coord($x_right, $y_right)"/>
    </function>

    <function name="ma:line-within-range-of-line" as="xs:boolean">
        <param name="line" as="array(xs:double)*"/>
        <param name="control_line" as="array(xs:double)*"/>
        <param name="range" as="xs:double"/>

        <variable name="line_buffer" select="ma:buffer-line($line, $range)"/>

        <variable name="check_step" select="0.5"/>

        <variable name="control_line_within_bounds" as="xs:boolean*">
            <for-each select="1 to count($control_line) - 1">
                <variable name="segment_index" select="."/>
                <variable name="segment" select="subsequence($control_line, $segment_index, 2)"/>

                <variable name="segment_length" select="ma:segment-length($segment)"/>

                <variable name="dx" select="$segment[2](1) - $segment[1](1)"/>
                <variable name="dy" select="$segment[2](2) - $segment[1](2)"/>

                <variable name="points_in_segment" select="xs:integer(ceiling($segment_length div $check_step))"/>
                <variable name="distance_between_points" select="$segment_length div $points_in_segment"/>
                <variable name="scaling_factor" select="$distance_between_points div $segment_length"/>

                <variable name="is_last_segment" select="$segment_index = last()"/>
                <variable name="points_to_check" select="if($is_last_segment) then $points_in_segment + 1 else $points_in_segment"/>

                <for-each select="1 to $points_to_check">
                    <variable name="point_index" select="."/>
                    <variable name="point" as="array(xs:double)">
                        <choose>
                            <when test="$point_index = 1">
                                <sequence select="$segment[1]"/>
                            </when>
                            <when test="$point_index = last() and $is_last_segment">
                                <sequence select="$segment[2]"/>
                            </when>
                            <otherwise>
                                <variable name="point_x" select="$segment[1](1) + $scaling_factor * ($point_index - 1) * $dx"/>
                                <variable name="point_y" select="$segment[1](2) + $scaling_factor * ($point_index - 1) * $dy"/>
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

    <function name="ma:intersection-of-segments" as="array(xs:double)?">
        <param name="segment_1" as="array(xs:double)*"/>
        <param name="segment_2" as="array(xs:double)*"/>

        <variable name="den" select="
                    ($segment_1[1](1) - $segment_1[2](1)) * ($segment_2[1](2) - $segment_2[2](2)) -
                    ($segment_1[1](2) - $segment_1[2](2)) * ($segment_2[1](1) - $segment_2[2](1))"/>

        <if test="$den != 0">
            <variable name="scaling_factor" select="
                        (($segment_1[1](1) - $segment_2[1](1)) * ($segment_2[1](2) - $segment_2[2](2)) -
                        ($segment_1[1](2) - $segment_2[1](2)) * ($segment_2[1](1) - $segment_2[2](1))) div $den"/>

            <variable name="intersect_x" select="$segment_1[1](1) + $scaling_factor * ($segment_1[2](1) - $segment_1[1](1))"/>
            <variable name="intersect_y" select="$segment_1[1](2) + $scaling_factor * ($segment_1[2](2) - $segment_1[1](2))"/>
            <sequence select="ma:coord($intersect_x, $intersect_y)"/>
        </if>
    </function>

    <function name="ma:buffer-line" as="array(xs:double)*">
        <param name="line" as="array(xs:double)*"/>
        <param name="buffer_distance" as="xs:double"/>

        <variable name="segment_count" select="count($line) - 1"/>

        <variable name="left_bounds_segments" as="array(xs:double)*">
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($line, $index, 2)"/>

                <!-- Skip segments with length 0 (e.g. same coords) -->
                <if test="ma:segment-length($segment) != 0">
                    <variable name="orthogonal_start_segment" select="ma:point-get-orthogonal-segment($segment, $buffer_distance)"/>
                    <variable name="orthogonal_end_segment" select="ma:point-get-orthogonal-segment(reverse($segment), $buffer_distance)"/>

                    <sequence select="$orthogonal_start_segment[2], $orthogonal_end_segment[1]"/>
                </if>
            </for-each>
        </variable>

        <variable name="right_bounds_in_segments" as="array(xs:double)*">
            <for-each select="1 to $segment_count">
                <variable name="index" select="."/>
                <variable name="segment" select="subsequence($line, $index, 2)"/>

                <!-- Skip segments with length 0 (e.g. same coords) -->
                <if test="ma:segment-length($segment) != 0">
                    <variable name="orthogonal_start_segment" select="ma:point-get-orthogonal-segment($segment, $buffer_distance)"/>
                    <variable name="orthogonal_end_segment" select="ma:point-get-orthogonal-segment(reverse($segment), $buffer_distance)"/>

                    <sequence select="$orthogonal_start_segment[1], $orthogonal_end_segment[2]"/>
                </if>
            </for-each>
        </variable>

        <variable name="left_bounds" as="array(xs:double)*">
            <for-each select="1 to count($left_bounds_segments) div 2">
                <variable name="index" select="."/>
                <variable name="segment_index" select="$index * 2 - 1"/>
                <variable name="bound_segment" select="subsequence($left_bounds_segments, $segment_index, 2)"/>

                <if test="$index = 1">
                    <sequence select="$bound_segment[1]"/>
                </if>

                <choose>
                    <when test="$index = last()">
                        <sequence select="$bound_segment[2]"/>
                    </when>
                    <otherwise>
                        <variable name="bound_next_segment" select="subsequence($left_bounds_segments, $segment_index + 2, 2)"/>
                        <sequence select="ma:intersection-of-segments($bound_segment, $bound_next_segment)"/>
                    </otherwise>
                </choose>
            </for-each>
        </variable>

        <variable name="right_bounds" as="array(xs:double)*">
            <for-each select="1 to count($right_bounds_in_segments) div 2">
                <variable name="index" select="."/>
                <variable name="segment_index" select="$index * 2 - 1"/>
                <variable name="bound_segment" select="subsequence($right_bounds_in_segments, $segment_index, 2)"/>

                <if test="$index = 1">
                    <sequence select="$bound_segment[1]"/>
                </if>

                <choose>
                    <when test="$index = last()">
                        <sequence select="$bound_segment[2]"/>
                    </when>
                    <otherwise>
                        <variable name="bound_next_segment" select="subsequence($right_bounds_in_segments, $segment_index + 2, 2)"/>
                        <sequence select="ma:intersection-of-segments($bound_segment, $bound_next_segment)"/>
                    </otherwise>
                </choose>
            </for-each>
        </variable>

        <sequence select="$left_bounds"/>
        <sequence select="reverse($right_bounds)"/>
        <sequence select="$left_bounds[1]"/>
    </function>
</stylesheet>
