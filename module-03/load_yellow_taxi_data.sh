#!/usr/bin/env bash

set -euo pipefail

readonly BASE_URL="https://d37ci6vzurychx.cloudfront.net/trip-data"

usage() {
  echo "Usage: $0 BUCKET_NAME [OBJECT_PREFIX]"
  echo "Example: $0 my-existing-bucket module-03"
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 2
fi

readonly BUCKET_NAME="$1"
readonly OBJECT_PREFIX="${2:-module-03}"

command -v curl >/dev/null || {
  echo "curl is required" >&2
  exit 1
}

command -v gcloud >/dev/null || {
  echo "gcloud is required" >&2
  exit 1
}

gcloud storage buckets describe "gs://${BUCKET_NAME}" >/dev/null

for month in {01..06}; do
  filename="yellow_tripdata_2024-${month}.parquet"
  source_url="${BASE_URL}/${filename}"
  object_url="gs://${BUCKET_NAME}/${OBJECT_PREFIX#/}/${filename}"

  echo "Transferring ${source_url}"
  curl --fail --location --retry 3 --silent --show-error "${source_url}" |
    gcloud storage cp \
      --no-clobber \
      --content-type=application/octet-stream \
      - \
      "${object_url}"
done

echo "Verified destination objects:"
gcloud storage ls "gs://${BUCKET_NAME}/${OBJECT_PREFIX#/}/yellow_tripdata_2024-*.parquet"
