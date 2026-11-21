#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
python3 Scripts/check-comments.py
swift test
python3 Scripts/validate-site.py
swift build -c release
