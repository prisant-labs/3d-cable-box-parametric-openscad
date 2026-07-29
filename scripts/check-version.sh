#!/usr/bin/env bash
# Verifies that the three places a version is written agree with each other:
#
#   1. Model_Version in the SCAD source
#   2. the top [x.y.z] section of CHANGELOG.md
#   3. the git tag, when running on a tag
#
# A parametric model is distributed as loose files, so a version that lies is
# worse than no version at all: it makes a bug report untraceable. This runs in
# CI on every push and hard-fails a tag build on any mismatch.
set -euo pipefail

SCAD_FILE="${SCAD_FILE:-cable-box-parametric.scad}"
fail=0

note() { printf '  %-22s %s\n' "$1" "$2"; }
err()  { printf '  ERROR: %s\n' "$1"; fail=1; }

# 1. Model_Version from the SCAD
scad_version=$(grep -oE '^Model_Version[[:space:]]*=[[:space:]]*"[^"]+"' "$SCAD_FILE" \
                 | grep -oE '"[^"]+"' | tr -d '"' || true)
[ -n "$scad_version" ] || err "Model_Version not found in $SCAD_FILE"
note "Model_Version" "${scad_version:-<missing>}"

# 2. Top released section of the changelog, skipping [Unreleased]
changelog_version=$(grep -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md \
                      | head -1 | tr -d '#[] ' || true)
[ -n "$changelog_version" ] || err "no released version section found in CHANGELOG.md"
note "CHANGELOG.md" "${changelog_version:-<missing>}"

if [ -n "$scad_version" ] && [ -n "$changelog_version" ] && \
   [ "$scad_version" != "$changelog_version" ]; then
  err "Model_Version ($scad_version) does not match CHANGELOG.md ($changelog_version)"
fi

# 3. Git tag, only when building one. Strip a leading v and any -rc suffix, so
#    v1.2.0-rc.1 validates against Model_Version 1.2.0.
ref="${GITHUB_REF:-}"
case "$ref" in
  refs/tags/*)
    tag="${ref#refs/tags/}"
    base="${tag#v}"; base="${base%%-*}"
    note "git tag" "$tag (base $base)"
    if [ "$base" != "$scad_version" ]; then
      err "tag $tag implies version $base but Model_Version is $scad_version"
    fi
    ;;
  *) note "git tag" "(not a tag build, skipping)" ;;
esac

# 4. The SCAD must actually echo the version, or traceability is theoretical
grep -q 'echo(str("cable-box-parametric ", Model_Version))' "$SCAD_FILE" \
  || err "$SCAD_FILE does not echo Model_Version at render time"

if [ "$fail" -ne 0 ]; then
  echo "version consistency check FAILED"
  exit 1
fi
echo "version consistency check passed"
