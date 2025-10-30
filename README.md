# SOPS AGE Decrypt Action

This action decrypts a SOPS-encrypted file using an AGE private key provided via environment variable.

## Environment

- AGE_PRIVATE_KEY: required. The AGE private key string. Exported internally as `SOPS_AGE_KEY` for `sops`.

## Inputs

- encrypted_path: required. Path to the encrypted file (relative to the working directory or absolute).
- decrypted_path: required. Path to write the decrypted file (created/overwritten).
- working_directory: optional. Directory to `cd` into before running decryption.

`.sops.yml` (or `.sops.yaml`) should exist in your repository to guide SOPS. In GitHub Actions, the repository is mounted at `/github/workspace`, so your `.sops.yml` is available to the container automatically.

## Example usage

```yaml
  - name: Decrypt secrets
    uses: r26d/sops-action@v0.0.2"
    env:
      AGE_PRIVATE_KEY: ${{ secrets.AGE_PRIVATE_KEY }}
    with:
      working_directory: .
      encrypted_path: secrets.enc.yaml
      decrypted_path: secrets.yaml
```
