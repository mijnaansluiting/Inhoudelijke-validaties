<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="geldig-eindpunt-kabel" abstract="true">
    <rule context="//nlcs:MSkabel">
        <let name="line"
            value="ma:parse-line(nlcs:Geometry)"/>
        
        <let name="start_point"
            value="($line[1], $line[2])"/>
        
        <let name="end_point"
            value="($line[count($line) - 1], $line[count($line)])"/>
        
        <let name="start_point_connected"
            value="
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($msmof_geometry))
                )
                or
                (
                    some $msoverdrachtspunt_geometry in //nlcs:MSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($msoverdrachtspunt_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area($start_point, ma:parse-area($msstation_geometry))
                )
            "/>
        
        <let name="end_point_connected"
            value="
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($end_point, ma:parse-point($msmof_geometry))
                )
                or
                (
                    some $msoverdrachtspunt_geometry in //nlcs:MSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point($end_point, ma:parse-point($msoverdrachtspunt_geometry))
                )
                or
                (
                    some $msstation_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area($end_point, ma:parse-area($msstation_geometry))
                )
            "/>
        
        <let name="project_area"
            value="ma:parse-area(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <let name="start_point_within_project_area"
            value="ma:point-interacts-with-area($start_point, $project_area)"/>
        
        <let name="end_point_within_project_area"
            value="ma:point-interacts-with-area($end_point, $project_area)"/>
        
        <let name="is_deserted"
            value="nlcs:Bedrijfstoestand = 'VERLATEN'"/>
        
        <let name="geometries"
            value="
                (if (not($start_point_connected)) then $start_point else (),
                    if (not($end_point_connected)) then $end_point else ())
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
            value="ma:parse-line(nlcs:Geometry)"/>
        
        <let name="start_point"
            value="($line[1], $line[2])"/>
        
        <let name="end_point"
            value="($line[count($line) - 1], $line[count($line)])"/>
        
        <let name="start_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsmof_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:LSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $ovloverdrachtspunt_geometry in //nlcs:OVLoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-touches-area($start_point, ma:parse-point($ovloverdrachtspunt_geometry))
                )
            "/>
        
        <let name="end_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($end_point, ma:parse-point($lsmof_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:LSoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point($end_point, ma:parse-point($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $ovloverdrachtspunt_geometry in //nlcs:OVLoverdrachtspunt/nlcs:Geometry
                    satisfies ma:point-connected-to-point($end_point, ma:parse-point($ovloverdrachtspunt_geometry))
                )
            "/>
        
        <let name="project_area"
            value="ma:parse-area(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <let name="start_point_within_project_area"
            value="ma:point-interacts-with-area($start_point, $project_area)"/>
        
        <let name="end_point_within_project_area"
            value="ma:point-interacts-with-area($end_point, $project_area)"/>
        
        <let name="is_deserted"
            value="nlcs:Bedrijfstoestand = 'VERLATEN'"/>
        
        <let name="geometries"
            value="
                (if (not($start_point_connected)) then $start_point else (),
                    if (not($end_point_connected)) then $end_point else ())
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
            value="ma:parse-line(nlcs:Geometry)"/>
        
        <let name="start_point"
            value="($line[1], $line[2])"/>
        
        <let name="end_point"
            value="($line[count($line) - 1], $line[count($line)])"/>
        
        <let name="start_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsmof_geometry))
                )
                or
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($msmof_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:Eaardmof/nlcs:Geometry
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:Eaardpen/nlcs:Geometry
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area($start_point, ma:parse-area($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:LSkast/nlcs:Geometry
                    satisfies ma:point-touches-area($start_point, ma:parse-area($lsoverdrachtspunt_geometry))
                )
            "/>
        
        <let name="end_point_connected"
            value="
                (
                    some $lsmof_geometry in //nlcs:LSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsmof_geometry))
                )
                or
                (
                    some $msmof_geometry in //nlcs:MSmof/nlcs:Geometry 
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($msmof_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:Eaardmof/nlcs:Geometry
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:Eaardpen/nlcs:Geometry
                    satisfies ma:point-connected-to-point($start_point, ma:parse-point($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:MSstation/nlcs:Geometry
                    satisfies ma:point-touches-area($start_point, ma:parse-area($lsoverdrachtspunt_geometry))
                )
                or
                (
                    some $lsoverdrachtspunt_geometry in //nlcs:LSkast/nlcs:Geometry
                    satisfies ma:point-touches-area($start_point, ma:parse-area($lsoverdrachtspunt_geometry))
                )
            "/>
        
        <let name="project_area"
            value="ma:parse-area(//nlcs:AprojectReferentie/nlcs:Geometry)"/>
        
        <let name="start_point_within_project_area"
            value="ma:point-interacts-with-area($start_point, $project_area)"/>
        
        <let name="end_point_within_project_area"
            value="ma:point-interacts-with-area($end_point, $project_area)"/>
        
        <let name="is_deserted"
            value="nlcs:Bedrijfstoestand = 'VERLATEN'"/>
        
        <let name="geometries"
            value="
                (if (not($start_point_connected)) then $start_point else (),
                    if (not($end_point_connected)) then $end_point else ())
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
