# FAQ

## No module named 'pkg_resources' when installing git repo with pip
**Problem:** Installing a git repository using pip fails with `No module named 'pkg_resources'`.

**Solution:**

1. Verify if your setuptools version has pkg_resources:
   ```bash
   python -c "import pkg_resources"
   ```
2. Install a compatible setuptools version:
   ```bash
   pip install setuptools==71.1.0
   ```
3. Verify again:
   ```bash
   python -c "import pkg_resources"
   ```
4. Install the git repo with the `--no-build-isolation` flag:
   ```bash
   pip install --no-build-isolation "git+<REPO_URL>"
   ```

## VSCode GitHub Copilot not working in Remote SSH
**Problem:** GitHub Copilot doesn't work when connected via Remote SSH.
**Solution:**

Add the following to your VSCode `settings.json`:

```json
{
    "remote.extensionKind": {
        "GitHub.copilot": ["ui"],
        "GitHub.copilot-chat": ["ui"]
    },
    "remote.downloadExtensionsLocally": true
}
```
