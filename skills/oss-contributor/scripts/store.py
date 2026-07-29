#!/usr/bin/env python3
"""Local state for the oss-contributor skill (design D8).

Everything lives under ~/.oss-contributor/ and never leaves the machine:

    profile.yaml   contributor profile (per-technology proficiency)
    targets.yaml   curated watchlist of repositories
    cache/         per-repository analysis, 7-day TTL, schema-versioned
    record.json    contribution record

Health metrics are deliberately NOT cached -- responsiveness is the
fastest-decaying signal and a stale merge rate is exactly the failure the
skill exists to prevent. Only conventions and metadata are cached.
"""

import json
import os
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

SCHEMA_VERSION = 1
CACHE_TTL_DAYS = 7

ROOT = Path(os.environ.get("OSS_CONTRIBUTOR_HOME", Path.home() / ".oss-contributor"))
CACHE_DIR = ROOT / "cache"
PROFILE_PATH = ROOT / "profile.yaml"
TARGETS_PATH = ROOT / "targets.yaml"
RECORD_PATH = ROOT / "record.json"


def now():
    return datetime.now(timezone.utc)


def ensure_root():
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    return ROOT


# --- YAML I/O -------------------------------------------------------------
# PyYAML is not guaranteed present. The documents written here are flat
# enough that a JSON payload inside a .yaml file stays valid YAML (JSON is a
# YAML subset), so round-tripping works either way without a hard dependency.

def _read_doc(path):
    if not path.exists():
        return None
    text = path.read_text()
    if not text.strip():
        return None
    try:
        import yaml  # type: ignore
        return yaml.safe_load(text)
    except ImportError:
        return json.loads(text)


def _write_doc(path, data):
    ensure_root()
    try:
        import yaml  # type: ignore
        text = yaml.safe_dump(data, sort_keys=False, allow_unicode=True)
    except ImportError:
        text = json.dumps(data, indent=2)
    path.write_text(text)
    return path


# --- Profile --------------------------------------------------------------

def read_profile():
    return _read_doc(PROFILE_PATH)


def write_profile(profile):
    profile = dict(profile)
    profile["schema_version"] = SCHEMA_VERSION
    profile["updated_at"] = now().isoformat()
    return _write_doc(PROFILE_PATH, profile)


def profile_age_days():
    """Days since the profile was last updated, or None if absent."""
    profile = read_profile()
    if not profile or not profile.get("updated_at"):
        return None
    updated = datetime.fromisoformat(profile["updated_at"])
    return (now() - updated).days


# --- Targets --------------------------------------------------------------

def read_targets():
    doc = _read_doc(TARGETS_PATH)
    if not doc:
        return {"schema_version": SCHEMA_VERSION, "targets": []}
    if doc.get("schema_version") != SCHEMA_VERSION:
        # Structure changed; treat as empty rather than misreading it.
        return {"schema_version": SCHEMA_VERSION, "targets": [], "reset": True}
    return doc


def write_targets(doc):
    doc = dict(doc)
    doc["schema_version"] = SCHEMA_VERSION
    doc["updated_at"] = now().isoformat()
    return _write_doc(TARGETS_PATH, doc)


# --- Repository cache -----------------------------------------------------

def cache_key(repo):
    return repo.replace("/", "__")


def cache_path(repo):
    return CACHE_DIR / f"{cache_key(repo)}.json"


def read_cache(repo):
    """Return (payload, age_days) or (None, None).

    Returns None when the entry is expired or was written under a different
    schema version -- a stale structure must be discarded, not misread.
    """
    path = cache_path(repo)
    if not path.exists():
        return None, None
    try:
        payload = json.loads(path.read_text())
    except json.JSONDecodeError:
        return None, None

    if payload.get("schema_version") != SCHEMA_VERSION:
        return None, None

    written = payload.get("written_at")
    if not written:
        return None, None
    age = now() - datetime.fromisoformat(written)
    if age > timedelta(days=CACHE_TTL_DAYS):
        return None, None

    return payload.get("data"), age.days


def write_cache(repo, data):
    ensure_root()
    payload = {
        "schema_version": SCHEMA_VERSION,
        "repository": repo,
        "written_at": now().isoformat(),
        "data": data,
    }
    path = cache_path(repo)
    path.write_text(json.dumps(payload, indent=2))
    return path


# --- Contribution record --------------------------------------------------

def read_record():
    if not RECORD_PATH.exists():
        return None
    return json.loads(RECORD_PATH.read_text())


def write_record(record):
    ensure_root()
    payload = {
        "schema_version": SCHEMA_VERSION,
        "written_at": now().isoformat(),
        "data": record,
    }
    RECORD_PATH.write_text(json.dumps(payload, indent=2))
    return RECORD_PATH


def main():
    """Inspection helper: report what state exists."""
    ensure_root()
    profile = read_profile()
    targets = read_targets()
    cached = sorted(p.stem.replace("__", "/") for p in CACHE_DIR.glob("*.json"))

    print(f"home:     {ROOT}")
    age = profile_age_days()
    print(f"profile:  {'present' if profile else 'absent'}"
          + (f" (updated {age}d ago)" if age is not None else ""))
    print(f"targets:  {len(targets.get('targets', []))}")
    print(f"cached:   {len(cached)} repositories")
    for repo in cached:
        _, cache_age = read_cache(repo)
        state = f"{cache_age}d old" if cache_age is not None else "expired"
        print(f"            {repo} ({state})")
    print(f"record:   {'present' if RECORD_PATH.exists() else 'absent'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
