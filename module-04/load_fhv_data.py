"""Load the 2019 FHV trip files for Module 4 homework Q6 into an existing GCS bucket."""

from __future__ import annotations

import argparse
import tempfile
import urllib.request
from pathlib import Path

from google.cloud import storage


BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv"
YEAR = 2019
MONTHS = range(1, 13)  # 1..12; range excludes the right end


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Upload 2019 FHV csv.gz files to GCS."
    )
    parser.add_argument("--bucket", required=True, help="Existing GCS bucket name")
    parser.add_argument(
        "--prefix",
        default="module-04/fhv",
        help="Object prefix inside the bucket (default: module-04/fhv)",
    )
    return parser.parse_args()


def download_file(month: int, download_dir: Path) -> Path:
    filename = f"fhv_tripdata_{YEAR}-{month:02d}.csv.gz"
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

    # Files go to a temp folder outside the repo and are deleted afterwards.
    with tempfile.TemporaryDirectory() as temp_dir:
        download_dir = Path(temp_dir)
        for month in MONTHS:
            local_path = download_file(month, download_dir)
            upload_file(bucket, local_path, args.prefix)


if __name__ == "__main__":
    main()
