#!/bin/bash
# =============================================================================
# SLURM Batch Job Template (sbatch)
# Usage: sbatch slurm_job.sh
# =============================================================================

#SBATCH --job-name=my_job              # Job name
#SBATCH --partition=gpu                 # Partition name (CHANGE THIS)
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks=1                      # Number of tasks
#SBATCH --cpus-per-task=8               # CPUs per task
#SBATCH --gres=gpu:1                    # Number of GPUs
#SBATCH --mem=32G                       # Memory
#SBATCH --time=24:00:00                 # Time limit (HH:MM:SS)
#SBATCH --output=logs/%x_%j.out         # Standard output (%x=job name, %j=job id)
#SBATCH --error=logs/%x_%j.err          # Standard error

# Optional SLURM directives:
# #SBATCH --mail-type=BEGIN,END,FAIL    # Email notifications
# #SBATCH --mail-user=your@email.com    # Email address
# #SBATCH --array=0-9                   # Array job (for hyperparameter sweeps)
# #SBATCH --exclude=node01,node02       # Exclude specific nodes
# #SBATCH --nodelist=node03             # Request specific node

# =============================================================================
# Environment Setup
# =============================================================================

# --- kerberos ticket ---------------------------------------------------------
source kauth.sh
refresh_kerberos() {
    while true; do
        sleep 14400
        bash kauth.sh
    done
}
refresh_kerberos &
REFRESH_PID=$!

# --- Project configuration ---------------------------------------------------
PROJECT_DIR="/path/to/your/project"     # CHANGE THIS
CONDA_ENV="myenv"                        # CHANGE THIS to your env name
WORK_DIR="${PROJECT_DIR}/your_code"      # CHANGE THIS to your code directory

# --- Create log directory if it doesn't exist --------------------------------
mkdir -p logs

# --- Source environment setup (sets all cache directories) -------------------
echo "=============================================="
echo "Job started at: $(date)"
echo "Running on node: $(hostname)"
echo "Job ID: ${SLURM_JOB_ID}"
echo "=============================================="
echo ""

source "${PROJECT_DIR}/setup_env.sh"

# --- Activate conda environment ----------------------------------------------
conda activate "${CONDA_ENV}"

echo "Python: $(which python)"
echo "Conda env: ${CONDA_DEFAULT_ENV}"
echo "CUDA_VISIBLE_DEVICES: ${CUDA_VISIBLE_DEVICES}"
echo ""

# --- Navigate to working directory -------------------------------------------
cd "${WORK_DIR}"

# =============================================================================
# Your Code Here
# =============================================================================

# Example: Run a Python script
python train.py \
    --epochs 100 \
    --batch_size 32 \
    --learning_rate 1e-4

# Example: Run with specific GPU visibility
# CUDA_VISIBLE_DEVICES=0 python train.py

# Example: For multi-GPU training
# torchrun --nproc_per_node=2 train.py

# =============================================================================
# Cleanup (optional)
# =============================================================================

kill ${REFRESH_PID}  # stop the kerberos refresh process

echo ""
echo "=============================================="
echo "Job finished at: $(date)"
echo "=============================================="