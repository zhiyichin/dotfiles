#!/bin/bash
# =============================================================================
# SLURM Array Job Template for Hyperparameter Sweeps
# Usage: sbatch slurm_array_job.sh
# =============================================================================

#SBATCH --job-name=sweep                # Job name
#SBATCH --partition=gpu                 # Partition name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --time=08:00:00
#SBATCH --output=logs/%x_%A_%a.out      # %A=array job id, %a=array task id
#SBATCH --error=logs/%x_%A_%a.err
#SBATCH --array=0-9                     # Run 10 jobs (indices 0-9)
# #SBATCH --array=0-9%3                 # Run max 3 jobs at a time

# =============================================================================
# Environment Setup
# =============================================================================

PROJECT_DIR="/path/to/your/project"     # CHANGE THIS
CONDA_ENV="myenv"                        # CHANGE THIS
WORK_DIR="${PROJECT_DIR}/your_code"

mkdir -p logs

source "${PROJECT_DIR}/setup_env.sh"
conda activate "${CONDA_ENV}"

cd "${WORK_DIR}"

echo "=============================================="
echo "Array Job Task ${SLURM_ARRAY_TASK_ID} of ${SLURM_ARRAY_TASK_COUNT}"
echo "Running on: $(hostname)"
echo "=============================================="

# =============================================================================
# Method 1: Simple index-based configuration
# =============================================================================

# Define hyperparameters as arrays
SEEDS=(42 123 456 789 1234 5678 91011 121314 151617 181920)
LEARNING_RATES=(1e-3 1e-4 1e-5 1e-3 1e-4 1e-5 1e-3 1e-4 1e-5 1e-3)

# Get parameters for this task
SEED=${SEEDS[$SLURM_ARRAY_TASK_ID]}
LR=${LEARNING_RATES[$SLURM_ARRAY_TASK_ID]}

echo "Seed: ${SEED}, Learning Rate: ${LR}"

python train.py \
    --seed ${SEED} \
    --learning_rate ${LR} \
    --output_dir "results/run_${SLURM_ARRAY_TASK_ID}"

# =============================================================================
# Method 2: Grid search via index decomposition
# =============================================================================

# # Define hyperparameter options
# SEEDS=(42 123 456)
# LRS=(1e-3 1e-4 1e-5)
# BATCH_SIZES=(16 32)
# 
# # Calculate indices for each hyperparameter
# NUM_SEEDS=${#SEEDS[@]}
# NUM_LRS=${#LRS[@]}
# NUM_BS=${#BATCH_SIZES[@]}
# 
# SEED_IDX=$((SLURM_ARRAY_TASK_ID % NUM_SEEDS))
# LR_IDX=$(((SLURM_ARRAY_TASK_ID / NUM_SEEDS) % NUM_LRS))
# BS_IDX=$(((SLURM_ARRAY_TASK_ID / NUM_SEEDS / NUM_LRS) % NUM_BS))
# 
# SEED=${SEEDS[$SEED_IDX]}
# LR=${LRS[$LR_IDX]}
# BS=${BATCH_SIZES[$BS_IDX]}
# 
# # Total combinations: 3 * 3 * 2 = 18
# # Use: #SBATCH --array=0-17
# 
# python train.py --seed ${SEED} --lr ${LR} --batch_size ${BS}

# =============================================================================
# Method 3: Config file based
# =============================================================================

# # Create a configs/ directory with config_0.yaml, config_1.yaml, etc.
# CONFIG_FILE="configs/config_${SLURM_ARRAY_TASK_ID}.yaml"
# python train.py --config ${CONFIG_FILE}

# =============================================================================
# Method 4: For prompt attribution - run different seeds
# =============================================================================

# # Assuming you want to run 10 seeds for the same prompt
# PROMPT_ID=1060
# SEED=${SLURM_ARRAY_TASK_ID}
# 
# python run_attribution.py \
#     --prompt_id ${PROMPT_ID} \
#     --seed ${SEED} \
#     --output_dir "results/prompt_${PROMPT_ID}/seed_${SEED}"

echo ""
echo "Task ${SLURM_ARRAY_TASK_ID} completed at: $(date)"