"""Load the 2026 Module 3 homework source files into an existing GCS bucket."""

from __future__ import annotations

import argparse
import tempfile
import urllib.request
from pathlib import Path

from google.cloud import storage


BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data"
MONTHS = range(1, 7)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Upload January-June 2024 Yellow Taxi parquet files to GCS."
    )
    parser.add_argument("--bucket", required=True, help="Existing GCS bucket name")
    parser.add_argument(
        "--prefix",
        default="module-03",
        help="Object prefix inside the bucket (default: module-03)",
    )
    return parser.parse_args()


def download_file(month: int, download_dir: Path) -> Path:
    filename = f"yellow_tripdata_2024-{month:02d}.parquet"
    source_url = f"{BASE_URL}/{filename}"
    local_path = download_dir / filename

    print(f"Downloading {source_url}")
    urllib.request.urlretrieve(source_url, local_path)
    return local_path


def upload_file(bucket: storage.Bucket, local_path: Path, prefix: str) -> None:
    object_name = f"{prefix.strip('/')}/{local_path.name}" if prefix else local_path.name
    blob = bucket.blob(object_name)

    if blob.exists():
        print(f"Exists, skipping: gs://{bucket.name}/{object_name}")
        return

    blob.upload_from_filename(local_path)
    print(f"Uploaded gs://{bucket.name}/{object_name}")


def main() -> None:
    args = parse_args()
    client = storage.Client()
    bucket = client.bucket(args.bucket)
    bucket.reload()

    with tempfile.TemporaryDirectory() as temp_dir:
        download_dir = Path(temp_dir)
        for month in MONTHS:
            local_path = download_file(month, download_dir)
            upload_file(bucket, local_path, args.prefix)


if __name__ == "__main__":
    main()
