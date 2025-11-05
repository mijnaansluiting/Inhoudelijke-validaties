<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:math="http://www.w3.org/2005/xpath-functions/math"
            xmlns:keronic="http://example.com/my-functions"
            xmlns:keronic-geom="http://example.com/my-functions-test"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            version="3.0">

    <function name="keronic-geom:line-2d-contains-smaller-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="min_angle" as="xs:double"/>
        <!-- start index at 3 because the first point doesn't have an angle -->

        <variable name="result" select="keronic-geom:inside-line-3d-contains-smaller-angle-than-arg(
                                        $line,
                                        $min_angle,
                                        3)"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic-geom:line-3d-contains-smaller-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="min_angle" as="xs:double"/>
        <!-- start index at 4 because the first point doesn't have an angle  -->

        <variable name="result" select="keronic-geom:inside-line-3d-contains-smaller-angle-than-arg(
                                        $line,
                                        $min_angle,
                                        4)"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic-geom:line-2d-contains-larger-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="max_angle" as="xs:double"/>
        <!-- start index at 3 because the first point doesn't have an angle -->

        <variable name="result" select="keronic-geom:inside-line-3d-contains-larger-angle-than-arg(
                                        $line,
                                        $max_angle,
                                        3)"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic-geom:line-3d-contains-larger-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="max_angle" as="xs:double"/>
        <!-- start index at 4 because the first point doesn't have an angle  -->

        <variable name="result" select="keronic-geom:inside-line-3d-contains-larger-angle-than-arg(
                                        $line,
                                        $max_angle,
                                        4)"/>
        <value-of select="$result"/>
    </function>

    <function name="keronic-geom:inside-line-2d-contains-smaller-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="min_angle" as="xs:double"/>
        <param name="index" as="xs:integer"/>

        <choose>
            <when test="$index gt count($line) - 2">
                <value-of select="false()"/>
            </when>
            <otherwise>
                <variable name="line_part" select="$line[
                                                   position() = $index - 2 or
                                                   position() = $index - 1 or
                                                   position() = $index or
                                                   position() = $index + 1 or
                                                   position() = $index + 2 or
                                                   position() = $index + 3
                                                   ]"/>
                <choose>
                    <when test="keronic-geom:two-line-parts-2d-smaller-angle-than-arg(
                                $line_part,
                                $min_angle
                                )">
                        <value-of select="true()"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic-geom:inside-line-2d-contains-smaller-angle-than-arg(
                                          $line,
                                          $min_angle,
                                          $index + 2
                                          )"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:inside-line-2d-contains-larger-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="max_angle" as="xs:double"/>
        <param name="index" as="xs:integer"/>

        <choose>
            <when test="$index gt count($line) - 2">
                <value-of select="false()"/>
            </when>
            <otherwise>
                <variable name="line_part" select="$line[
                                                   position() = $index - 2 or
                                                   position() = $index - 1 or
                                                   position() = $index or
                                                   position() = $index + 1 or
                                                   position() = $index + 2 or
                                                   position() = $index + 3
                                                   ]"/>
                <choose>
                    <when test="keronic-geom:two-line-parts-2d-larger-angle-than-arg(
                                $line_part,
                                $max_angle
                                )">
                        <value-of select="true()"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic-geom:inside-line-2d-contains-larger-angle-than-arg(
                                          $line,
                                          $max_angle,
                                          $index + 2
                                          )"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:inside-line-3d-contains-smaller-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="min_angle" as="xs:double"/>
        <param name="index" as="xs:integer"/>

        <choose>
            <when test="$index gt count($line) - 3">
                <value-of select="false()"/>
            </when>
            <otherwise>
                <variable name="line_part" select="$line[
                                                   position() = $index - 3 or
                                                   position() = $index - 2 or
                                                   position() = $index - 1 or
                                                   position() = $index or
                                                   position() = $index + 1 or
                                                   position() = $index + 2 or
                                                   position() = $index + 3 or
                                                   position() = $index + 4 or
                                                   position() = $index + 5
                                                   ]"/>
                <choose>
                    <when test="keronic-geom:two-line-parts-3d-smaller-angle-than-arg(
                                $line_part,
                                $min_angle
                                )">
                        <value-of select="true()"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic-geom:inside-line-3d-contains-smaller-angle-than-arg(
                                          $line,
                                          $min_angle,
                                          $index + 3
                                          )"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:inside-line-3d-contains-larger-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="max_angle" as="xs:double"/>
        <param name="index" as="xs:integer"/>

        <choose>
            <when test="$index gt count($line) - 3">
                <value-of select="false()"/>
            </when>
            <otherwise>
                <variable name="line_part" select="$line[
                                                   position() = $index - 3 or
                                                   position() = $index - 2 or
                                                   position() = $index - 1 or
                                                   position() = $index or
                                                   position() = $index + 1 or
                                                   position() = $index + 2 or
                                                   position() = $index + 3 or
                                                   position() = $index + 4 or
                                                   position() = $index + 5
                                                   ]"/>
                <choose>
                    <when test="keronic-geom:two-line-parts-3d-larger-angle-than-arg(
                                $line_part,
                                $max_angle
                                )">
                        <value-of select="true()"/>
                    </when>
                    <otherwise>
                        <value-of select="keronic-geom:inside-line-3d-contains-larger-angle-than-arg(
                                          $line,
                                          $max_angle,
                                          $index + 3
                                          )"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>
    </function>

    <function name="keronic-geom:two-line-parts-2d-smaller-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="min_angle" as="xs:double"/>

        <variable name="AB_x" select="$line[position() = 3] - $line[position() = 1]"/>
        <variable name="AB_y" select="$line[position() = 4] - $line[position() = 2]"/>

        <variable name="BC_x" select="$line[position() = 5] - $line[position() = 3]"/>
        <variable name="BC_y" select="$line[position() = 6] - $line[position() = 4]"/>

        <variable name="dot_product"
                  select="($AB_x * $BC_x) + ($AB_y * $BC_y)"/>

        <variable name="magnitude_AB"
                  select="math:sqrt(($AB_x * $AB_x) + ($AB_y * $AB_y))"/>

        <variable name="magnitude_BC"
                  select="math:sqrt(($BC_x * $BC_x) + ($BC_y * $BC_y))"/>

        <variable name="cos_theta"
                  select="$dot_product div ($magnitude_AB * $magnitude_BC)"/>

        <variable name="angle_radians" select="math:acos($cos_theta)"/>

        <variable name="angle_degrees"
                  select="180 - ($angle_radians * (180 div math:pi()))"/>

        <value-of select="$angle_degrees lt $min_angle"/>
    </function>

    <function name="keronic-geom:two-line-parts-2d-larger-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="min_angle" as="xs:double"/>

        <variable name="AB_x" select="$line[position() = 3] - $line[position() = 1]"/>
        <variable name="AB_y" select="$line[position() = 4] - $line[position() = 2]"/>

        <variable name="BC_x" select="$line[position() = 5] - $line[position() = 3]"/>
        <variable name="BC_y" select="$line[position() = 6] - $line[position() = 4]"/>

        <variable name="dot_product"
                  select="($AB_x * $BC_x) + ($AB_y * $BC_y)"/>

        <variable name="magnitude_AB"
                  select="math:sqrt(($AB_x * $AB_x) + ($AB_y * $AB_y))"/>

        <variable name="magnitude_BC"
                  select="math:sqrt(($BC_x * $BC_x) + ($BC_y * $BC_y))"/>

        <variable name="cos_theta"
                  select="$dot_product div ($magnitude_AB * $magnitude_BC)"/>

        <variable name="angle_radians" select="math:acos($cos_theta)"/>

        <variable name="angle_degrees"
                  select="180 - ($angle_radians * (180 div math:pi()))"/>

        <value-of select="$angle_degrees gt $min_angle"/>
    </function>

    <function name="keronic-geom:two-line-parts-3d-smaller-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="min_angle" as="xs:double"/>

        <variable name="AB_x" select="$line[position() = 4] - $line[position() = 1]"/>
        <variable name="AB_y" select="$line[position() = 5] - $line[position() = 2]"/>
        <variable name="AB_z" select="$line[position() = 6] - $line[position() = 3]"/>

        <variable name="BC_x" select="$line[position() = 7] - $line[position() = 4]"/>
        <variable name="BC_y" select="$line[position() = 8] - $line[position() = 5]"/>
        <variable name="BC_z" select="$line[position() = 9] - $line[position() = 6]"/>

        <variable name="dot_product"
                  select="($AB_x * $BC_x) + ($AB_y * $BC_y) + ($AB_z * $BC_z)"/>

        <variable name="magnitude_AB"
                  select="math:sqrt(($AB_x * $AB_x) + ($AB_y * $AB_y) + ($AB_z * $AB_z))"/>

        <variable name="magnitude_BC"
                  select="math:sqrt(($BC_x * $BC_x) + ($BC_y * $BC_y) + ($BC_z * $BC_z))"/>

        <variable name="cos_theta"
                  select="$dot_product div ($magnitude_AB * $magnitude_BC)"/>

        <variable name="angle_radians" select="math:acos($cos_theta)"/>

        <variable name="angle_degrees"
                  select="180 - ($angle_radians * (180 div math:pi()))"/>

        <value-of select="$angle_degrees lt $min_angle"/>
    </function>

    <function name="keronic-geom:two-line-parts-3d-larger-angle-than-arg" as="xs:boolean">
        <param name="line" as="xs:double*"/>
        <param name="max_angle" as="xs:double"/>

        <variable name="AB_x" select="$line[position() = 4] - $line[position() = 1]"/>
        <variable name="AB_y" select="$line[position() = 5] - $line[position() = 2]"/>
        <variable name="AB_z" select="$line[position() = 6] - $line[position() = 3]"/>

        <variable name="BC_x" select="$line[position() = 7] - $line[position() = 4]"/>
        <variable name="BC_y" select="$line[position() = 8] - $line[position() = 5]"/>
        <variable name="BC_z" select="$line[position() = 9] - $line[position() = 6]"/>

        <variable name="dot_product"
                  select="($AB_x * $BC_x) + ($AB_y * $BC_y) + ($AB_z * $BC_z)"/>

        <variable name="magnitude_AB"
                  select="math:sqrt(($AB_x * $AB_x) + ($AB_y * $AB_y) + ($AB_z * $AB_z))"/>

        <variable name="magnitude_BC"
                  select="math:sqrt(($BC_x * $BC_x) + ($BC_y * $BC_y) + ($BC_z * $BC_z))"/>

        <variable name="cos_theta"
                  select="$dot_product div ($magnitude_AB * $magnitude_BC)"/>

        <variable name="angle_radians" select="math:acos($cos_theta)"/>

        <variable name="angle_degrees"
                  select="$angle_radians * (180 div math:pi())"/>

        <value-of select="$angle_degrees gt $max_angle"/>
    </function>
</stylesheet>
