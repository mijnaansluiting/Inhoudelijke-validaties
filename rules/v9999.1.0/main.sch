<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns ="http://purl.oclc.org/dsdl/schematron"
        xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:gml="http://www.opengis.net/gml/3.2"
        queryBinding="xslt3">

    <!-- schematron namespace declarations -->
    <ns prefix="ma" uri="http://example.com/mijnaansluiting"/>
    <ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    <ns prefix="nlcs" uri="NS_NLCSnetbeheer"/>
    <ns prefix="nvr" uri="NLCSValidatieRegelsNameSpace"/>
    <ns prefix="math" uri="http://www.w3.org/2005/xpath-functions/math"/>

    <!-- properties for assert report details -->
    <properties>
        <property id="scope"><value-of select="$scope"/></property>
        <property id="rule-number"><value-of select="$rule_number"/></property>
        <property id="severity"><value-of select="$severity"/></property>
        <property id="object-type"><value-of select="$object_type"/></property>
        <property id="object-id"><value-of select="$object_id"/></property>
        <property id="geometries"><xsl:copy-of select="$geometries"/></property>
        <property id="overlap-point"><xsl:copy-of select="$overlap_point"/></property>
        <property id="missing-attributes"><xsl:copy-of select="$missing_attributes"/></property>
    </properties>

    <!-- declaring the rules -->
    <phase id="R.1">
        <active pattern="R.1"/>
    </phase>

    <phase id="R.2">
        <active pattern="R.2"/>
    </phase>

    <phase id="R.3">
        <active pattern="R.3"/>
    </phase>

    <phase id="R.4">
        <active pattern="R.4-A"/>
        <active pattern="R.4-B"/>
    </phase>

    <phase id="R.5">
        <active pattern="R.5"/>
    </phase>

    <phase id="R.6">
        <active pattern="R.6"/>
    </phase>

    <phase id="R.7">
        <active pattern="R.7"/>
    </phase>

    <phase id="R.8">
        <active pattern="R.8-A"/>
        <active pattern="R.8-B"/>
    </phase>

    <phase id="R.9">
        <active pattern="R.9"/>
    </phase>

    <phase id="R.10">
        <active pattern="R.10"/>
    </phase>

    <phase id="R.11">
        <active pattern="R.11"/>
    </phase>

    <phase id="R.12">
        <active pattern="R.12"/>
    </phase>


    <phase id="R.14">
        <active pattern="R.14"/>
    </phase>

    <phase id="R.15">
        <active pattern="R.15"/>
    </phase>

    <phase id="R.20">
        <active pattern="R.20"/>
    </phase>

    <phase id="R.21">
        <active pattern="R.21"/>
    </phase>

    <phase id="R.22">
        <active pattern="R.22"/>
    </phase>

    <phase id="R.23">
        <active pattern="R.23"/>
    </phase>

    <phase id="R.24">
        <active pattern="R.24"/>
    </phase>

    <phase id="R.25">
        <active pattern="R.25"/>
    </phase>

    <phase id="R.26">
        <active pattern="R.26"/>
    </phase>

    <phase id="R.27">
        <active pattern="R.27"/>
    </phase>

    <phase id="R.28">
        <active pattern="R.28"/>
    </phase>

    <phase id="R.29">
        <active pattern="R.29"/>
    </phase>

    <phase id="R.30">
        <active pattern="R.30"/>
  </phase>
    
    <phase id="R.33">
        <active pattern="R.33"/>
    </phase>
    
    <phase id="R.34">
        <active pattern="R.34"/>
    </phase>

    <phase id="R.31">
        <active pattern="R.31"/>
    </phase>
    
    <phase id="R.32">
        <active pattern="R.32"/>
    </phase>

    <phase id="R.35">
        <active pattern="R.35"/>
    </phase>

    <phase id="R.36">
        <active pattern="R.36"/>
    </phase>

    <phase id="R.37">
        <active pattern="R.37"/>
    </phase>

    <phase id="R.38">
        <active pattern="R.38"/>
    </phase>
  
    <phase id="R.39">
       <active pattern="R.39"/>
    </phase>
    
    <phase id="R.40">
        <active pattern="R.40"/>
    </phase>
    
    <phase id="R.41">
        <active pattern="R.41"/>
    </phase>

    <phase id="R.42">
        <active pattern="R.42"/>
    </phase>

    <phase id="R.43">
        <active pattern="R.43"/>
    </phase>

    <phase id="R.44">
        <active pattern="R.44"/>
    </phase>

    <!-- rule-set version of this schema; must equal the folder name (checked in CI) -->
    <let name="active_version" value="'v9999.1.0'"/>

    <!-- import functions -->
    <xsl:include href="../../xsl_functions/geometry_functions.xsl"/>
    <xsl:include href="../../xsl_functions/config_functions.xsl"/>
    <xsl:include href="../../xsl_functions/localization_functions.xsl"/>
    <xsl:include href="../../xsl_functions/rule_scope_functions.xsl"/>
    <xsl:include href="../../xsl_functions/helper_functions.xsl"/>
    <xsl:include href="../../xsl_functions/connectivity_functions.xsl"/>

    <!-- import patterns -->
    <include href="../v2026.1.0/patterns/R.1.sch"/>
    <include href="../v2026.1.0/patterns/R.2.sch"/>
    <include href="../v2026.1.0/patterns/R.3.sch"/>
    <include href="../v2026.1.0/patterns/R.4_A.sch"/>
    <include href="../v2026.1.0/patterns/R.4_B.sch"/>
    <include href="../v2026.1.0/patterns/R.5.sch"/>
    <include href="../v2026.1.0/patterns/R.6.sch"/>
    <include href="../v2026.1.0/patterns/R.7.sch"/>
    <include href="../v2026.1.0/patterns/R.8_A.sch"/>
    <include href="../v2026.1.0/patterns/R.8_B.sch"/>
    <include href="../v2026.1.0/patterns/R.9.sch"/>
    <include href="../v2026.1.0/patterns/R.10.sch"/>
    <include href="../v2026.1.0/patterns/R.11.sch"/>
    <include href="../v2026.1.0/patterns/R.12.sch"/>
    <include href="../v2026.1.0/patterns/R.14.sch"/>
    <include href="patterns/R.15.sch"/>
    <include href="../v2026.1.0/patterns/R.20.sch"/>
    <include href="../v2026.1.0/patterns/R.21.sch"/>
    <include href="../v2026.1.0/patterns/R.22.sch"/>
    <include href="../v2026.1.0/patterns/R.23.sch"/>
    <include href="../v2026.1.0/patterns/R.24.sch"/>
    <include href="../v2026.1.0/patterns/R.25.sch"/>
    <include href="../v2026.1.0/patterns/R.26.sch"/>
    <include href="../v2026.1.0/patterns/R.27.sch"/>
    <include href="../v2026.1.0/patterns/R.28.sch"/>
    <include href="../v2026.1.0/patterns/R.29.sch"/>
    <include href="../v2026.1.0/patterns/R.30.sch"/>
    <include href="../v2026.1.0/patterns/R.31.sch"/>
    <include href="../v2026.1.0/patterns/R.32.sch"/>
    <include href="../v2026.1.0/patterns/R.33.sch"/>
    <include href="../v2026.1.0/patterns/R.34.sch"/>
    <include href="../v2026.1.0/patterns/R.35.sch"/>
    <include href="../v2026.1.0/patterns/R.36.sch"/>
    <include href="../v2026.1.0/patterns/R.37.sch"/>
    <include href="../v2026.1.0/patterns/R.38.sch"/>
    <include href="../v2026.1.0/patterns/R.39.sch"/>
    <include href="../v2026.1.0/patterns/R.40.sch"/>
    <include href="../v2026.1.0/patterns/R.41.sch"/>
    <include href="../v2026.1.0/patterns/R.42.sch"/>
    <include href="../v2026.1.0/patterns/R.43.sch"/>
    <include href="patterns/R.44.sch"/>

    <!-- import abstract patterns -->
    <include href="../v2026.1.0/abstract_patterns/bestand/aanwezigheid_maaiveldhoogte.sch"/>
    <include href="../v2026.1.0/abstract_patterns/bestand/bestand_bevat_nlcs_objecten.sch"/>
    <include href="../v2026.1.0/abstract_patterns/bestand/combinatie_nlcs_status_en_tekeningsoort.sch"/>
    <include href="../v2026.1.0/abstract_patterns/geometrie/geometrie_binnen_projectvlak.sch"/>
    <include href="../v2026.1.0/abstract_patterns/geometrie/lijn_geometrie-afstand_van_inmeetpunten.sch"/>
    <include href="../v2026.1.0/abstract_patterns/geometrie/lijn_geometrie-hoek_van_segmenten.sch"/>
    <include href="../v2026.1.0/abstract_patterns/geometrie/afstand_mantelbuis_tot_inhoud.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/gisid_en_assetid.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/inmeetwijze_en_nauwkeurigheid_assets_elec.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/subnettype_ingevuld_voor_ls_en_ms_kabel.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_kabels.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_kabels-ls_extra.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/aanlegdatum_gevuld.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_moffen.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_lsoverdrachtspunt.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_ovloverdrachtspunt.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_stations_en_kasten.sch"/>
    <include href="../v9999.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_mantelbuis_eigenaar.sch"/>
    <include href="../v9999.1.0/abstract_patterns/verplichte_waarde/verplichte_kenmerken_kunstwerk.sch"/>
    <include href="../v2026.1.0/abstract_patterns/topologie/topologie_punt_objecten_elec.sch"/>
    <include href="../v2026.1.0/abstract_patterns/topologie/geldig_eindpunt_kabel.sch"/>
    <include href="../v2026.1.0/abstract_patterns/netlogica/kabels_zelfde_netvlak.sch"/>
    <include href="../v2026.1.0/abstract_patterns/netlogica/verbonden_kabels_juiste_kenmerken.sch"/>
    <include href="../v2026.1.0/abstract_patterns/inhoud_waarde/fase_ms_kabel.sch"/>
    <include href="../v2026.1.0/abstract_patterns/inhoud_waarde/inmeetwijze_toegestaande_waarde.sch"/>
    <include href="../v2026.1.0/abstract_patterns/inhoud_waarde/inmeetwijze_aansluitnet_toegestaande_waarde.sch"/>
    <include href="../v2026.1.0/abstract_patterns/inhoud_waarde/verbonden_kabels_juiste_fase.sch"/>
    <include href="../v2026.1.0/abstract_patterns/inhoud_waarde/aantal_kabels_en_mof_functie.sch"/>
    <include href="../v2026.1.0/abstract_patterns/inhoud_waarde/mantelbuis_past_in_mantelbuis.sch"/>
    <include href="../v2026.1.0/abstract_patterns/consistentie/mantelbuis_inhoud_aanwezig.sch"/>
    <include href="../v2026.1.0/abstract_patterns/consistentie/verplaatsing_goed_vastgelegd.sch"/>
    <include href="../v2026.1.0/abstract_patterns/consistentie/mantelbuis_inhoud_referenties.sch"/>
    <include href="../v2026.1.0/abstract_patterns/inhoud_waarde/mof_verbonden_kabels_gelijk_verbindingnummer.sch"/>
    <include href="../v2026.1.0/abstract_patterns/document/aanwezigheid_bestand_bijlage_kunstwerk.sch"/>
    <include href="../v2026.1.0/abstract_patterns/document/aanwezigheid_bestand_bijlage_aanlegtechniek.sch"/>
    <include href="../v2026.1.0/abstract_patterns/bestand/volgnummer_verplicht.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/reden_niet_verwijdering_ingevuld.sch"/>
    <include href="../v2026.1.0/abstract_patterns/document/aanwezigheid_bestand_bijlage_aardpen.sch"/>
    <include href="../v2026.1.0/abstract_patterns/verplichte_waarde/datumtijdmutatie_gevuld.sch"/>
    <include href="../v2026.1.0/abstract_patterns/bestand/combinatie_nlcs_status_en_bedrijfstoestand.sch"/>
    <include href="../v2026.1.0/abstract_patterns/geometrie/lijn_geometrie-afstand_van_inmeetpunten_aaanlegtechniek_en_nabije_objecten.sch"/>

</schema>
