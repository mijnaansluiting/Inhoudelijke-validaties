#!/bin/bash

SAXON_HE_MAJOR=12
SAXON_HE_MINOR=8
SCHXSLT2_VERSION=1.4.4

curl -sSLo SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE-${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}/SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip
unzip -qop SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip saxon-he-${SAXON_HE_MAJOR}.${SAXON_HE_MINOR}.jar > saxon-he.jar
unzip -qo SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip "lib/*"
rm SaxonHE${SAXON_HE_MAJOR}-${SAXON_HE_MINOR}J.zip

curl -sSLo schxslt2-${SCHXSLT2_VERSION}.zip https://codeberg.org/SchXslt/schxslt2/releases/download/v${SCHXSLT2_VERSION}/schxslt2-${SCHXSLT2_VERSION}.zip
unzip -qop schxslt2-${SCHXSLT2_VERSION}.zip schxslt2-${SCHXSLT2_VERSION}/transpile.xsl > transpile.xsl
rm schxslt2-${SCHXSLT2_VERSION}.zip
