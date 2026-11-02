<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="combinatie-nlcs-status-en-bedrijfstoestand" abstract="true">
    <rule context="//nlcs:NLCSnetbeheer/*[not(self::nlcs:AprojectReferentie)]">
        <let name="bedrijfstoestand"
            value="string(nlcs:Bedrijfstoestand)"/>

        <let name="status"
            value="nlcs:Status"/>

        <let name="allowed_statuses"
            value="
                if ($bedrijfstoestand = 'VERLATEN') then
                    ['BESTAAND', 'REVISIE']
                else if ($bedrijfstoestand = 'RESERVE' or $bedrijfstoestand = 'IN BEDRIJF') then
                    ['BESTAAND', 'NIEUW', 'REVISIE']
                else if ($bedrijfstoestand = 'GEEN') then
                    ['VERWIJDERD']
                else
                    []"/>

        <let name="disallowed_statuses"
            value="$status[not(. = $allowed_statuses)]"/>

        <assert id="objects-have-allowed-status"
            test="empty($disallowed_statuses)"
            properties="rule-number severity">
            <value-of select="ma:get-translation-and-replace-placeholders('invalid-status-for-bedrijfstoestand', [$bedrijfstoestand, string-join($allowed_statuses, ', '), string-join($disallowed_statuses, ', ')])"/>
        </assert>
    </rule>
</pattern>
