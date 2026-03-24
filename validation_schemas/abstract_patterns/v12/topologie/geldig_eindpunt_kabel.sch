<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="geldig-eindpunt-kabel" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="line"
            value="ma:parse-line-alt(nlcs:Geometry)"/>
        
        <let name="start_point"
            value="$line[1]"/>
        
        <let name="end_point"
            value="$line[count($line)]"/>
        
        <let name="start_point_connected"
            value="
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($msmof_geometry))
                )
                or
                (
                    some $msoverdrachtspunt_geometry in //nlcs:MSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($msoverdrachtspunt_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($start_point, ma:parse-area-alt($msstation_geometry))
                )
            "/>
        
        <let name="end_point_connected"
            value="
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($msmof_geometry))
                )
                or
                (
                    some $msoverdrachtspunt_geometry in //nlcs:MSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($msoverdrachtspunt_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($end_point, ma:parse-area-alt($msstation_geometry))
                )
            "/>
        
        <let name="project_area"
            value="ma:parse-area-alt(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <let name="start_point_within_project_area"
            value="ma:point-interacts-with-area-alt($start_point, $project_area)"/>
        
        <let name="end_point_within_project_area"
            value="ma:point-interacts-with-area-alt($end_point, $project_area)"/>
        
        <let name="is_deserted"
            value="nlcs:Bedrijfstoestand = 'VERLATEN'"/>
        
        <let name="geometries"
            value="
                (if (not($start_point_connected)) then ma:create-gml-point-alt($start_point) else (),
                    if (not($end_point_connected)) then ma:create-gml-point-alt($end_point) else ())
            "/>
        
        <assert id="start_point_connected" 
            properties="scope rule-number severity object-type object-id geometries"
            test="if($start_point_within_project_area and not($is_deserted)) then $start_point_connected else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:ID])"/>
        </assert>
        
        <assert id="end_point_connected"
            properties="scope rule-number severity object-type object-id geometries"
            test="if($end_point_within_project_area and not($is_deserted)) then $end_point_connected else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:ID])"/>
        </assert>
    </rule>
    
    <rule context="//nlcs:LSkabel">
        <let name="line"
            value="ma:parse-line-alt(nlcs:Geometry)"/>
        
        <let name="start_point"
            value="$line[1]"/>
        
        <let name="end_point"
            value="$line[count($line)]"/>
        
        <let name="start_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($lsmof_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:LSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $ovloverdrachtspunt_geometry in //nlcs:OVLoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($ovloverdrachtspunt_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($start_point, ma:parse-area-alt($msstation_geometry))
                )
                or
                (
                    some $lskast_geometry in //nlcs:LSkast/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($start_point, ma:parse-area-alt($lskast_geometry))
                )
            "/>
        
        <let name="end_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($lsmof_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:LSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $ovloverdrachtspunt_geometry in //nlcs:OVLoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($ovloverdrachtspunt_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($start_point, ma:parse-area-alt($msstation_geometry))
                )
                or
                (
                    some $lskast_geometry in //nlcs:LSkast/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($start_point, ma:parse-area-alt($lskast_geometry))
                )
            "/>
        
        <let name="project_area"
            value="ma:parse-area-alt(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <let name="start_point_within_project_area"
            value="ma:point-interacts-with-area-alt($start_point, $project_area)"/>
        
        <let name="end_point_within_project_area"
            value="ma:point-interacts-with-area-alt($end_point, $project_area)"/>
        
        <let name="is_deserted"
            value="nlcs:Bedrijfstoestand = 'VERLATEN'"/>
        
        <let name="geometries"
            value="
                (if (not($start_point_connected)) then ma:create-gml-point-alt($start_point) else (),
                    if (not($end_point_connected)) then ma:create-gml-point-alt($end_point) else ())
            "/>
        
        <assert id="start_point_connected" 
            properties="scope rule-number severity object-type object-id geometries"
            test="if($start_point_within_project_area and not($is_deserted)) then $start_point_connected else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:ID])"/>
        </assert>
        
        <assert id="end_point_connected"
            properties="scope rule-number severity object-type object-id geometries"
            test="if($end_point_within_project_area and not($is_deserted)) then $end_point_connected else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:ID])"/>
        </assert>
    </rule>
    
    <rule context="//nlcs:Eaarddraad">
        <let name="line"
            value="ma:parse-line-alt(nlcs:Geometry)"/>
        
        <let name="start_point"
            value="$line[1]"/>
        
        <let name="end_point"
            value="$line[count($line)]"/>
        
        <let name="start_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($lsmof_geometry))
                )
                or
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($msmof_geometry))
                )
                or
                (
                    some $eaardmof_geometry in //nlcs:Eaardmof/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($eaardmof_geometry))
                )
                or
                (
                    some $eaardpen_geometry in //nlcs:Eaardpen/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($start_point, ma:parse-point-alt($eaardpen_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($start_point, ma:parse-area-alt($msstation_geometry))
                )
                or
                (
                    some $lskast_geometry in //nlcs:LSkast/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($start_point, ma:parse-area-alt($lskast_geometry))
                )
            "/>
        
        <let name="end_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($lsmof_geometry))
                )
                or
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($msmof_geometry))
                )
                or
                (
                    some $eaardmof_geometry in //nlcs:Eaardmof/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($eaardmof_geometry))
                )
                or
                (
                    some $eaardpen_geometry in //nlcs:Eaardpen/nlcs:Geometry
                    satisfies ma:point-connected-to-point-alt($end_point, ma:parse-point-alt($eaardpen_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($end_point, ma:parse-area-alt($msstation_geometry))
                )
                or
                (
                    some $lskast_geometry in //nlcs:LSkast/nlcs:Geometry
                    satisfies ma:point-touches-area-alt($end_point, ma:parse-area-alt($lskast_geometry))
                )
            "/>
        
        <let name="project_area"
            value="ma:parse-area-alt(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <let name="start_point_within_project_area"
            value="ma:point-interacts-with-area-alt($start_point, $project_area)"/>
        
        <let name="end_point_within_project_area"
            value="ma:point-interacts-with-area-alt($end_point, $project_area)"/>
        
        <let name="is_deserted"
            value="nlcs:Bedrijfstoestand = 'VERLATEN'"/>
        
        <let name="geometries"
            value="
                (if (not($start_point_connected)) then ma:create-gml-point-alt($start_point) else (),
                    if (not($end_point_connected)) then ma:create-gml-point-alt($end_point) else ())
            "/>
        
        <assert id="start_point_connected" 
            properties="scope rule-number severity object-type object-id geometries"
            test="if($start_point_within_project_area and not($is_deserted)) then $start_point_connected else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:ID])"/>
        </assert>
        
        <assert id="end_point_connected"
            properties="scope rule-number severity object-type object-id geometries"
            test="if($end_point_within_project_area and not($is_deserted)) then $end_point_connected else true()">
            <value-of select="ma:get-translation-and-replace-placeholders('cable-not-connected-to-valid-object', [nlcs:ID])"/>
        </assert>
    </rule>
</pattern>
