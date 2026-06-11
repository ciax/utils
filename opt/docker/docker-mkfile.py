#!/usr/bin/env python3
#alias dmk
"""
===============================================================================
Docker Compose Makefile Generator
===============================================================================

Description:
    This script parses a docker-compose.yml file and generates a Makefile
    that builds Docker services only when their actual dependencies change.

    Instead of using a full directory scan (find), this script analyzes
    Dockerfile COPY/ADD instructions and uses them as dependency sources.
    Each service build is triggered only if relevant files are updated.

    It also uses the "directory timestamp" approach instead of temporary
    stamp files, avoiding unnecessary .gitignore entries.

Key Features:
    - Precise dependency tracking via Dockerfile COPY/ADD
    - Per-service incremental builds
    - No temporary files (.stamp)
    - Clean Makefile output
    - Supports file, directory, and glob COPY patterns

Usage:
    1. Place this script in the same directory as docker-compose.yml
    2. Run:
         python3 generate_makefile.py
    3. A Makefile will be generated automatically
    4. Use:
         make up          # build (if needed) and start
         make up-nobuild  # start without build
         make rebuild     # force rebuild

Requirements:
    - Python 3.7+
    - docker compose (v2+)

Limitations:
    - COPY . is not fully expanded (falls back to no tracking)
    - JSON-array COPY syntax is ignored
    - Multi-stage COPY (--from=) is ignored
    - .dockerignore is not considered

Revision:
    v1.0 (2026-06-10)
        Initial version

Source:
    Generated with assistance from Microsoft 365 Copilot
    Date: 2026-06-10
===============================================================================
"""

import yaml
import re
from pathlib import Path

COMPOSE_FILE = "docker-compose.yml"
OUTPUT = "Makefile"


# -----------------------------
# Load docker-compose.yml
# -----------------------------
def load_compose():
    with open(COMPOSE_FILE, "r") as f:
        return yaml.safe_load(f)


# -----------------------------
# Resolve build config
# -----------------------------
def resolve_build(service):
    build = service.get("build")
    if not build:
        return None, None

    if isinstance(build, str):
        context = build
        dockerfile = Path(context) / "Dockerfile"
    elif isinstance(build, dict):
        context = build.get("context", ".")
        dockerfile = Path(context) / build.get("dockerfile", "Dockerfile")
    else:
        return None, None

    return Path(context), Path(dockerfile)


# -----------------------------
# Parse COPY / ADD
# -----------------------------
def parse_copy_sources(dockerfile):
    sources = []

    if not dockerfile.exists():
        return sources

    with open(dockerfile) as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("#"):
                continue

            if line.startswith("COPY") or line.startswith("ADD"):

                # Ignore JSON form
                if "[" in line:
                    continue

                parts = re.split(r"\s+", line)

                # Skip options (e.g., --chown)
                srcs = [p for p in parts[1:-1] if not p.startswith("--")]

                for src in srcs:
                    sources.append(src)

    return sources


# -----------------------------
# Expand sources
# -----------------------------
def expand_sources(context, sources):
    files = set()

    for src in sources:

        # COPY . case → skip (could fallback to full scan if desired)
        if src.strip() == ".":
            continue

        full = context / src

        # Glob
        if "*" in src or "?" in src:
            for p in context.glob(src):
                if p.is_file():
                    files.add(str(p))
                elif p.is_dir():
                    for f in p.rglob("*"):
                        if f.is_file():
                            files.add(str(f))

        elif full.is_file():
            files.add(str(full))

        elif full.is_dir():
            for f in full.rglob("*"):
                if f.is_file():
                    files.add(str(f))

    return sorted(files)


# -----------------------------
# Generate Makefile
# -----------------------------
def generate_makefile(compose):
    lines = []

    services = compose.get("services", {})
    build_targets = []

    for name, svc in services.items():
        context, dockerfile = resolve_build(svc)

        if not context:
            continue

        sources = parse_copy_sources(dockerfile)
        dep_files = expand_sources(context, sources)

        # Always include Dockerfile
        dep_files.insert(0, str(dockerfile))

        var_name = f"{name.upper()}_DEPS"

        lines.append(f"{var_name} := {' '.join(dep_files)}")
        lines.append("")

        # Directory-touch target
        lines.append(f"{context}: $({var_name})")
        lines.append(f"\t@echo '===> building {name}'")
        lines.append(f"\tdocker compose build {name}")
        lines.append(f"\t@touch {context}")
        lines.append("")

        build_targets.append(str(context))

    # up
    lines.append(".PHONY: up")
    if build_targets:
        lines.append(f"up: {' '.join(build_targets)}")
    else:
        lines.append("up:")
    lines.append("\tdocker compose up -d")
    lines.append("")

    # up (no build)
    lines.append(".PHONY: up-nobuild")
    lines.append("up-nobuild:")
    lines.append("\tdocker compose up -d")
    lines.append("")

    # rebuild
    lines.append(".PHONY: rebuild")
    lines.append("rebuild:")
    lines.append("\tdocker compose build --no-cache")
    lines.append("")

    # down
    lines.append(".PHONY: down")
    lines.append("down:")
    lines.append("\tdocker compose down")
    lines.append("")

    return "\n".join(lines)


# -----------------------------
# Main
# -----------------------------
def main():
    compose = load_compose()
    makefile = generate_makefile(compose)

    Path(OUTPUT).write_text(makefile)
    print(f"✅ Generated {OUTPUT}")


if __name__ == "__main__":
    main()
