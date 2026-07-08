<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:ma="http://example.com/mijnaansluiting"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:nlcs="NS_NLCSnetbeheer"
            xmlns:map="http://www.w3.org/2005/xpath-functions/map"
            version="3.0">

    <!-- ==========================================================
         Shared mof/overdrachtspunt <-> kabel/eaarddraad connectivity
         index. Computed once per run, lazily on first reference (XSLT
         global variables are evaluated lazily per spec), and reused by
         R.20, R.22, R.23, R.25, R.26 and R.39 instead of each doing its
         own brute-force //nlcs:XXXkabel[...] scan (R.22/R.23 were
         additionally doing a *nested* rescan per connected mof).

         Represented as XPath 3.1 maps (mof-id -> kabel-ids, and its
         inverse) rather than a constructed <Touch> element tree indexed
         via xsl:key. An earlier element/xsl:key-based version of this
         file reproducibly hit a Saxon evaluation-order defect once the
         (points x lines) loop ran at benchmark.xml scale (~142k pairs)
         inside the full compiled Schematron schema: point/line arguments
         were occasionally resolved against a stale context by the time a
         lazily-deferred call was actually forced, raising a spurious
         "empty sequence" type error uncorrelated with the actual data —
         confirmed harmless (every pair evaluates cleanly in isolation)
         but not reliably avoidable while building a large node tree via
         push-style xsl:for-each/xsl:variable. Building the same
         relationship as two maps instead avoids constructing any nodes
         and avoids xsl:key altogether for the touch relationship itself,
         side-stepping that evaluation path entirely.
         ========================================================== -->

    <!-- populations covered by the index -->
    <variable name="connectivity_points" as="node()*"
        select="//nlcs:MSmof | //nlcs:LSmof | //nlcs:Eaardmof |
                //nlcs:MSoverdrachtspunt | //nlcs:LSoverdrachtspunt | //nlcs:OVLoverdrachtspunt"/>

    <variable name="connectivity_lines" as="node()*"
        select="//nlcs:MSkabel | //nlcs:LSkabel | //nlcs:HSkabel | //nlcs:Eaarddraad"/>

    <!-- dereference a touched object's nlcs:ID back to the real source-document node -->
    <key name="connectivity-point-by-id"
         match="nlcs:MSmof | nlcs:LSmof | nlcs:Eaardmof |
                nlcs:MSoverdrachtspunt | nlcs:LSoverdrachtspunt | nlcs:OVLoverdrachtspunt"
         use="nlcs:ID"/>

    <key name="connectivity-line-by-id"
         match="nlcs:MSkabel | nlcs:LSkabel | nlcs:HSkabel | nlcs:Eaarddraad"
         use="nlcs:ID"/>

    <!-- anchor node for the 3-arg key() lookups above (source document, single node) -->
    <variable name="connectivity_document" select="/"/>

    <!-- mof/overdrachtspunt nlcs:ID (string) -> sequence of touching kabel/eaarddraad nlcs:IDs (string).
         Each point's geometry is parsed exactly once (bound to $parsed_point
         before the map-entry's value is computed); each candidate line's
         geometry is parsed once per point here — cheap relative to the
         string tokenizing this whole index exists to avoid repeating
         per *rule*, since this whole map is itself built exactly once. -->
    <variable name="connectivity_kabel_ids_by_mof_id" as="map(xs:string, xs:string*)">
        <map>
            <for-each select="$connectivity_points">
                <variable name="parsed_point" as="node()">
                    <sequence select="ma:parse-point(nlcs:Geometry)"/>
                </variable>
                <map-entry key="string(nlcs:ID)"
                    select="
                        for $line_object in $connectivity_lines
                        return
                            if (ma:point-touches-line($parsed_point, ma:parse-line($line_object/nlcs:Geometry)))
                            then string($line_object/nlcs:ID)
                            else ()"/>
            </for-each>
        </map>
    </variable>

    <!-- inverse of the above: kabel/eaarddraad nlcs:ID -> sequence of touching mof/overdrachtspunt nlcs:IDs.
         Derived from $connectivity_kabel_ids_by_mof_id (map:merge with the
         "combine" duplicates option concatenates values for repeated keys)
         instead of re-running the geometry scan a second time. -->
    <variable name="connectivity_mof_ids_by_kabel_id" as="map(xs:string, xs:string*)"
        select="
            map:merge(
                for $mof_id in map:keys($connectivity_kabel_ids_by_mof_id)
                return
                    for $kabel_id in map:get($connectivity_kabel_ids_by_mof_id, $mof_id)
                    return map{$kabel_id: $mof_id},
                map{'duplicates': 'combine'})"/>

    <!-- ==========================================================
         Public API used by the 6 abstract patterns
         ========================================================== -->

    <!-- All kabel/eaarddraad-type objects (any type) that touch the given mof/overdrachtspunt object -->
    <function name="ma:touching-kabels" as="node()*">
        <param name="point_object" as="node()"/>
        <variable name="kabel_ids" as="xs:string*"
            select="map:get($connectivity_kabel_ids_by_mof_id, string($point_object/nlcs:ID))"/>
        <for-each select="$kabel_ids">
            <sequence select="key('connectivity-line-by-id', ., $connectivity_document)"/>
        </for-each>
    </function>

    <!-- All mof/overdrachtspunt-type objects (any type) that touch the given kabel/eaarddraad object -->
    <function name="ma:touching-moffen" as="node()*">
        <param name="kabel_object" as="node()"/>
        <variable name="mof_ids" as="xs:string*"
            select="map:get($connectivity_mof_ids_by_kabel_id, string($kabel_object/nlcs:ID))"/>
        <for-each select="$mof_ids">
            <sequence select="key('connectivity-point-by-id', ., $connectivity_document)"/>
        </for-each>
    </function>

    <!-- Distinct kabels of $kabel_type touched by ANY of $moffen (the "second hop" R.22/R.23 need) -->
    <function name="ma:touching-kabels-via-moffen" as="node()*">
        <param name="moffen" as="node()*"/>
        <param name="kabel_type" as="xs:string"/>
        <variable name="kabel_ids" as="xs:string*"
            select="distinct-values(
                for $mof in $moffen
                return map:get($connectivity_kabel_ids_by_mof_id, string($mof/nlcs:ID)))"/>
        <for-each select="$kabel_ids">
            <variable name="kabel" select="key('connectivity-line-by-id', ., $connectivity_document)"/>
            <if test="name($kabel) = $kabel_type">
                <sequence select="$kabel"/>
            </if>
        </for-each>
    </function>
</stylesheet>
