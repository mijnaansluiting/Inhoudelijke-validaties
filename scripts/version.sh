available_versions=$(find validation_schemas -mindepth 1 -maxdepth 1 -type d -name 'v*' -printf '%f\n' | sort -V)

version=${1:-$(tail -n1 <<< "$available_versions")}

if ! grep -qxF "$version" <<< "$available_versions"; then
    echo "::error title=Unknown version::'$version' not found. Available: $(echo $available_versions)"
    exit 1
fi
