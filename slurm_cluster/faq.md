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

## Read and write to storage is too slow
**Problem:** Loading checkpoints or data from shared storage (NFS/Lustre) is very slow on compute nodes.

**Solution:** Copy files to local node storage (`$TMPDIR`) at the start of your job script:
```bash
cp -r /path/to/checkpoint/ $TMPDIR/
cp -r /path/to/data/ $TMPDIR/
```
Then point your program to `$TMPDIR` instead. Note: `$TMPDIR` is cleaned up when the job ends.

## Passing parameters to a job
**Problem:** How to pass input parameters to an `sbatch` job.

**Solution:** Use `--export`:
```bash
sbatch --export=PARAM1=value1,PARAM2=value2 slurm_job.sh
```
Then access them in the script as `${PARAM1}`, `${PARAM2}`, etc.
