#!/bin/bash
# =============================================================================
# Miniconda Installation Script for SLURM Cluster
# Installs conda and configures all cache directories in project folder
# =============================================================================

# --- Configuration -----------------------------------------------------------
# Set your project directory path here
# PROJECT_DIR="${PROJECT_DIR:-/path/to/your/project}"  # CHANGE THIS
PROJECT_DIR=$1  # Default to script directory if not set

# Derived paths
CONDA_DIR="${PROJECT_DIR}/miniconda3"
CACHE_DIR="${PROJECT_DIR}/.cache"
CONDA_PKGS_DIR="${CACHE_DIR}/conda/pkgs"
CONDA_ENVS_DIR="${PROJECT_DIR}/conda_envs"
PIP_CACHE_DIR="${CACHE_DIR}/pip"
HF_CACHE_DIR="${CACHE_DIR}/huggingface"
TORCH_CACHE_DIR="${CACHE_DIR}/torch"
XDG_CACHE_DIR="${CACHE_DIR}/xdg"

# Miniconda installer URL (Linux x86_64)
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALLER_PATH="${PROJECT_DIR}/miniconda_installer.sh"

# --- Pre-flight checks -------------------------------------------------------
echo "=============================================="
echo "Miniconda Installation for SLURM Cluster"
echo "=============================================="
echo ""
echo "Project directory: ${PROJECT_DIR}"
echo "Conda will be installed to: ${CONDA_DIR}"
echo "Cache directories will be in: ${CACHE_DIR}"
echo ""

# Check if project directory exists
if [[ ! -d "${PROJECT_DIR}" ]]; then
    echo "ERROR: Project directory does not exist: ${PROJECT_DIR}"
    echo "Please set PROJECT_DIR to your actual project folder path."
    exit 1
fi

# Check if conda is already installed
if [[ -d "${CONDA_DIR}" ]]; then
    echo "WARNING: Conda directory already exists at ${CONDA_DIR}"
    read -p "Do you want to remove it and reinstall? (y/N): " confirm
    if [[ "${confirm}" =~ ^[Yy]$ ]]; then
        rm -rf "${CONDA_DIR}"
    else
        echo "Aborting installation."
        exit 0
    fi
fi

# --- Create directory structure ----------------------------------------------
echo ""
echo "[1/5] Creating directory structure..."

mkdir -p "${CACHE_DIR}"
mkdir -p "${CONDA_PKGS_DIR}"
mkdir -p "${CONDA_ENVS_DIR}"
mkdir -p "${PIP_CACHE_DIR}"
mkdir -p "${HF_CACHE_DIR}"
mkdir -p "${TORCH_CACHE_DIR}"
mkdir -p "${XDG_CACHE_DIR}"

echo "  Created: ${CACHE_DIR}"
echo "  Created: ${CONDA_PKGS_DIR}"
echo "  Created: ${CONDA_ENVS_DIR}"
echo "  Created: ${PIP_CACHE_DIR}"
echo "  Created: ${HF_CACHE_DIR}"
echo "  Created: ${TORCH_CACHE_DIR}"
echo "  Created: ${XDG_CACHE_DIR}"

# --- Download Miniconda ------------------------------------------------------
echo ""
echo "[2/5] Downloading Miniconda installer..."

if [[ -f "${INSTALLER_PATH}" ]]; then
    echo "  Installer already exists, skipping download."
else
    wget -q --show-progress -O "${INSTALLER_PATH}" "${MINICONDA_URL}"
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to download Miniconda installer."
        exit 1
    fi
fi

# --- Install Miniconda -------------------------------------------------------
echo ""
echo "[3/5] Installing Miniconda..."

bash "${INSTALLER_PATH}" -b -p "${CONDA_DIR}"
if [[ $? -ne 0 ]]; then
    echo "ERROR: Miniconda installation failed."
    exit 1
fi

# Clean up installer
rm -f "${INSTALLER_PATH}"

# --- Configure Conda ---------------------------------------------------------
echo ""
echo "[4/5] Configuring conda..."

# Initialize conda for bash
source "${CONDA_DIR}/etc/profile.d/conda.sh"

# Configure conda to use project directories for packages and envs
conda config --system --add pkgs_dirs "${CONDA_PKGS_DIR}"
conda config --system --add envs_dirs "${CONDA_ENVS_DIR}"

# Set other useful defaults
conda config --system --set auto_activate_base false
conda config --system --set channel_priority flexible

