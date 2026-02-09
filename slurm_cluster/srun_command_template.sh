#!/bin/bash
# =============================================================================
# SLURM srun Template
# Usage: ./srun_command.sh <command>
# Example: ./srun_command.sh python train.py
# =============================================================================

# --- Configuration -----------------------------------------------------------
PARTITION="gpu"           # Change to your partition name
NUM_GPUS=1                # Number of GPUs
NUM_CPUS=8                # Number of CPUs
MEMORY="32G"              # Memory allocation
TIME="04:00:00"           # Time limit

# Project directory (where conda is installed)
PROJECT_DIR="/path/to/your/project"  # CHANGE THIS

# Conda environment to activate (leave empty for base)
CONDA_ENV="myenv"         # CHANGE THIS to your environment name

# --- Parse command line arguments --------------------------------------------
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <command>"
    echo "Example: $0 python train.py --epochs 100"
    exit 1
fi

COMMAND="$@"

# --- Run with srun -----------------------------------------------------------
echo "Running command on compute node..."
echo "  Command: ${COMMAND}"
echo ""

srun \
    --partition="${PARTITION}" \
    --gres="gpu:${NUM_GPUS}" \
    --cpus-per-task="${NUM_CPUS}" \
    --mem="${MEMORY}" \
    --time="${TIME}" \
    --pty \
    bash -c "
        # Source environment setup (sets all cache directories)
        source ${PROJECT_DIR}/setup_env.sh
        
        # Activate conda environment
        if [[ -n '${CONDA_ENV}' ]]; then
            conda activate ${CONDA_ENV}
        fi
        
        # Print environment info
        echo 'Running on: \$(hostname)'
        echo 'Python: \$(which python)'
        echo 'CUDA visible devices: \${CUDA_VISIBLE_DEVICES}'
        echo ''
        
        # Execute the command
        ${COMMAND}
    "

# =============================================================================
# Quick one-liner examples (copy and modify):
# =============================================================================
#
# Basic srun (interactive):
# srun --partition=gpu --gres=gpu:1 --cpus-per-task=8 --mem=32G --time=01:00:00 --pty bash
#
# Then manually:
#   source /path/to/project/setup_env.sh
#   conda activate myenv
#   python your_script.py
#
# Direct execution:
# srun --partition=gpu --gres=gpu:1 --mem=32G bash -c "source /path/to/project/setup_env.sh && conda activate myenv && python train.py"