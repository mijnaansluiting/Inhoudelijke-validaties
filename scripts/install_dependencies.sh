#!/bin/bash

SAXON_HE_MAJOR=12
SAXON_HE_MINOR=8
SCHXSLT2_VERSION=1.4.4
NLCS_NETBEHEER_VERSION=12.1
KEUZELIJST_PROVIDER=Enexis
XSD_DOWNLOAD_ATTEMPTS=5

download_xsd() {
    local output=$1
    local url=$2

    for attempt in $(seq 1 $XSD_DOWNLOAD_ATTEMPTS); do
        if curl -fsSLo "$output" "$url" && grep -q "<xs:schema" "$output"; then
            return 0
        fi
        echo "Download of $output failed (attempt $attempt/$XSD_DOWNLOAD_ATTEMPTS)" >&2
        if [[ $attempt -lt $XSD_DOWNLOAD_ATTEMPTS ]]; then
            sleep 5
        fi
    done

    rm -f "$output"
    echo "::error title=XSD download failed::Could not download $output from $url after $XSD_DOWNLOAD_ATTEMPTS attempts" >&2
    return 1
}

curl -sSLo SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE-${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}/SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip
unzip -qop SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip saxon-he-${SAXON_HE_MAJOR}.${SAXON_HE_MINOR}.jar > saxon-he.jar
unzip -qo SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip "lib/*"
rm SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip

curl -sSLo schxslt2-${SCHXSLT2_VERSION}.zip https://codeberg.org/SchXslt/schxslt2/releases/download/v${SCHXSLT2_VERSION}/schxslt2-${SCHXSLT2_VERSION}.zip
unzip -qop schxslt2-${SCHXSLT2_VERSION}.zip schxslt2-${SCHXSLT2_VERSION}/transpile.xsl > transpile.xsl
rm schxslt2-${SCHXSLT2_VERSION}.zip

curl -sSLo xerces-cli.jar https://github.com/krn-sytse/xerces-j/releases/latest/download/xerces-cli.jar
download_xsd NLCS_Netbeheer.xsd https://raw.githubusercontent.com/mijnaansluiting/NLCSpp/refs/heads/main/schemas/V${NLCS_NETBEHEER_VERSION}/NLCS_Netbeheer.xsd || exit 1
download_xsd NLCS_Netbeheer_Keuzelijst.xsd https://raw.githubusercontent.com/mijnaansluiting/NLCSpp/refs/heads/main/schemas/V${NLCS_NETBEHEER_VERSION}/NLCS_Netbeheer${KEUZELIJST_PROVIDER}V${NLCS_NETBEHEER_VERSION}Import_Keuzelijst.xsd || exit 1
