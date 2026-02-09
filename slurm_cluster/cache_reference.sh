# =============================================================================
# Cache Directory Reference for ML Research
# =============================================================================
# Add these to your setup_env.sh or job scripts to ensure all caches
# go to your project directory instead of $HOME
# =============================================================================

# --- Base paths (set these first) --------------------------------------------
export PROJECT_DIR="/path/to/your/project"
export CACHE_DIR="${PROJECT_DIR}/.cache"

# --- Conda -------------------------------------------------------------------
export CONDA_PKGS_DIRS="${CACHE_DIR}/conda/pkgs"
export CONDA_ENVS_PATH="${PROJECT_DIR}/conda_envs"

# --- Python/Pip --------------------------------------------------------------
export PIP_CACHE_DIR="${CACHE_DIR}/pip"
export PYTHONPYCACHEPREFIX="${CACHE_DIR}/pycache"
export PYTHONDONTWRITEBYTECODE=1  # Optional: disable .pyc files entirely

# --- HuggingFace -------------------------------------------------------------
export HF_HOME="${CACHE_DIR}/huggingface"
export HF_DATASETS_CACHE="${CACHE_DIR}/huggingface/datasets"
export TRANSFORMERS_CACHE="${CACHE_DIR}/huggingface/transformers"
export HUGGINGFACE_HUB_CACHE="${CACHE_DIR}/huggingface/hub"

# Offline mode (useful if you pre-downloaded models)
# export HF_DATASETS_OFFLINE=1
# export TRANSFORMERS_OFFLINE=1

# --- PyTorch -----------------------------------------------------------------
export TORCH_HOME="${CACHE_DIR}/torch"
export TORCH_EXTENSIONS_DIR="${CACHE_DIR}/torch/extensions"

# Triton cache (for torch.compile)
export TRITON_CACHE_DIR="${CACHE_DIR}/triton"

# --- TensorFlow (if needed) --------------------------------------------------
export TFHUB_CACHE_DIR="${CACHE_DIR}/tfhub"
export TF_CPP_MIN_LOG_LEVEL=2  # Reduce TF logging verbosity

# --- General XDG -------------------------------------------------------------
export XDG_CACHE_HOME="${CACHE_DIR}/xdg"
export XDG_DATA_HOME="${CACHE_DIR}/xdg/data"
export XDG_CONFIG_HOME="${CACHE_DIR}/xdg/config"

# --- Weights & Biases --------------------------------------------------------
export WANDB_DIR="${CACHE_DIR}/wandb"
export WANDB_CACHE_DIR="${CACHE_DIR}/wandb/cache"

# --- Matplotlib --------------------------------------------------------------
export MPLCONFIGDIR="${CACHE_DIR}/matplotlib"

# --- NLTK --------------------------------------------------------------------
export NLTK_DATA="${CACHE_DIR}/nltk"

# --- SpaCy -------------------------------------------------------------------
# SpaCy models download location
# python -m spacy download en_core_web_sm --target ${CACHE_DIR}/spacy

# --- Diffusers (Stable Diffusion) --------------------------------------------
# Uses HF_HOME by default, but you can also set:
export DIFFUSERS_CACHE="${CACHE_DIR}/huggingface/diffusers"

# --- OpenAI API --------------------------------------------------------------
# If using OpenAI API with caching
export OPENAI_CACHE_DIR="${CACHE_DIR}/openai"

# --- Gradio ------------------------------------------------------------------
export GRADIO_TEMP_DIR="${CACHE_DIR}/gradio"

# --- Numba -------------------------------------------------------------------
export NUMBA_CACHE_DIR="${CACHE_DIR}/numba"

# --- TensorBoard -------------------------------------------------------------
export TENSORBOARD_LOGDIR="${PROJECT_DIR}/tensorboard_logs"

# --- MLflow ------------------------------------------------------------------
export MLFLOW_TRACKING_URI="${PROJECT_DIR}/mlruns"

# --- Jupyter -----------------------------------------------------------------
export JUPYTER_DATA_DIR="${CACHE_DIR}/jupyter"
export JUPYTER_RUNTIME_DIR="${CACHE_DIR}/jupyter/runtime"

# --- Temp directory ----------------------------------------------------------
# For very large temporary files
export TMPDIR="${CACHE_DIR}/tmp"
mkdir -p "${TMPDIR}"

# =============================================================================
# Performance tuning (optional)
# =============================================================================

# Limit BLAS threads (useful when using PyTorch DataLoader with num_workers)
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

# CUDA settings
export CUDA_CACHE_PATH="${CACHE_DIR}/cuda"
export CUDA_LAUNCH_BLOCKING=0  # Set to 1 for debugging

# =============================================================================
# Verification commands
# =============================================================================
# Run these to verify cache locations are correct:
#
# Python:
#   python -c "import pip; print(pip.main(['cache', 'dir']))"
#
# PyTorch:
#   python -c "import torch; print(torch.hub.get_dir())"
#
# HuggingFace:
#   python -c "from huggingface_hub import constants; print(constants.HF_HOME)"
#
# Transformers:
#   python -c "from transformers.utils import TRANSFORMERS_CACHE; print(TRANSFORMERS_CACHE)"
#
# Check all environment variables:
#   env | grep -E "CACHE|HOME|DIR" | sort