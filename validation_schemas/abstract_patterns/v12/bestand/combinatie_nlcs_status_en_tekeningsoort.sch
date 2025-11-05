<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="combinatie-nlcs-status-en-tekeningsoort" abstract="true">
    <rule context="//nlcs:NLCSnetbeheer/*[not(self::nlcs:AprojectReferentie)]">
        <let name="tekening_type"
            value="string(//nlcs:AprojectReferentie/nlcs:Tekeningtype)"/>

        <let name="status"
            value="nlcs:Status"/>

        <let name="allowed_statuses"
            value="
                if ($tekening_type = 'BESTAANDE SITUATIE') then
                    ['BESTAAND']
                else if ($tekening_type = 'DEELREVISIE') then
                    ['BESTAAND', 'NIEUW', 'REVISIE', 'VERWIJDERD']
                else if ($tekening_type = 'DEFINITIEF ONTWERP') then
                    ['BESTAAND', 'NIEUW', 'REVISIE', 'VERWIJDERD']
                else if ($tekening_type = 'EINDREVISIE') then
                    ['BESTAAND', 'NIEUW', 'REVISIE', 'VERWIJDERD']
                else if ($tekening_type = 'VOORONTWERP') then
                    []
                else
                    []"/>

        <let name="status_is_allowed"
            value="some $allowed_status in $allowed_statuses satisfies $allowed_status = $status"/>

        <assert id="nlcs-object-has-allowed-status"
            test="$status_is_allowed"
            properties="scope rule-number severity object-type object-id">
            <value-of select="keronic:get-translation-and-replace-placeholders('invalid-status-for-tekening-type', [$status, $tekening_type, string-join($allowed_statuses, ', ')])"/>
        </assert>
    </rule>
</pattern>
