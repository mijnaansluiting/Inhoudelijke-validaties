<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	        xmlns:keronic="http://example.com/my-functions"
            xmlns:keronic-geom="http://example.com/my-functions-test"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
	        version="3.0">



    <function name="keronic:line-2d-contains-smaller-angle-than" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="angle" as="xs:string"/>

        <variable name="d_angle"
                  select="xs:double($angle)"
                  as="xs:double"/>
        <variable name="d_line"
                  select="keronic:cast-string-array-to-double-array($line)"
                  as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-contains-smaller-angle-than-arg(
                          $d_line,
                          $d_angle
                          )"/>
    </function>

       <function name="keronic:line-3d-contains-smaller-angle-than" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="angle" as="xs:string"/>

        <variable name="d_angle"
                  select="xs:double($angle)"
                  as="xs:double"/>
        <variable name="d_line"
                  select="keronic:cast-string-array-to-double-array($line)"
                  as="xs:double*"/>

        <value-of select="keronic-geom:line-3d-contains-smaller-angle-than-arg(
                          $d_line,
                          $d_angle
                          )"/>
    </function>

    <function name="keronic:line-2d-contains-larger-angle-than" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="angle" as="xs:string"/>

        <variable name="d_angle"
                  select="xs:double($angle)"
                  as="xs:double"/>
        <variable name="d_line"
                  select="keronic:cast-string-array-to-double-array($line)"
                  as="xs:double*"/>

        <value-of select="keronic-geom:line-2d-contains-larger-angle-than-arg(
                          $d_line,
                          $d_angle
                          )"/>
    </function>

    <function name="keronic:line-3d-contains-larger-angle-than" as="xs:boolean">
        <param name="line" as="xs:string*"/>
        <param name="angle" as="xs:string"/>

        <variable name="d_angle"
                  select="xs:double($angle)"
                  as="xs:double"/>
        <variable name="d_line"
                  select="keronic:cast-string-array-to-double-array($line)"
                  as="xs:double*"/>

        <value-of select="keronic-geom:line-3d-contains-larger-angle-than-arg(
                          $d_line,
                          $d_angle
                          )"/>
    </function>
</stylesheet>
