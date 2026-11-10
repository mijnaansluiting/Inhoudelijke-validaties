<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="combinatie-nlcs-status-en-tekeningsoort" abstract="true">
    <rule context="//nlcs:NLCSnetbeheer">
        <let name="tekening_type"
            value="string(nlcs:AprojectReferentie/nlcs:Tekeningtype)"/>

        <let name="unique_statuses"
            value="distinct-values(*/nlcs:Status)"/>

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

        <let name="disallowed_statuses"
            value="$unique_statuses[not(. = $allowed_statuses)]"/>

        <assert id="objects-have-allowed-status"
            test="empty($disallowed_statuses)"
            properties="rule-number severity">
            <value-of select="ma:get-translation-and-replace-placeholders('invalid-status-for-tekening-type', [$tekening_type, string-join($allowed_statuses, ', '), string-join($disallowed_statuses, ', ')])"/>
        </assert>
    </rule>
</pattern>
