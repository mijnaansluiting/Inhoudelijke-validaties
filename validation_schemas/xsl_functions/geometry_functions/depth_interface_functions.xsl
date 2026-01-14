<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	        xmlns:keronic="http://example.com/my-functions"
            xmlns:keronic-geom="http://example.com/my-functions-test"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
	        version="3.0">

    <function name="keronic:point-apply-world-depth" as="xs:string*">
        <param name="point" as="xs:string*"/>
        <param name="dimension" as="xs:string"/>
        <param name="maaivelden" as="element()*"/>

        <choose>
            <when test="xs:double($dimension) = 2">
                <sequence select="$point"/>
            </when>
            <otherwise>
                <variable name="maaiveld_height"
                          select="keronic-geom:find-closest-maaiveld-height-to-point(
                                  $point,
                                  $maaivelden
                                  )"/>
                <sequence select="keronic-geom:change-depth-of-point-by-maaiveld-height-world(
                                  $point,
                                  $maaiveld_height
                                  )"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:pos-list-apply-world-depth" as="xs:string*">
        <param name="pos_list" as="xs:string*"/>
        <param name="dimension" as="xs:string"/>
        <param name="maaivelden" as="element()*"/>

        <sequence select="for $index in 0 to ((count($pos_list) idiv 3) - 1)
                          return
                          let $act_index := ($index * 3) + 1
                          return
                          keronic:point-apply-world-depth(
                          $pos_list[
                          position() = $act_index or
                          position() = $act_index + 1 or
                          position() = $act_index + 2
                          ],
                          $dimension,
                          $maaivelden
                          )"/>
    </function>

       <function name="keronic:point-apply-relative-depth" as="xs:string*">
        <param name="point" as="xs:string*"/>
        <param name="dimension" as="xs:string"/>
        <param name="maaivelden" as="element()*"/>

        <choose>
            <when test="xs:double($dimension) = 2">
                <sequence select="$point"/>
            </when>
            <otherwise>
                <variable name="maaiveld_height"
                          select="keronic-geom:find-closest-maaiveld-height-to-point(
                                  $point,
                                  $maaivelden
                                  )"/>
                <sequence select="keronic-geom:change-depth-of-point-by-maaiveld-height-relative(
                                  $point,
                                  $maaiveld_height
                                  )"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:pos-list-apply-relative-depth" as="xs:string*">
        <param name="pos_list" as="xs:string*"/>
        <param name="dimension" as="xs:string"/>
        <param name="maaivelden" as="element()*"/>

        <sequence select="for $index in 0 to ((count($pos_list) idiv 3) - 1)
                          return
                          let $act_index := ($index * 3) + 1
                          return
                          keronic:point-apply-relative-depth(
                          $pos_list[
                          position() = $act_index or
                          position() = $act_index + 1 or
                          position() = $act_index + 2
                          ],
                          $dimension,
                          $maaivelden
                          )"/>
    </function>
</stylesheet>
