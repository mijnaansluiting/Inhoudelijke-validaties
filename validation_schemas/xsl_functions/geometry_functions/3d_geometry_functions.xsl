<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:keronic-geom="http://example.com/my-functions-test"
            xmlns:keronic="http://example.com/my-functions"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            version="3.0">

    <function name="keronic-geom:point-3d-to-point-3d-distance" as="xs:double">
        <param name="x1" as="xs:double"/>
        <param name="y1" as="xs:double"/>
        <param name="z1" as="xs:double"/>
        <param name="x2" as="xs:double"/>
        <param name="y2" as="xs:double"/>
        <param name="z2" as="xs:double"/>

        <variable name="dx" select="$x2 - $x1"/>
        <variable name="dy" select="$y2 - $y1"/>
        <variable name="dz" select="$z2 - $z1"/>
        <variable name="squared_distance" select="($dx * $dx) + ($dy * $dy) + ($dz * $dz)"/>
        <variable name="distance" select="math:sqrt($squared_distance)"/>

        <value-of select="$distance"/>
    </function>

    <function name="keronic-geom:point-3d-connected-to-point-3d" as="xs:boolean">
        <param name="point_1" as="xs:double*"/>
        <param name="point_2" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <choose>
            <when test="empty($point_1) or empty($point_2)">
                <value-of select="false()"/>
            </when>
            <otherwise>
                <variable name="connect_threshold" as="xs:double"
                        select= "if (empty($threshold)) then
                                xs:double(keronic:get-connected-threshold())
                                else
                                $threshold"/>
                <choose>
                    <when test="keronic-geom:point-3d-to-point-3d-distance
                                (
                                $point_1[1],
                                $point_1[2],
                                $point_1[3],
                                $point_2[1],
                                $point_2[2],
                                $point_2[3]
                                )
                                le $connect_threshold">
                        <value-of select="true()"/>
                    </when>
                    <otherwise>
                        <value-of select="false()"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>

    </function>

    <function name="keronic:point-3d-connected-to-one-of-several-point-3d" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="geometries" as="xs:string*"/>

        <sequence select="
                    some $geometry in $geometries
                    satisfies keronic:point-3d-connected-to-point-3d(
                    $point,
                    tokenize(normalize-space($geometry)),
                    0
                    )
                    "/>
    </function>

    <function name="keronic:point-3d-connected-to-one-of-several-area-3d" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="geometries" as="xs:string*"/>

        <sequence select="
                    some $geometry in $geometries
                    satisfies keronic:point-3d-touches-line-3d(
                    $point,
                    tokenize(normalize-space($geometry)),
                    0
                    )
                    "/>
    </function>

    <function name="keronic-geom:point-3d-connected-to-line-3d-ends" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>
        <choose>
            <when test="keronic-geom:point-3d-connected-to-point-3d(
                        $point, $line[position() = 1 or position() = 2 or position() = 3]
                        , $threshold) or
                        keronic-geom:point-3d-connected-to-point-3d(
                        $point, $line[
                        position() = last() or
                        position() = last() - 1 or
                        position() = last() - 2]
                        , $threshold)">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:point-3d-connected-to-line-3d-part" as="xs:boolean">
        <param name="point" as="xs:double*"/>
        <param name="line" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="connect_threshold" as="xs:double"
                  select= "if (empty($threshold)) then
                           xs:double(keronic:get-connected-threshold())
                           else
                           $threshold"/>
        <variable name="line_first_last_x" select= "$line[position() = 1 or position() = last() - 2]"/>
        <variable name="line_first_last_y" select= "$line[position() = 2 or position() = last() - 1]"/>
        <variable name="line_first_last_z" select= "$line[position() = 3 or position() = last()]"/>
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
        <variable name="middle_point_z" select=
                  "max($line_first_last_z) -
                  abs(
                  (
                  max($line_first_last_z) -
                  min($line_first_last_z)
                  ) div 2)"/>

        <!-- this calculates a vector relative to the middle of the line -->
        <variable name="vector_le_x" select="$line[1] - $middle_point_x"/>
        <variable name="vector_le_y" select="$line[2] - $middle_point_y"/>
        <variable name="vector_le_z" select="$line[3] - $middle_point_z"/>
        <variable name="vector_point_x" select="$point[1] - $middle_point_x"/>
        <variable name="vector_point_y" select="$point[2] - $middle_point_y"/>
        <variable name="vector_point_z" select="$point[3] - $middle_point_z"/>


        <!-- Since we now have 2 vectors we rotate the vector to be on the x-axis-->
        <variable name="z_axis_rotation" select="keronic:atan2($vector_le_y, $vector_le_x)"/>
        <variable name="x_axis_rotation" select="keronic:atan2($vector_le_z,
                                                 math:sqrt($vector_le_x * $vector_le_x + $vector_le_y * $vector_le_y))"/>

        <variable name="z_axis_rotated_vector_le_x" select="($vector_le_x * math:cos(-$z_axis_rotation)) - ($vector_le_y * math:sin(-$z_axis_rotation))"/>

        <variable name="z_axis_rotated_vector_point_x" select="($vector_point_x * math:cos(-$z_axis_rotation)) - ($vector_point_y * math:sin(-$z_axis_rotation))"/>

        <variable name="flat_vector_le_x" select="($z_axis_rotated_vector_le_x * math:cos(-$x_axis_rotation)) - ($vector_le_z * math:sin(-$x_axis_rotation))"/>

        <variable name="flat_vector_point_x" select="($z_axis_rotated_vector_point_x * math:cos(-$x_axis_rotation)) - ($vector_point_z * math:sin(-$x_axis_rotation))"/>
        <variable name="flat_vector_point_y" select="($vector_point_x * math:sin(-$z_axis_rotation)) + ($vector_point_y * math:cos(-$z_axis_rotation))"/>
        <variable name="flat_vector_point_z" select="($z_axis_rotated_vector_point_x * math:sin(-$x_axis_rotation)) + ($vector_point_z * math:cos(-$x_axis_rotation))"/>

        <variable name="distance_from_x_axis" select="math:sqrt(
                                                      ($flat_vector_point_y * $flat_vector_point_y) +
                                                      ($flat_vector_point_z * $flat_vector_point_z)
                                                      )"/>
        <choose>
            <!-- Since we calculate from the middle of the line we can take the absolute values on the x-axis
                 Besides that with the distance from x axis we check a cylinder around the x-axis -->
            <when test="(abs($flat_vector_point_x) le abs($flat_vector_le_x) and
                        ($distance_from_x_axis le $connect_threshold)) or
                        (keronic-geom:point-3d-connected-to-line-3d-ends($point, $line, $threshold))">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>


    <function name="keronic-geom:line-3d-ends-connected-to-line-3d" as="xs:boolean">
        <param name="line_1" as="xs:double*"/>
        <param name="line_2" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="line_end_1" select="$line_1[position() = 1 or position() = 2]"/>
        <variable name="line_end_2" select="$line_1[position() = last() - 2 or position() = last() -1]"/>

        <value-of select="keronic-geom:line-3d-connected-to-point-3d(
                          $line_2,
                          $line_end_1, $threshold) or
                          keronic-geom:line-3d-connected-to-point-3d(
                          $line_2,
                          $line_end_2, $threshold)"/>
    </function>

    <function name="keronic-geom:line-3d-ends-connected-to-line-3d-ends" as="xs:boolean">
        <param name="line_1" as="xs:double*"/>
        <param name="line_2" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="line_1_end_1" select="$line_1[
                                              position() = 1 or
                                              position() = 2 or
                                              position() = 3]"/>
        <variable name="line_1_end_2" select="$line_1[
                                              position() = last() - 2 or
                                              position() = last() - 1 or
                                              position() = last()
                                              ]"/>

        <variable name="line_2_end_1" select="$line_2[
                                              position() = 1 or
                                              position() = 2 or
                                              position() = 3
                                              ]"/>
        <variable name="line_2_end_2" select="$line_2[
                                              position() = last() - 2 or
                                              position() = last() - 1 or
                                              position() = last()
                                              ]"/>

        <value-of select="keronic-geom:point-3d-connected-to-point-3d(
                          $line_1_end_1,
                          $line_2_end_1, $threshold) or
                          keronic-geom:point-3d-connected-to-point-3d(
                          $line_1_end_1,
                          $line_2_end_2, $threshold) or
                          keronic-geom:point-3d-connected-to-point-3d(
                          $line_1_end_2,
                          $line_2_end_1, $threshold) or
                          keronic-geom:point-3d-connected-to-point-3d(
                          $line_1_end_2,
                          $line_2_end_2, $threshold)"/>
    </function>

    <function name="keronic-geom:line-3d-connected-to-point-3d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="point" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="result" select="keronic-geom:inside-line-3d-connected-to-point-3d($line, $point, 1, $threshold)"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic-geom:inside-line-3d-connected-to-point-3d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="point" as="xs:double*"/>
        <param name="index" as="xs:integer"/>
        <param name="threshold" as="xs:double?"/>

        <choose>
            <when test="($index + 3) gt count($line)">
                <value-of select="false()"/>
            </when>
            <otherwise>
                <variable name="line_part" select="$line[
                                                   position() = $index or
                                                   position() = $index + 1 or
                                                   position() = $index + 2 or
                                                   position() = $index + 3 or
                                                   position() = $index + 4 or
                                                   position() = $index + 5
                                                   ]"/>
                <choose>
                    <when test="keronic-geom:point-3d-connected-to-line-3d-part(
                                $point,
                                $line_part
                                , $threshold)">
                        <value-of select="true()"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic-geom:inside-line-3d-connected-to-point-3d(
                                          $line,
                                          $point,
                                          $index + 3
                                          , $threshold)"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:line-3d-ends-connected-to-area-3d" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="area" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="line_end_1" select="$line[
                                            position() = 1 or
                                            position() = 2 or
                                            position() = 3
                                            ]"/>
        <variable name="line_end_2" select="$line[
                                            position() = last() - 2 or
                                            position() = last() - 1 or
                                            position() = last()
                                            ]"/>

        <value-of select="keronic-geom:area-3d-connected-to-point-3d(
                          $area,
                          $line_end_1, $threshold) or
                          keronic-geom:area-3d-connected-to-point-3d(
                          $area,
                          $line_end_2, $threshold)
                          "/>
    </function>

    <function name="keronic-geom:area-3d-connected-to-point-3d" as="xs:boolean">
        <param name="area" as="xs:double*"/>
        <param name="point" as="xs:double*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="result" select="keronic-geom:line-3d-connected-to-point-3d(
                                        $area,
                                        $point
                                        , $threshold)"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic:point-3d-to-point-3d-distance" as="xs:double">
        <param name="x1" as="xs:double"/>
        <param name="y1" as="xs:double"/>
        <param name="z1" as="xs:double"/>
        <param name="x2" as="xs:double"/>
        <param name="y2" as="xs:double"/>
        <param name="z2" as="xs:double"/>

        <sequence select="keronic-geom:point-3d-to-point-3d-distance(
                          $x1,
                          $y1,
                          $z1,
                          $x2,
                          $y2,
                          $z2)"/>
    </function>
</stylesheet>
