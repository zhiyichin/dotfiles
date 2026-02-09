# SLURM helper scripts for ML experiments

A small collection of simple SLURM script templates and helpers to run experiments on a cluster. Keep them as a starting point — adapt them to your cluster and needs.

## Prerequisites
- Access to a cluster with SLURM.
- Bash and basic familiarity with `sbatch`, `srun`, `salloc`.

## Quick setup ✅
Install conda (miniconda) and create a project workspace:

```bash
bash install_conda.sh <PROJECT_DIR>
```

This creates:
- `miniconda3/`
- `conda_envs/`
- `.cache/` (conda, huggingface, matplotlib, pip, pycache, torch, triton, xdg)

It also writes a `setup_env.sh` script into `<PROJECT_DIR>`. Use it to quickly set paths and activate environments:

```bash
source <PROJECT_DIR>/setup_env.sh
conda activate <ENV_NAME>
```

If you have multiple conda installations on the system, sourcing `setup_env.sh` ensures you use the one created by `install_conda.sh`.

## Usage — templates 🔧
Open a template and edit the variables at the top (job name, time, partition, gpus, conda env, and the command to run).
- Submit a batch job: `sbatch slurm_job_template.sh`
- Start an interactive session: `salloc` (see `salloc_interactive_template.sh`)
- Run a single command: `srun_command_template.sh`
- Run many jobs (e.g., different seeds) in parallel: `slurm_array_job_template.sh`

## Files at a glance
- `install_conda.sh` - install miniconda & create project layout
- `setup_env.sh` - (generated) quick environment loader
- `slurm_job_template.sh` - example `sbatch` job
- `salloc_interactive_template.sh` - example interactive `salloc` script
- `srun_command_template.sh` - `srun` helper
- `slurm_array_job_template.sh` - particularly useful for running multiple seeds per experiment in parallel
- `cache_reference.sh` - list of useful cache directories (copy what you need)

## Tips & cautions ⚠️
- **Always** inspect and adapt templates before running them on your cluster.
- Add any required `module load` or `export` lines for your site.
- For array jobs, make sure to handle seed/indexing and output paths to avoid collisions.
- `cache_reference.sh` is a reference — it is not intended to be run as-is.
