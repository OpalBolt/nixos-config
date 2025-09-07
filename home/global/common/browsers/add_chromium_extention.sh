#!/usr/bin/env bash
set -euo pipefail

# Browser to use - change this line to switch browsers
BROWSER="brave"  # Options: "brave", "chromium", "ungoogled-chromium"

# Verbosity levels: 0=quiet, 1=normal, 2=verbose, 3=very verbose
VERBOSE=1

# Parse verbosity flags
while [[ $# -gt 0 ]]; do
    case $1 in
        -v) VERBOSE=2; shift ;;
        -vv) VERBOSE=3; shift ;;
        -q|--quiet) VERBOSE=0; shift ;;
        *) break ;;
    esac
done

# Logging functions
log() { [[ $VERBOSE -ge 1 ]] && echo "$*" || true; }
logv() { [[ $VERBOSE -ge 2 ]] && echo "→ $*" >&2 || true; }
logvv() { [[ $VERBOSE -ge 3 ]] && echo "→ $*" >&2 || true; }

# Get extension info from Chrome Web Store
fetch_extension() {
    local ext_id="$1"
    logv "Getting ${BROWSER} version..."
    local major_version
    
    case "$BROWSER" in
        "brave")
            # For Brave, use the Chromium version from nixpkgs since Brave's version numbering
            # doesn't directly correspond to Chromium version
            if command -v nix >/dev/null 2>&1; then
                major_version=$(nix eval --impure --expr "with import <nixpkgs> {}; lib.versions.major pkgs.chromium.version" 2>/dev/null | tr -d '"')
                logv "Using Chromium version from nixpkgs: $major_version"
            fi
            # Fallback to local browser version if nix eval fails
            if [[ -z "$major_version" ]]; then
                major_version=$($BROWSER --version | awk '{print $3}' | cut -d. -f1)
                logv "Fallback to local Brave version: $major_version"
            fi
            ;;
        "chromium"|"ungoogled-chromium")
            major_version=$($BROWSER --version | awk '{print $2}' | cut -d. -f1)
            ;;
        *)
            echo "✗ Unsupported browser: $BROWSER" >&2
            echo "Supported browsers: brave, chromium, ungoogled-chromium" >&2
            return 1
            ;;
    esac
    
    logvv "Using ${BROWSER} major version: $major_version"
    
    local url="https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${major_version}&x=id%3D${ext_id}%26installsource%3Dondemand%26uc"
    logv "Downloading extension from Chrome Web Store..."
    
    local tmpfile
    tmpfile=$(mktemp)
    trap 'rm -f "$tmpfile"' RETURN
    
    if ! curl -sL "$url" -o "$tmpfile"; then
        echo "✗ Failed to download extension" >&2
        return 1
    fi
    
    logv "Getting version from redirect..."
    local redirect_url
    redirect_url=$(curl -sI "$url" | grep -i '^location:' | awk '{print $2}' | tr -d '\r')
    
    logvv "Full curl headers output:"
    [[ $VERBOSE -ge 3 ]] && curl -sI "$url" >&2 || true
    
    if [[ -z "$redirect_url" ]]; then
        echo "✗ Could not get redirect URL" >&2
        echo "URL used: $url" >&2
        return 1
    fi
    
    logvv "Redirect URL: $redirect_url"
    local version
    version=$(basename "$redirect_url" | sed -E 's/.*_([0-9]+_[0-9]+_[0-9]+_[0-9]+)\.crx/\1/' | tr '_' '.')
    logvv "Extracted version: $version"
    
    logv "Calculating SHA256..."
    local sha256
    sha256=$(nix hash file --type sha256 "$tmpfile" | sed 's/sha256-/sha256:/')
    logvv "SHA256: $sha256"
    
    echo "$sha256|$version"
}

if [[ $# -eq 0 ]]; then
    log "Updating existing extensions in chromium.nix..."
    # Update existing extensions - avoid pipe to while loop issue
    extension_ids=$(grep 'id = ' chromium.nix | sed 's/.*id = "\([^"]*\)".*/\1/')
    
    for ext_id in $extension_ids; do
        log "Processing extension $ext_id..."
        if info=$(fetch_extension "$ext_id"); then
            sha256=$(echo "$info" | cut -d'|' -f1)
            version=$(echo "$info" | cut -d'|' -f2)
            
            logv "Updating $ext_id to version $version"
            if sed -i "/id = \"$ext_id\"/{n; s|sha256 = \"[^\"]*\"|sha256 = \"$sha256\"|; n; s|version = \"[^\"]*\"|version = \"$version\"|}" chromium.nix; then
                log "✓ Updated $ext_id to $version"
            else
                echo "✗ Failed to update file for $ext_id" >&2
            fi
        else
            echo "✗ Failed to fetch extension info for $ext_id" >&2
        fi
    done
elif [[ $# -eq 2 ]]; then
    # Add new extension
    name="$1"
    ext_id="$2"
    log "Adding new extension: $name ($ext_id)"
    
    # Check if extension already exists
    if grep -q "id = \"$ext_id\"" chromium.nix; then
        echo "✗ Extension $ext_id already exists in chromium.nix"
        exit 1
    fi
    
    info=$(fetch_extension "$ext_id")
    sha256=$(echo "$info" | cut -d'|' -f1)
    version=$(echo "$info" | cut -d'|' -f2)
    
    logv "Adding extension with SHA: $sha256, Version: $version"
    
    # Find the line number of the last ]; and insert before it
    insert_line=$(grep -n '^      \];$' chromium.nix | tail -1 | cut -d: -f1)
    
    if [[ -z "$insert_line" ]]; then
        echo "✗ Could not find extensions array closing bracket"
        exit 1
    fi
    
    logvv "Inserting extension at line $((insert_line))"
    
    # Use a more reliable approach with temporary file
    tmpfile=$(mktemp)
    
    # Copy everything before the insert line
    head -n $((insert_line - 1)) chromium.nix > "$tmpfile"
    
    # Add the new extension
    cat >> "$tmpfile" << EOF
        (createChromiumExtension {
          # $name
          id = "$ext_id";
          sha256 = "$sha256";
          version = "$version";
        })
EOF
    
    # Add the rest of the file
    tail -n +$insert_line chromium.nix >> "$tmpfile"
    
    # Replace the original file
    mv "$tmpfile" chromium.nix
    
    log "✓ Successfully added $name ($ext_id) version $version"
else
    echo "Usage: $0 [-v|-vv|-q] [NAME EXT_ID]"
    echo ""
    echo "Verbosity levels:"
    echo "  (default)  Quiet with confirmations"
    echo "  -v         Semi verbose"
    echo "  -vv        Very verbose"
    echo "  -q         Completely quiet"
    echo ""
    echo "Commands:"
    echo "  No args: Update existing extensions"
    echo "  2 args:  Add new extension"
fi
