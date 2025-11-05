<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:keronic-geom="http://example.com/my-functions-test"
            xmlns:keronic="http://example.com/my-functions"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            version="3.0">

    <function name="keronic-geom:point-2d-to-point-2d-distance" as="xs:double">
        <param name="x1" as="xs:double"/>
        <param name="y1" as="xs:double"/>
        <param name="x2" as="xs:double"/>
        <param name="y2" as="xs:double"/>

        <variable name="dx" select="$x2 - $x1"/>
        <variable name="dy" select="$y2 - $y1"/>
        <variable name="squared_distance" select="($dx * $dx) + ($dy * $dy)"/>
        <variable name="distance" select="math:sqrt($squared_distance)"/>
        <value-of select="$distance"/>
    </function>

    <function name="keronic-geom:point-2d-connected-to-point-2d" as="xs:boolean">
        <param name="point_1" as="xs:double*"/>
        <param name="point_2" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="connect_threshold" as="xs:double"
                  select= "if (empty($threshold)) then
                           xs:double(keronic:get-connected-threshold())
                           else
                           $threshold"/>
        <choose>
            <when test="keronic-geom:point-2d-to-point-2d-distance
                        (
                        $point_1[1],
                        $point_1[2],
                        $point_2[1],
                        $point_2[2]
                        )
                        le $connect_threshold">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:point-2d-connected-to-line-2d-ends" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>
        <choose>
            <when test="keronic-geom:point-2d-connected-to-point-2d(
                        $point,
                        $line[position() = 1 or position() = 2],
                        $threshold
                        ) or
                        keronic-geom:point-2d-connected-to-point-2d(
                        $point,
                        $line[position() = last() - 1 or position() = last()],
                        $threshold
                        )">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <!-- this function only takes a line part, so (x_1, y_1, x_2, y_2) -->
    <function name="keronic-geom:point-2d-connected-to-line-2d-part" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="connect_threshold" as="xs:double"
                  select= "if (empty($threshold)) then
                           xs:double(keronic:get-connected-threshold())
                           else
                           $threshold"/>
        <variable name="line_first_last_x" select= "$line[position() = 1 or position() = last() -1]"/>
        <variable name="line_first_last_y" select= "$line[position() = 2 or position() = last()]"/>
        <!-- calculate the coordinates of the middle of the line -->
        <variable name="middle_point_x" select=
                  "max($line_first_last_x) -
                  abs(
                  (
                  max($line_first_last_x) -
                  min($line_first_last_x)
                  ) div 2)"/>
        <variable name="middle_point_y" select=
                  "max($line_first_last_y) -
                  abs(
                  (
                  max($line_first_last_y) -
                  min($line_first_last_y)
                  ) div 2)"/>

        <!-- this calculates a vector relative to the middle of the line -->
        <variable name="vector_le_x" select="$line[1] - $middle_point_x"/>
        <variable name="vector_le_y" select="$line[2] - $middle_point_y"/>
        <variable name="vector_point_x" select="$point[1] - $middle_point_x"/>
        <variable name="vector_point_y" select="$point[2] - $middle_point_y"/>

        <variable name="rotation" select="keronic:atan2($vector_le_y, $vector_le_x)"/>

        <variable name="flat_vector_le_x" select="($vector_le_x * math:cos($rotation)) - ($vector_le_y * math:sin($rotation))"/>
        <variable name="flat_vector_point_x" select="($vector_point_x * math:cos($rotation)) - ($vector_point_y * math:sin($rotation))"/>
        <variable name="flat_vector_point_y" select="($vector_point_x * math:sin($rotation)) + ($vector_point_y * math:cos($rotation))"/>

        <choose>
            <when test="(abs($flat_vector_point_x) le abs($flat_vector_le_x) and
                        (abs($flat_vector_point_y) le $connect_threshold)) or
                        (keronic-geom:point-2d-connected-to-line-2d-ends($point, $line, $threshold))">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:line-2d-ends-connected-to-line-2d" as="xs:boolean">
        <param name="line_1" as="xs:double*"/>
        <param name="line_2" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="line_end_1" select="$line_1[position() = 1 or position() = 2]"/>
        <variable name="line_end_2" select="$line_1[position() = last() - 1 or position() = last()]"/>

        <value-of select="keronic-geom:line-2d-connected-to-point-2d(
                          $line_2,
                          $line_end_1,
                          $threshold) or
                          keronic-geom:line-2d-connected-to-point-2d(
                          $line_2,
                          $line_end_2,
                          $threshold)"/>
    </function>

    <function name="keronic-geom:line-2d-ends-connected-to-line-2d-ends" as="xs:boolean">
        <param name="line_1" as="xs:double*"/>
        <param name="line_2" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="line_1_end_1" select="$line_1[position() = 1 or position() = 2]"/>
        <variable name="line_1_end_2" select="$line_1[position() = last() - 1 or position() = last()]"/>

        <variable name="line_2_end_1" select="$line_2[position() = 1 or position() = 2]"/>
        <variable name="line_2_end_2" select="$line_2[position() = last() - 1 or position() = last()]"/>

        <value-of select="keronic-geom:point-2d-connected-to-point-2d(
                          $line_1_end_1,
                          $line_2_end_1,
                          $threshold) or
                          keronic-geom:point-2d-connected-to-point-2d(
                          $line_1_end_1,
                          $line_2_end_2,
                          $threshold) or
                          keronic-geom:point-2d-connected-to-point-2d(
                          $line_1_end_2,
                          $line_2_end_1,
                          $threshold) or
                          keronic-geom:point-2d-connected-to-point-2d(
                          $line_1_end_2,
                          $line_2_end_2,
                          $threshold)"/>
    </function>


    <function name="keronic-geom:line-2d-connected-to-point-2d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="point" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="result" select="keronic-geom:inside-line-2d-connected-to-point-2d(
                                        $line,
                                        $point,
                                        1,
                                        $threshold
                                        )"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic-geom:inside-line-2d-connected-to-point-2d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="point" as="xs:double*"/>
        <param name="index" as="xs:integer"/>
        <param name="threshold" as="xs:double?"/>

        <choose>
            <when test="($index + 2) gt count($line)">
                <value-of select="false()"/>
            </when>
            <otherwise>
                <variable name="line_part" select="$line[
                                                   position() = $index or
                                                   position() = $index + 1 or
                                                   position() = $index + 2 or
                                                   position() = $index + 3
                                                   ]"/>
                <choose>
                    <when test="keronic-geom:point-2d-connected-to-line-2d-part(
                                $point,
                                $line_part,
                                $threshold
                                )">
                        <value-of select="true()"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic-geom:inside-line-2d-connected-to-point-2d(
                                          $line,
                                          $point,
                                          $index + 2,
                                          $threshold
                                          )"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:line-2d-ends-connected-to-area-2d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="line_end_1" select="$line[position() = 1 or position() = 2]"/>
        <variable name="line_end_2" select="$line[
                                            position() = last() - 1 or
                                            position() = last()
                                            ]"/>

        <value-of select="keronic-geom:area-2d-connected-to-point-2d(
                          $area,
                          $line_end_1,
                          $threshold) or
                          keronic-geom:area-2d-connected-to-point-2d(
                          $area,
                          $line_end_2,
                          $threshold)
                          "/>
    </function>

    <function name="keronic-geom:area-2d-connected-to-point-2d" as="xs:boolean">
        <param name="area" as="xs:double*"/>
        <param name="point" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="result" select="keronic-geom:line-2d-connected-to-point-2d(
                                        $area,
                                        $point,
                                        $threshold
                                        )"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic-geom:point-2d-interacts-with-area-2d" as="xs:boolean">
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

                <variable name="area_point_1" select="keronic:array-2d-get-nth-point($area, $i)"/>
                <variable name="area_point_2" select="keronic:array-2d-get-nth-point($area, $j)"/>

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

    <function name="keronic-geom:line-2d-interacts-with-area-2d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="area" as="xs:double*"/>

        <variable name="area_point_count" select="count($area) div 2 - 1"/>
        <variable name="line_point_count" select="count($line) div 2 - 1"/>

        <variable name="anyPointInside" select="
                    some $i in 1 to $line_point_count
                    satisfies (
                    keronic-geom:point-2d-interacts-with-area-2d(
                    keronic:array-2d-get-nth-point($line, $i),
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
                            keronic-geom:segments-intersect(
                            keronic:array-2d-get-nth-point($line, $list_index),
                            keronic:array-2d-get-nth-point($line, $list_index + 1),
                            keronic:array-2d-get-nth-point($area, $area_index),
                            keronic:array-2d-get-nth-point($area, $area_index + 1))))"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:segments-intersect" as="xs:boolean">
        <param name="segment_a_point_1" as="xs:double*"/>
        <param name="segment_a_point_2" as="xs:double*"/>
        <param name="segment_b_point_1" as="xs:double*"/>
        <param name="segment_b_point_2" as="xs:double*"/>

        <variable name="orientation_segment_a_point_1" select="keronic-geom:orientation(
                                                               $segment_b_point_1,
                                                               $segment_b_point_2,
                                                               $segment_a_point_1)"/>
        <variable name="orientation_segment_a_point_2" select="keronic-geom:orientation(
                                                               $segment_b_point_1,
                                                               $segment_b_point_2,
                                                               $segment_a_point_2)"/>
        <variable name="orientation_segment_b_point_1" select="keronic-geom:orientation(
                                                               $segment_a_point_1,
                                                               $segment_a_point_2,
                                                               $segment_b_point_1)"/>
        <variable name="orientation_segment_b_point_2" select="keronic-geom:orientation(
                                                               $segment_a_point_1,
                                                               $segment_a_point_2,
                                                               $segment_b_point_2)"/>

        <value-of select="
                    ($orientation_segment_a_point_1 != $orientation_segment_a_point_2 and
                    $orientation_segment_b_point_1 != $orientation_segment_b_point_2)"/>
    </function>

    <function name="keronic-geom:orientation" as="xs:integer">
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
    <function name="keronic-geom:area-2d-interacts-with-area-2d" as="xs:boolean">
        <param name="area1" as="xs:double*"/>
        <param name="area2" as="xs:double*"/>

        <choose>
            <when test="keronic-geom:line-2d-interacts-with-area-2d(
                          $area2,
                          $area1)">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="keronic-geom:line-2d-interacts-with-area-2d(
                          $area1,
                          $area2)"/>
            </otherwise>
        </choose>
    </function>
</stylesheet>