echo "  Configured package cache: ${CONDA_PKGS_DIR}"
echo "  Configured environments: ${CONDA_ENVS_DIR}"

# --- Create environment setup script -----------------------------------------
echo ""
echo "[5/5] Creating environment setup script..."

SETUP_SCRIPT="${PROJECT_DIR}/setup_env.sh"

cat > "${SETUP_SCRIPT}" << 'SETUP_EOF'
#!/bin/bash
# =============================================================================
# Environment Setup Script
# Source this script to configure conda and all cache directories
# Usage: source /path/to/project/setup_env.sh
# =============================================================================

# --- Get the directory where this script is located --------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR}"

# --- Conda paths -------------------------------------------------------------
export CONDA_DIR="${PROJECT_DIR}/miniconda3"
export CONDA_PKGS_DIRS="${PROJECT_DIR}/.cache/conda/pkgs"
export CONDA_ENVS_PATH="${PROJECT_DIR}/conda_envs"

# --- Cache directories -------------------------------------------------------
export CACHE_DIR="${PROJECT_DIR}/.cache"

# Python/Pip
export PIP_CACHE_DIR="${CACHE_DIR}/pip"
export PYTHONPYCACHEPREFIX="${CACHE_DIR}/pycache"

# HuggingFace
export HF_HOME="${CACHE_DIR}/huggingface"
export HF_DATASETS_CACHE="${CACHE_DIR}/huggingface/datasets"
export TRANSFORMERS_CACHE="${CACHE_DIR}/huggingface/transformers"

# PyTorch
export TORCH_HOME="${CACHE_DIR}/torch"
export TORCH_EXTENSIONS_DIR="${CACHE_DIR}/torch/extensions"

# General XDG cache (used by many tools)
export XDG_CACHE_HOME="${CACHE_DIR}/xdg"

# Triton (for torch.compile)
export TRITON_CACHE_DIR="${CACHE_DIR}/triton"

# Matplotlib
export MPLCONFIGDIR="${CACHE_DIR}/matplotlib"

# NumPy/SciPy BLAS config
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1

# --- Temp directory (optional, for large temp files) -------------------------
# Uncomment if you want temp files in project dir instead of /tmp
# export TMPDIR="${PROJECT_DIR}/.tmp"
# mkdir -p "${TMPDIR}"

# --- Initialize conda --------------------------------------------------------
if [[ -f "${CONDA_DIR}/etc/profile.d/conda.sh" ]]; then
    source "${CONDA_DIR}/etc/profile.d/conda.sh"
else
    echo "WARNING: Conda not found at ${CONDA_DIR}"
    echo "Please run the install script first."
fi

# --- Create cache directories if they don't exist ----------------------------
mkdir -p "${PIP_CACHE_DIR}" 2>/dev/null
mkdir -p "${PYTHONPYCACHEPREFIX}" 2>/dev/null
mkdir -p "${HF_HOME}" 2>/dev/null
mkdir -p "${TORCH_HOME}" 2>/dev/null
mkdir -p "${TORCH_EXTENSIONS_DIR}" 2>/dev/null
mkdir -p "${XDG_CACHE_HOME}" 2>/dev/null
mkdir -p "${TRITON_CACHE_DIR}" 2>/dev/null
mkdir -p "${MPLCONFIGDIR}" 2>/dev/null

# --- Print status ------------------------------------------------------------
echo "Environment configured:"
echo "  CONDA_DIR:    ${CONDA_DIR}"
echo "  CACHE_DIR:    ${CACHE_DIR}"
echo "  HF_HOME:      ${HF_HOME}"
echo "  TORCH_HOME:   ${TORCH_HOME}"
echo ""
echo "Use 'conda activate <env_name>' to activate an environment."
SETUP_EOF

chmod +x "${SETUP_SCRIPT}"

# --- Final message -----------------------------------------------------------
echo ""
echo "=============================================="
echo "Installation Complete!"
echo "=============================================="
echo ""
echo "To use conda, add this to your job scripts or run interactively:"
echo ""
echo "    source ${SETUP_SCRIPT}"
echo ""
echo "Then activate your environment:"
echo ""
echo "    conda activate base"
echo "    # or create a new environment:"
echo "    conda create -n myenv python=3.10"
echo "    conda activate myenv"
echo ""
echo "All caches will be stored in: ${CACHE_DIR}"
echo "All conda environments in: ${CONDA_ENVS_DIR}"
echo ""