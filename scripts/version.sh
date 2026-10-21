list_versions() {
    for dir in validation_schemas/v*/; do
        [[ -d $dir ]] && basename "$dir"
    done | sort -V
}

# Prints the given version if it exists, otherwise prints an error and fails
resolve_version() {
    local version=$1
    local available_versions
    available_versions=$(list_versions)

    if [[ -z $version ]]; then
        echo "Usage: $0 <version>. Available: $(echo $available_versions)" >&2
        return 1
    fi

    if ! grep -qxF "$version" <<< "$available_versions"; then
        echo "::error title=Unknown version::'$version' not found. Available: $(echo $available_versions)" >&2
        return 1
    fi

    echo "$version"
  }

