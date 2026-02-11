#!/bin/bash
# =============================================================================
# SLURM Interactive Session (salloc) Template
# Usage: ./salloc_interactive.sh
# =============================================================================

# --- Configuration -----------------------------------------------------------
# Modify these based on your cluster's partition names and resources
PARTITION="gpu"           # Change to your partition name
NUM_GPUS=1                # Number of GPUs
NUM_CPUS=8                # Number of CPUs
MEMORY="32G"              # Memory allocation
TIME="04:00:00"           # Time limit (HH:MM:SS)

# Project directory (where conda is installed)
PROJECT_DIR="/path/to/your/project"  # CHANGE THIS

# --- Request allocation ------------------------------------------------------
echo "Requesting interactive allocation..."
echo "  Partition: ${PARTITION}"
echo "  GPUs: ${NUM_GPUS}"
echo "  CPUs: ${NUM_CPUS}"
echo "  Memory: ${MEMORY}"
echo "  Time: ${TIME}"
echo ""

salloc \
    --partition="${PARTITION}" \
    --gres="gpu:${NUM_GPUS}" \
    --cpus-per-task="${NUM_CPUS}" \
    --mem="${MEMORY}" \
    --time="${TIME}" \
    srun --pty bash -c "
        echo '=============================================='
        echo 'Interactive session started on node: \$(hostname)'
        echo '=============================================='
        echo ''
        
        # Source environment setup
        source ${PROJECT_DIR}/setup_env.sh
        
        # Activate base or your preferred environment
        # conda activate myenv  # Uncomment and change to your env name
        
        echo ''
        echo 'Ready! You are now in an interactive shell.'
        echo 'Use: conda activate <env_name> to activate your environment'
        echo ''
        
        # Start interactive shell
        exec bash --login
    "

# --- Alternative: Simple salloc command --------------------------------------
# If you prefer to run commands manually after allocation:
#
# salloc --partition=gpu --gres=gpu:1 --cpus-per-task=8 --mem=32G --time=04:00:00
# srun --pty bash"
#
# Then in the allocated shell:
#   source /path/to/project/setup_env.sh
#   conda activate myenv