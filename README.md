# a2fetch

**a2fetch** is a lightweight wrapper around `aria2` for efficiently downloading files from a list of HTTP(S) or pre-signed URLs.

It is designed for simple use cases where large numbers of files need to be fetched in parallel, especially from cloud object storage (e.g., AWS S3 pre-signed URLs).

## Features

- Accepts text files with URLs, relative paths, or single HTTPS URLs
- Automatically detects and handles pre-signed URLs
- High performance URL parsing and batch map generation
- Workload slicing into low-RAM chunks to prevent out-of-memory issues with huge datasets
- Native `aria2c` parallel concurrency (`-j`) with automatic directory creation (no `xargs` bottleneck)
- Automatic download resumption and sensible retry handling

## Installation

Clone the repository and ensure `aria2` is installed on your system:

```bash
git clone https://github.com/EOX-A/a2fetch.git
cd a2fetch
chmod +x a2fetch
```

### Debian/Ubuntu Installation

```bash
./install-debian.sh
```

- If running as a regular user without write permissions to `/usr/local/bin`, it installs into `~/.local/bin/a2fetch`.
- If running as root or with write permissions, it installs into `/usr/local/bin/a2fetch`.
- Custom path override: `INSTALL_DIR=/my/bin ./install-debian.sh`

### macOS Installation

```bash
./install-mac.sh
```

- Automatically installs `aria2` via Homebrew (`brew install aria2`) if not already present.
- Detects Homebrew binary paths (`/opt/homebrew/bin` on Apple Silicon or `/usr/local/bin` on Intel) or defaults to `~/.local/bin/a2fetch`.
- Custom path override: `INSTALL_DIR=/my/bin ./install-mac.sh`

## Usage Examples

### 1. Basic Downloads

Download a list of full URLs into default `./output` directory:
```bash
./a2fetch urls.txt
```

Download a list of full URLs into a custom directory:
```bash
./a2fetch urls.txt ./my-downloads
```

Download relative tile paths by providing a base URL:
```bash
./a2fetch index.txt ./my-downloads "https://cloudlessdownloads.eox.at/api/public/dl/28nrhtcj/"
```

Download a single direct or pre-signed URL:
```bash
./a2fetch "https://example.com/path/to/file.tif?signature=..." ./my-downloads
```

---

### 2. Path Depth & Directory Structure Options

When downloading files from URLs with deep paths (e.g. S3 object keys or complex API routes), you can control exactly how local output folders are created:

#### Example URL
```text
https://big-s3.eox.at/eoxcloudless-customers/EOxCloudless_Samples-and-Documentation/viewing-basic-epsg-4326/tile.tif
```

Folder breakdown:
- Level 1: `eoxcloudless-customers` (S3 bucket)
- Level 2: `EOxCloudless_Samples-and-Documentation` (parent folder)
- Level 3: `viewing-basic-epsg-4326` (subfolder)
- Filename: `tile.tif`

#### How Output Control Options Work:

| Option | Command | Resulting Filepath | Explanation |
| --- | --- | --- | --- |
| **Default** *(Auto)* | `./a2fetch urls.txt ./output` | `./output/tile.tif` | Detects common base prefix across dataset and strips it. |
| **`DEPTH=1`** | `DEPTH=1 ./a2fetch urls.txt ./output` | `./output/viewing-basic-epsg-4326/tile.tif` | Keeps only the **1** immediate parent folder before the filename. |
| **`DEPTH=2`** | `DEPTH=2 ./a2fetch urls.txt ./output` | `./output/EOxCloudless_Samples-and-Documentation/viewing-basic-epsg-4326/tile.tif` | Keeps the last **2** folder levels before the filename. |
| **`DEPTH=0`** | `DEPTH=0 ./a2fetch urls.txt ./output` | `./output/tile.tif` | Flattens all downloads directly into `./output` (no subdirectories). |
| **`CUT_DIRS=1`** | `CUT_DIRS=1 ./a2fetch urls.txt ./output` | `./output/EOxCloudless_Samples-and-Documentation/viewing-basic-epsg-4326/tile.tif` | Strips the first **1** leading directory level (the bucket name). |
| **`CUT_DIRS=2`** | `CUT_DIRS=2 ./a2fetch urls.txt ./output` | `./output/viewing-basic-epsg-4326/tile.tif` | Strips the first **2** leading directory levels. |
| **`BASE_URL`** | `./a2fetch urls.txt ./output "https://big-s3.eox.at/eoxcloudless-customers/"` | `./output/EOxCloudless_Samples-and-Documentation/viewing-basic-epsg-4326/tile.tif` | Strips everything matching the `BASE_URL` prefix. |

---

### 3. Performance & Retry Tuning

```bash
# High-concurrency download (32 parallel downloads) with 25,000 files per memory batch
THREADS=32 CHUNK_SIZE=25000 ./a2fetch large_index.txt ./downloads

# Aggressive retry policy (10 retries with 2-second wait between attempts)
MAX_TRIES=10 RETRY_WAIT=2 ./a2fetch urls.txt ./downloads
```

## Requirements

`aria2` must be installed and available in your $PATH

## Caution

This tool is minimal and intended for controlled, internal use. It does not perform comprehensive validation or sanitization. Please use with care.
Important Notes

- **No Validation:** The script does not verify the contents or origin of the URLs. Malformed or malicious URLs may cause unexpected behavior.
- **Presigned URL Handling:** Pre-signed links often expire and may expose sensitive resources if shared improperly.
- **Overwrites Files:** Files with the same name may be overwritten without warning.
- **Filename Safety:** The script does basic sanitization, but certain edge cases may still cause path or filesystem issues.
- **No Authentication or Rate Limiting:** This tool assumes open access and may fail or be blocked in restricted environments.
