#!/usr/bin/env bash
set -euo pipefail

flutter create \
  --platforms=android,ios \
  --org org.tenantsage \
  --project-name driver \
  .

rm -f test/widget_test.dart

echo "Platform projects are present. Review bundle IDs and signing before release."
