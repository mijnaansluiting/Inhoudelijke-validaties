<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="gisid-en-assetid" abstract="true">
    <rule context="//nlcs:NLCSnetbeheer/*[not(self::nlcs:AprojectReferentie or (nlcs:Status = 'REVISIE' and nlcs:Bewerking = 'VERPLAATSEN'))]">
        <let name="statuses_requiring_ids"
            value="('BESTAAND', 'REVISIE', 'VERWIJDERD')"/>

        <let name="statuses_requiring_no_ids"
            value="('NIEUW')"/>

        <let name="status_requires_ids"
            value="some $status in ($statuses_requiring_ids) satisfies($status = nlcs:Status)"/>

        <let name="object_has_gis_id"
            value="keronic:element-exists-and-not-empty(nlcs:GisId)"/>

        <let name="object_requires_gis_id"
            value="keronic:object-requires-gis-id(.)"/>

        <assert id="gis-id-required"
            test="if($status_requires_ids and $object_requires_gis_id) then $object_has_gis_id else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('property-required-for-statuses', ['GisId', string-join($statuses_requiring_ids, ', ')])"/>
        </assert>

        <assert id="gis-id-not-allowed"
            test="if(not($status_requires_ids)) then not($object_has_gis_id) else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('property-not-allowed-for-statuses', ['GisId', string-join($statuses_requiring_no_ids, ', ')])"/>
        </assert>

        <let name="object_has_asset_id"
            value="keronic:element-exists-and-not-empty(nlcs:AssetId)"/>

        <let name="object_requires_asset_id"
            value="keronic:object-requires-asset-id(.)"/>

        <assert id="asset-id-required"
            test="if($status_requires_ids and $object_requires_asset_id) then $object_has_asset_id else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('property-required-for-statuses', ['AssetId', string-join($statuses_requiring_ids, ', ')])"/>
        </assert>

        <assert id="asset-id-not-allowed"
            test="if(not($status_requires_ids)) then not($object_has_asset_id) else true()"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('property-not-allowed-for-statuses', ['AssetId', string-join($statuses_requiring_no_ids, ', ')])"/>
        </assert>
    </rule>
</pattern>
