<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:keronic-geom="http://example.com/my-functions-test"
            xmlns:keronic="http://example.com/my-functions"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
            xmlns:ma="http://example.com/mijnaansluiting"
            version="3.0">

    <function name="ma:point-2d-interacts-with-area-2d" as="xs:boolean">
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

                <variable name="area_point_1" select="ma:array-2d-get-nth-point($area, $i)"/>
                <variable name="area_point_2" select="ma:array-2d-get-nth-point($area, $j)"/>

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

        <value-of select="count($intersections) mod 2 = 1"/>
    </function>

    <function name="ma:line-2d-interacts-with-area-2d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="area" as="xs:double*"/>

        <variable name="area_point_count" select="count($area) idiv 2 - 1"/>
        <variable name="line_point_count" select="count($line) idiv 2 - 1"/>

        <variable name="anyPointInside" select="
                    some $i in 1 to $line_point_count
                    satisfies (
                    ma:point-2d-interacts-with-area-2d(
                    ma:array-2d-get-nth-point($line, $i),
                    $area))"/>

        <choose>
            <when test="$anyPointInside">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="
                            some $list_index in 1 to $line_point_count
                            satisfies (
                            some $area_index in 1 to $area_point_count
                            satisfies (
                            ma:segments-intersect(
                            ma:array-2d-get-nth-point($line, $list_index),
                            ma:array-2d-get-nth-point($line, $list_index + 1),
                            ma:array-2d-get-nth-point($area, $area_index),
                            ma:array-2d-get-nth-point($area, $area_index + 1))))"/>
            </otherwise>
        </choose>
    </function>

    <function name="ma:segments-intersect" as="xs:boolean">
        <param name="segment_a_point_1" as="xs:double*"/>
        <param name="segment_a_point_2" as="xs:double*"/>
        <param name="segment_b_point_1" as="xs:double*"/>
        <param name="segment_b_point_2" as="xs:double*"/>

        <variable name="orientation_segment_a_point_1" select="ma:orientation(
                                                               $segment_b_point_1,
                                                               $segment_b_point_2,
                                                               $segment_a_point_1)"/>
        <variable name="orientation_segment_a_point_2" select="ma:orientation(
                                                               $segment_b_point_1,
                                                               $segment_b_point_2,
                                                               $segment_a_point_2)"/>
        <variable name="orientation_segment_b_point_1" select="ma:orientation(
                                                               $segment_a_point_1,
                                                               $segment_a_point_2,
                                                               $segment_b_point_1)"/>
        <variable name="orientation_segment_b_point_2" select="ma:orientation(
                                                               $segment_a_point_1,
                                                               $segment_a_point_2,
                                                               $segment_b_point_2)"/>

        <value-of select="
                    ($orientation_segment_a_point_1 != $orientation_segment_a_point_2 and
                    $orientation_segment_b_point_1 != $orientation_segment_b_point_2)"/>
    </function>

    <function name="ma:orientation" as="xs:integer">
        <param name="segment_point_1" as="xs:double*"/>
        <param name="segment_point_2" as="xs:double*"/>
        <param name="point" as="xs:double*"/>

        <variable name="cross_product" select="
                    ($segment_point_2[2] - $segment_point_1[2]) * ($point[1] - $segment_point_2[1]) -
                    ($segment_point_2[1] - $segment_point_1[1]) * ($point[2] - $segment_point_2[2])"/>

        <sequence select="
                    if ($cross_product = 0) then 0
                    else if ($cross_product &gt; 0) then 1
                                     else 2"/>
    </function>
    <function name="ma:area-2d-interacts-with-area-2d" as="xs:boolean">
        <param name="area1" as="xs:double*"/>
        <param name="area2" as="xs:double*"/>

        <choose>
            <when test="ma:line-2d-interacts-with-area-2d(
                          $area2,
                          $area1)">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="ma:line-2d-interacts-with-area-2d(
                          $area1,
                          $area2)"/>
            </otherwise>
        </choose>
    </function>
    
    <function name="ma:point-2d-to-point-2d-distance" as="xs:double">
        <param name="point_1" as="xs:double*"/>
        <param name="point_2" as="xs:double*"/>
        
        <variable name="dx" select="$point_1[1] - $point_2[1]"/>
        <variable name="dy" select="$point_1[2] - $point_2[2]"/>
        <variable name="distance_squared" select="($dx * $dx) + ($dy * $dy)"/>
        <variable name="distance" select="math:sqrt($distance_squared)"/>
        <value-of select="$distance"/>
    </function>
</stylesheet>
