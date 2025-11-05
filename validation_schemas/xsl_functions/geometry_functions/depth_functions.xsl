<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	        xmlns:keronic="http://example.com/my-functions"
            xmlns:keronic-geom="http://example.com/my-functions-test"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:nlcs="NS_NLCSnetbeheer"
            xmlns:gml="http://www.opengis.net/gml/3.2"
	        version="3.0">

    <function name="keronic-geom:change-depth-of-point-by-maaiveld-height-world" as="xs:string*">
        <param name="point" as="xs:string*"/>
        <param name="maaiveld_height" as="xs:double"/>

        <sequence select="
                          for $index in 1 to count($point)
                          return
                          if ($index = 3)
                          then xs:string(($maaiveld_height + number($point[$index])))
                          else $point[$index]
                          "/>
    </function>

      <function name="keronic-geom:change-depth-of-point-by-maaiveld-height-relative" as="xs:string*">
        <param name="point" as="xs:string*"/>
        <param name="maaiveld_height" as="xs:double"/>

        <sequence select="
                          for $index in 1 to count($point)
                          return
                          if ($index = 3)
                          then xs:string(($maaiveld_height - number($point[$index])))
                          else $point[$index]
                          "/>
    </function>

    <function name="keronic-geom:find-closest-maaiveld-height-to-point" as="xs:double">
        <param name="point" as="xs:string*"/>
        <param name="maaivelden" as="element()*"/>

        <variable name="distances"
                  select="
                          for $mv_point in $maaivelden/nlcs:Geometry/gml:Point/gml:pos
                          return
                          let $mv_point_tok := tokenize($mv_point)
                          return
                          keronic-geom:point-2d-to-point-2d-distance(
                          xs:double($point[position() = 1]),
                          xs:double($point[position() = 2]),
                          xs:double($mv_point_tok[position() = 1]),
                          xs:double($mv_point_tok[position() = 2])
                          )
                          "
                  as="xs:double*"/>

        <variable name="minimum_distance"
                  select="min($distances)"
                  as="xs:double"/>

        <variable name="closest_maaiveld"
                  select="$maaivelden[
                          let $mv_point := nlcs:Geometry/gml:Point/gml:pos
                          return
                          let $mv_point_tok := tokenize($mv_point)
                          return
                          keronic-geom:point-2d-to-point-2d-distance(
                          xs:double($point[position() = 1]),
                          xs:double($point[position() = 2]),
                          xs:double($mv_point_tok[position() = 1]),
                          xs:double($mv_point_tok[position() = 2])
                          )
                          = $minimum_distance]"/>

        <value-of select="xs:double(tokenize($closest_maaiveld/nlcs:Geometry/gml:Point/gml:pos)[position() = 3])"/>
    </function>
</stylesheet>
