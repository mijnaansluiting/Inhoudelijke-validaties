<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	        xmlns:keronic="http://example.com/my-functions"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:gml="http://www.opengis.net/gml/3.2"
	        version="3.0">

    <function name="keronic:create-gml-point" as="node()*">
        <param name="coords" as="xs:anyAtomicType*"/>
        <param name="dimension" as="xs:integer"/>
        <param name="epsg" as="xs:integer"/>
        <gml:Point srsDimension="{$dimension}" srsName="EPSG:{$epsg}">
            <gml:pos>
                <xsl:value-of select="$coords"/>
            </gml:pos>
        </gml:Point>
    </function>

    <function name="keronic:create-gml-line" as="node()*">
        <param name="coords" as="xs:anyAtomicType*"/>
        <param name="dimension" as="xs:integer"/>
        <param name="epsg" as="xs:integer"/>
        <gml:LineString srsDimension="{$dimension}" srsName="EPSG:{$epsg}">
            <gml:posList>
                <xsl:value-of select="$coords"/>
            </gml:posList>
        </gml:LineString>
    </function>

    <function name="keronic:create-gml-area" as="node()*">
        <param name="coords" as="xs:anyAtomicType*"/>
        <param name="dimension" as="xs:integer"/>
        <param name="epsg" as="xs:integer"/>
        <gml:Polygon srsDimension="{$dimension}" srsName="{$epsg}">
            <gml:exterior>
                <gml:LinearRing>
                    <gml:posList>
                        <xsl:value-of select="$coords"/>
                    </gml:posList>
                </gml:LinearRing>
            </gml:exterior>
        </gml:Polygon>
    </function>

    <function name="keronic:element-exists-and-not-empty" as="xs:boolean">
        <param name="element"/>
        <sequence select="$element and normalize-space($element)"/>
    </function>

    <function name="keronic:vals-within-threshold" as="xs:boolean">
        <param name="value_1" as="xs:double"/>
        <param name="value_2" as="xs:double"/>
        <param name="threshold" as="xs:double"/>
        <choose>
            <when test="($value_1 le $value_2 + $threshold) and
                        ($value_1 ge $value_2 - $threshold)">
                <value-of select="true()"/>
            </when>
            <otherwise>
                <value-of select="false()"/>
            </otherwise>
        </choose>
    </function>

    <function name="keronic:array-2d-get-nth-point" as="xs:double*">
        <param name="d_array" as="xs:double*"/>
        <param name="n" as="xs:integer"/>

        <sequence select="[$d_array[2 * $n - 1], $d_array[2 * $n]]"/>
    </function>

    <function name="keronic:array-3d-get-nth-point" as="xs:double*">
        <param name="d_array" as="xs:double*"/>
        <param name="n" as="xs:integer"/>

        <sequence select="[$d_array[3 * $n - 2], $d_array[3 * $n - 1], $d_array[3 * $n]]"/>
    </function>

    <function name="keronic:cast-string-array-to-double-array" as="xs:double*">
        <param name="string-array" as="xs:string*"/>
        <variable name="double-array" as="xs:double*">
            <for-each select="$string-array">
                <sequence select="xs:double(.)"/>
            </for-each>
        </variable>
        <sequence select="$double-array"/>
    </function>

    <function name="keronic:split-pos-list-to-posses" as="xs:anyAtomicType*">
        <param name="pos_list" as="xs:anyAtomicType*"/>

        <sequence select="for $index in 0 to (count($pos_list) idiv 3 - 1)
                          return
                          let $act_index := ($index * 3) + 1
                          return
                          string-join($pos_list
                          [position() = $act_index or
                          position() = $act_index + 1 or
                          position() = $act_index + 2
                          ], ' ')
                          "/>
    </function>

    <function name="keronic:cast-3d-to-2d-array" as="xs:string*">
        <param name="array-3d" as="xs:string*" />
        <sequence select="
                          for $i in 1 to count($array-3d)
                          return
                          if ($i mod 3 != 0) then $array-3d[$i] else ()
        "/>
    </function>

    <function name="keronic:atan2" as="xs:double">
    <param name="y" as="xs:double"/>
    <param name="x" as="xs:double"/>

    <choose>
        <when test="$x = 0">
            <choose>
             <when test="$y gt 0">
                    <sequence select="math:pi() div 2"/>
                </when>
                <when test="$y lt 0">
                    <sequence select="-math:pi() div 2"/>
                </when>
                <otherwise>
                    <sequence select="0"/>
                </otherwise>
            </choose>
        </when>
        <otherwise>
            <variable name="atan" select="math:atan($y div $x)"/>
            <choose>
                <when test="$x gt 0">
                    <sequence select="$atan"/>
                </when>
                <when test="$x lt 0 and $y ge 0">
                    <sequence select="$atan + math:pi()"/>
                </when>
                <when test="$x lt 0 and $y lt 0">
                    <sequence select="$atan - math:pi()"/>
                </when>
            </choose>
        </otherwise>
    </choose>
</function>

</stylesheet>
