<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	        xmlns:keronic="http://example.com/my-functions"
            xmlns:keronic-geom="http://example.com/my-functions-test"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
	        version="3.0">


    <!-- FROM POINT FUNCTIONS -->
    <function name="keronic:point-2d-connected-to-point-2d" as="xs:boolean">
        <param name="point_1" as="xs:string*"/>
        <param name="point_2" as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>

        <variable name="d_point_1" select="keronic:cast-string-array-to-double-array($point_1)" as="xs:double*"/>
        <variable name="d_point_2" select="keronic:cast-string-array-to-double-array($point_2)" as="xs:double*"/>

        <value-of select="keronic-geom:point-2d-connected-to-point-2d(
                          $d_point_1,
                          $d_point_2,
                          $threshold
                          )"/>
    </function>

    <function name="keronic:point-2d-connected-to-line-2d" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="line"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_point" select="keronic:cast-string-array-to-double-array($point)" as="xs:double*"/>
        <variable name="d_line" select="keronic:cast-string-array-to-double-array($line)" as="xs:double*"/>

        <value-of select="keronic-geom:point-2d-connected-to-line-2d-ends(
                        $d_point,
                        $d_line,
                        $threshold
                        )"/>
        </function>

    <function name="keronic:point-2d-touches-line-2d" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="line"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_point" select="keronic:cast-string-array-to-double-array($point)" as="xs:double*"/>
        <variable name="d_line" select="keronic:cast-string-array-to-double-array($line)" as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-connected-to-point-2d(
                        $d_line,
                        $d_point,
                        $threshold
                        )"/>

    </function>

    <function name="keronic:point-2d-connected-to-area-2d" as="xs:boolean">
        <param name="point" as="xs:string*"/>
        <param name="area"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_point" select="keronic:cast-string-array-to-double-array($point)" as="xs:double*"/>
        <variable name="d_area" select="keronic:cast-string-array-to-double-array($area)" as="xs:double*"/>

        <value-of select="keronic-geom:area-2d-connected-to-point-2d(
                          $d_area,
                          $d_point,
                          $threshold
                          )"/>
    </function>


    <!-- FROM LINE FUNCTIONS -->
    <function name="keronic:line-2d-connected-to-point-2d" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="point"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_line" select="keronic:cast-string-array-to-double-array($line)" as="xs:double*"/>
        <variable name="d_point" select="keronic:cast-string-array-to-double-array($point)" as="xs:double*"/>

        <value-of select="keronic-geom:point-2d-connected-to-line-2d-ends(
                        $d_point,
                        $d_line,
                        $threshold
                        )"/>
    </function>

    <function name="keronic:line-2d-touches-point-2d" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="point"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_line" select="keronic:cast-string-array-to-double-array($line)" as="xs:double*"/>
        <variable name="d_point" select="keronic:cast-string-array-to-double-array($point)" as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-connected-to-point-2d(
                        $d_line,
                        $d_point,
                        $threshold
                        )"/>
    </function>

    <function name="keronic:line-2d-connected-to-line-2d" as="xs:boolean">
        <param name="line_1" as="xs:string*"/>
        <param name="line_2"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_line_1" select="keronic:cast-string-array-to-double-array($line_1)" as="xs:double*"/>
        <variable name="d_line_2" select="keronic:cast-string-array-to-double-array($line_2)" as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-ends-connected-to-line-2d-ends(
                          $d_line_1,
                          $d_line_2,
                          $threshold
                          )"/>
    </function>

    <function name="keronic:line-2d-touches-line-2d" as="xs:boolean">
        <param name="line_1" as="xs:string*"/>
        <param name="line_2"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_line_1" select="keronic:cast-string-array-to-double-array($line_1)" as="xs:double*"/>
        <variable name="d_line_2" select="keronic:cast-string-array-to-double-array($line_2)" as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-ends-connected-to-line-2d(
                          $d_line_1,
                          $d_line_2,
                          $threshold
                          )"/>
    </function>

    <function name="keronic:line-2d-connected-to-area-2d" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="area"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_line" select="keronic:cast-string-array-to-double-array($line)" as="xs:double*"/>
        <variable name="d_area" select="keronic:cast-string-array-to-double-array($area)" as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-ends-connected-to-area-2d(
                          $d_line,
                          $d_area,
                          $threshold
                          )"/>
    </function>


    <!-- FROM AREA FUNCTIONS -->
    <function name="keronic:area-2d-connected-to-point-2d" as="xs:boolean">
        <param name="area" as="xs:string*"/>
        <param name="point"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_area" select="keronic:cast-string-array-to-double-array($area)" as="xs:double*"/>
        <variable name="d_point" select="keronic:cast-string-array-to-double-array($point)" as="xs:double*"/>

        <value-of select="keronic-geom:area-2d-connected-to-point-2d(
                          $d_area,
                          $d_point,
                          $threshold
                          )"/>
    </function>

    <function name="keronic:area-2d-connected-to-line-2d" as="xs:boolean">
        <param name="area" as="xs:string*"/>
        <param name="line"  as="xs:string*"/>
        <param name="threshold" as="xs:double?"/>
        <variable name="d_area" select="keronic:cast-string-array-to-double-array($area)" as="xs:double*"/>
        <variable name="d_line" select="keronic:cast-string-array-to-double-array($line)" as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-ends-connected-to-area-2d(
                          $d_line,
                          $d_area,
                          $threshold
                          )"/>
    </function>

    <function name="keronic:point-2d-to-point-2d-distance" as="xs:double">
        <param name="x1" as="xs:double"/>
        <param name="y1" as="xs:double"/>
        <param name="x2" as="xs:double"/>
        <param name="y2" as="xs:double"/>

        <sequence select="keronic-geom:point-2d-to-point-2d-distance(
                          $x1,
                          $y1,
                          $x2,
                          $y2)"/>
    </function>

    <function name="keronic:area-2d-interacts-with-area-2d" as="xs:boolean">
        <param name="area_1" as="xs:string*"/>
        <param name="area_2" as="xs:string*"/>

        <variable name="d_area_1" select="keronic:cast-string-array-to-double-array($area_1)" as="xs:double*"/>
        <variable name="d_area_2" select="keronic:cast-string-array-to-double-array($area_2)" as="xs:double*"/>

        <value-of select="keronic-geom:area-2d-interacts-with-area-2d(
                          $d_area_1,
                          $d_area_2)"/>
    </function>
</stylesheet>
