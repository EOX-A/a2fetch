# a2fetch

**a2fetch** is a lightweight wrapper around `aria2c` for efficiently downloading files from a list of HTTP(S) or pre-signed URLs.

It is designed for simple use cases where large numbers of files need to be fetched in parallel, especially from cloud object storage (e.g., AWS S3 pre-signed URLs).

## Features

- Accepts text files with URLs or single HTTPS URLs
- Automatically detects and handles pre-signed URLs
- Downloads files using `aria2c` with sensible defaults
- Supports parallel downloads, resume, and directory flattening

## Installation

Clone the repository and ensure `aria2c` is installed on your system:

```bash
git clone https://github.com/youruser/a2fetch.git
cd a2fetch
chmod +x a2fetch
```

### Debian/Ubuntu

If you're using a Debian-based system:

```bash
curl -O https://your.repo.url/install-debian.sh
chmod +x install-debian.sh
./install-debian.sh
```

## Usage

For text files with URL lists:

```bash
./a2fetch urls.txt ${OUTPUT_PATH}
```

Or directly with a single HTTPS URL:

```bash
./a2fetch "https://example.com/path/to/file.tif?signature=..." ${OUTPUT_PATH}
```

## Requirements

`aria2c` must be installed and available in your $PATH

## Caution

This tool is minimal and intended for controlled, internal use. It does not perform comprehensive validation or sanitization. Please use with care.
Important Notes

- **No Validation:** The script does not verify the contents or origin of the URLs. Malformed or malicious URLs may cause unexpected behavior.
- **Presigned URL Handling:** Pre-signed links often expire and may expose sensitive resources if shared improperly.
- **Overwrites Files:** Files with the same name may be overwritten without warning.
- **Filename Safety:** The script does basic sanitization, but certain edge cases may still cause path or filesystem issues.
- **No Authentication or Rate Limiting:** This tool assumes open access and may fail or be blocked in restricted environments.
