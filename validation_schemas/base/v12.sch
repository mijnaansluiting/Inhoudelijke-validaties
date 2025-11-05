<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns ="http://purl.oclc.org/dsdl/schematron"
        xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:math="http://www.w3.org/2005/xpath-functions/math"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:gml="http://www.opengis.net/gml/3.2"
        queryBinding="xslt3">

    <!-- schematron namespace declarations -->
    <ns prefix="keronic" uri="http://example.com/my-functions"/>
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

    <phase id="R.13">
        <active pattern="R.13"/>
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

    <!-- import functions -->
    <xsl:include href="../xsl_functions/global_functions/config_functions.xsl"/>
    <xsl:include href="../xsl_functions/global_functions/localization_functions.xsl"/>
    <xsl:include href="../xsl_functions/global_functions/rule_scope_functions.xsl"/>
    <xsl:include href="../xsl_functions/helper_functions/helper_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/2d_geometry_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/3d_geometry_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/2d_geometry_interface_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/3d_geometry_interface_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/3d_2d_geometry_interface_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/geometry_interface_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/line_interface_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/line_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/depth_functions.xsl"/>
    <xsl:include href="../xsl_functions/geometry_functions/depth_interface_functions.xsl"/>

    <!-- import patterns -->
    <include href="../patterns/v12/R.1.sch"/>
    <include href="../patterns/v12/R.2.sch"/>
    <include href="../patterns/v12/R.3.sch"/>
    <include href="../patterns/v12/R.4_A.sch"/>
    <include href="../patterns/v12/R.4_B.sch"/>
    <include href="../patterns/v12/R.5.sch"/>
    <include href="../patterns/v12/R.6.sch"/>
    <include href="../patterns/v12/R.7.sch"/>
    <include href="../patterns/v12/R.8_A.sch"/>
    <include href="../patterns/v12/R.8_B.sch"/>
    <include href="../patterns/v12/R.9.sch"/>
    <include href="../patterns/v12/R.10.sch"/>
    <include href="../patterns/v12/R.11.sch"/>
    <include href="../patterns/v12/R.12.sch"/>
    <include href="../patterns/v12/R.13.sch"/>
    <include href="../patterns/v12/R.14.sch"/>
    <include href="../patterns/v12/R.15.sch"/>
    <include href="../patterns/v12/R.20.sch"/>
    <include href="../patterns/v12/R.21.sch"/>
    <include href="../patterns/v12/R.22.sch"/>
    <include href="../patterns/v12/R.23.sch"/>
    <include href="../patterns/v12/R.24.sch"/>
    <include href="../patterns/v12/R.25.sch"/>
    <include href="../patterns/v12/R.26.sch"/>
    <include href="../patterns/v12/R.27.sch"/>
    <include href="../patterns/v12/R.28.sch"/>
    <include href="../patterns/v12/R.29.sch"/>
    <include href="../patterns/v12/R.30.sch"/>

    <!-- import abstract patterns -->
    <include href="../abstract_patterns/v12/bestand/bestand_bevat_nlcs_objecten.sch"/>
    <include href="../abstract_patterns/v12/bestand/combinatie_nlcs_status_en_tekeningsoort.sch"/>
    <include href="../abstract_patterns/v12/geometrie/geometrie_binnen_projectvlak.sch"/>
    <include href="../abstract_patterns/v12/geometrie/lijn_geometrie-afstand_van_inmeetpunten.sch"/>
    <include href="../abstract_patterns/v12/geometrie/lijn_geometrie-hoek_van_segmenten.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/gisid_en_assetid.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/inmeetwijze_en_nauwkeurigheid_assets_elec.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/subnettype_ingevuld_voor_ls_en_ms_kabel.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_kabels.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_kabels-ls_extra.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/aanlegdatum_gevuld.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_moffen.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_lsoverdrachtspunt.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_ovloverdrachtspunt.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_msoverdrachtspunt.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_stations_en_kasten.sch"/>
    <include href="../abstract_patterns/v12/verplichte_waarde/verplichte_kenmerken_mantelbuis.sch"/>
    <include href="../abstract_patterns/v12/topologie/topologie_punt_objecten_elec.sch"/>
    <include href="../abstract_patterns/v12/topologie/geldig_eindpunt_kabel.sch"/>
    <include href="../abstract_patterns/v12/netlogica/kabels_zelfde_netvlak.sch"/>
    <include href="../abstract_patterns/v12/netlogica/verbonden_kabels_juiste_kenmerken.sch"/>
    <include href="../abstract_patterns/v12/inhoud_waarde/fase_ms_kabel.sch"/>
    <include href="../abstract_patterns/v12/inhoud_waarde/verbonden_kabels_juiste_fase.sch"/>
    <include href="../abstract_patterns/v12/inhoud_waarde/aantal_kabels_en_mof_functie.sch"/>
    <include href="../abstract_patterns/v12/inhoud_waarde/mantelbuis_past_in_mantelbuis.sch"/>
    <include href="../abstract_patterns/v12/consistentie/mantelbuis_inhoud_aanwezig.sch"/>
    <include href="../abstract_patterns/v12/consistentie/verplaatsing_goed_vastgelegd.sch"/>
    <include href="../abstract_patterns/v12/consistentie/mantelbuis_inhoud_referenties.sch"/>

</schema>
