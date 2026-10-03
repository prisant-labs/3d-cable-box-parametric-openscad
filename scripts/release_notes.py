#!/usr/bin/env python3
"""Print a release's markdown notes body to stdout, read from CHANGELOG.md.

A final tag (vX.Y.Z) and a release-candidate tag (vX.Y.Z-rc.N) read the
changelog differently, because a candidate ships before anyone has folded
its changes into a dated section:

  Final vX.Y.Z        -- the content of the `## [X.Y.Z]` section, verbatim.
                          Refuses if `[Unreleased]` still has entries, because
                          a final release must fold them into its own section
                          first, and refuses if `[X.Y.Z]` does not exist.

  Candidate vX.Y.Z-rc.N -- a short header naming it a release candidate for
                          X.Y.Z, then whatever is still in `[Unreleased]`,
                          then the `[X.Y.Z]` section's content if one already
                          exists (an earlier candidate may have started it).

Usage:
  python scripts/release_notes.py <tag>
  python scripts/release_notes.py v2.0.0
  python scripts/release_notes.py v2.0.0-rc.4
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CHANGELOG = REPO / "CHANGELOG.md"

TAG_RE = re.compile(r"^v(?P<version>\d+\.\d+\.\d+)(?:-(?P<pre>.+))?$")
HEADER_RE = re.compile(r"^## \[(?P<name>[^\]]+)\]")


def parse_sections(text: str) -> dict[str, list[str]]:
    """Split CHANGELOG.md into {section_name: [content lines]}.

    The heading line itself (including any trailing " - YYYY-MM-DD" date,
    which is often a placeholder) is not part of the content.
    """
    sections: dict[str, list[str]] = {}
    current: str | None = None
    buf: list[str] = []
    for line in text.splitlines():
        m = HEADER_RE.match(line)
        if m:
            if current is not None:
                sections[current] = buf
            current = m.group("name")
            buf = []
        elif current is not None:
            buf.append(line)
    if current is not None:
        sections[current] = buf
    return sections


def trimmed(lines: list[str] | None) -> str:
    if not lines:
        return ""
    lines = list(lines)
    while lines and not lines[0].strip():
        lines.pop(0)
    while lines and not lines[-1].strip():
        lines.pop()
    return "\n".join(lines)


def first_nonblank(text: str) -> tuple[str, int]:
    """Return (first substantive line, count of non-blank lines).

    The count includes markdown subheadings like "### Added", so a reader
    gets an accurate sense of how much is still unfolded; the reported
    *line* skips those headings in favour of the first real entry under one.
    """
    nonblank = [l.strip() for l in text.splitlines() if l.strip()]
    content = next((l for l in nonblank if not l.startswith("#")), "")
    return (content or (nonblank[0] if nonblank else ""), len(nonblank))


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("tag", help="release tag, e.g. v2.0.0 or v2.0.0-rc.4")
    args = ap.parse_args()

    m = TAG_RE.match(args.tag)
    if not m:
        print(
            f"error: {args.tag!r} does not look like a version tag "
            "(expected vX.Y.Z or vX.Y.Z-rc.N)",
            file=sys.stderr,
        )
        return 1
    version = m.group("version")
    pre = m.group("pre")

    if not CHANGELOG.exists():
        print(f"error: {CHANGELOG} not found", file=sys.stderr)
        return 1

    # CHANGELOG.md documents the model's own behaviour and is not guaranteed
    # to be ASCII; stdout on Windows defaults to a narrower codepage.
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except AttributeError:
        pass

    sections = parse_sections(CHANGELOG.read_text(encoding="utf-8"))
    unreleased = trimmed(sections.get("Unreleased"))
    version_section = trimmed(sections.get(version))

    if pre:
        # Release candidate: stitch together what a reader needs to decide
        # whether to print-test it, from whatever the changelog has so far.
        if "Unreleased" not in sections:
            print(
                "error: no '## [Unreleased]' section found in CHANGELOG.md; "
                "a release-candidate tag expects one, even if empty",
                file=sys.stderr,
            )
            return 1

        # A link rather than a bare path: release notes render on GitHub's
        # releases page, where a relative path is plain text.
        coupons = ("https://github.com/prisant-labs/3d-cable-box-parametric-openscad"
                   "/tree/main/calibration")
        out = [
            f"This is a release candidate for {version}.",
            "",
            "Further print validation would be helpful before the final "
            f"release. The [calibration coupons]({coupons}) are small test "
            "prints for exactly that.",
        ]
        # One heading over both sections. [Unreleased] can span several
        # candidates, so calling it "new in this candidate" would claim
        # changes an earlier candidate already shipped. What changed since the
        # previous candidate is a judgement, so the person reviewing the draft
        # writes that summary above this (docs/RELEASE.md, section 5).
        body = [part for part in (unreleased, version_section) if part]
        if body:
            out += ["", f"## Full {version} changelog so far", "", "\n\n".join(body)]
        print("\n".join(out))
        return 0

    # Final release.
    if version not in sections:
        print(
            f"error: no '## [{version}]' section found in CHANGELOG.md; "
            "add it before tagging a final release",
            file=sys.stderr,
        )
        return 1

    if unreleased:
        line, count = first_nonblank(unreleased)
        print(
            f"error: '[Unreleased]' still has {count} non-blank "
            f"{'line' if count == 1 else 'lines'} "
            f"(first: \"{line}\"). Fold them into the '[{version}]' section "
            "before tagging a final release.",
            file=sys.stderr,
        )
        return 1

    if not version_section:
        print(
            f"error: the '[{version}]' section in CHANGELOG.md is empty",
            file=sys.stderr,
        )
        return 1

    print(version_section)
    return 0


if __name__ == "__main__":
    sys.exit(main())
