# p16-CDK6 Computational Interaction Redesign Pipeline

This repository contains an automated screening and structural biology pipeline designed to optimize a p16INK4a-mimetic peptide targeting the oncogenic CDK6 interface. 

As an Embedded Systems student, I engineered this workflow to apply pipeline automation, large-scale screening architectures, and data-driven filtering to structural bioinformatics problems.

---

## 🛠 Repository Architecture

The repository is split into two logical domains:
1. **The Pipeline (`/data` & `/scripts`):** A fully operational, executable environment. Anyone downloading this repository can run the scripts sequentially using the provided input baseline data to reproduce the workflow.
2. **The Showcase (`/results`):** Contains the pre-calculated structural files, sequences, and analytics of my successful "Champion" candidate from the p16-CDK6 optimization run.

<pre><code>├── data/                      # Base input structures for the execution run
│   ├── p16_backbone.pdb       # Mutational template structure
│   ├── cdk6_receptor.pdb      # Target receptor for docking
│   └── fixed_positions.jsonl  # Scripted amino acid locking mapping
├── scripts/                   # Executable automation logic
│   ├── 1_run_proteinmpnn.sh   # High-throughput sequence design (10k generation)
│   ├── 2_run_esmfold.py       # High-throughput batch de-novo folding (200 runs)
│   └── 3_run_lightdock.sh     # Rigid-body interaction simulation (10 parallel runs)
└── results/                   # Verified data from my primary champion candidate
    ├── champion_sequence.fasta# Optimized p16 binding sequence
    ├── p16_CDK6_bestdock.pdb  # De-novo ESMFold structure of the optimized peptide
    ├── final_docked_complex.pdb # Top-scoring LightDock interaction complex (Swarm 54)
    └── interface_render.png   # High-res PyMOL rendering highlighting hot-spots</code></pre>

---

## ⚙️ Installation & Dependencies

The pipeline is optimized for Python 3.8+ running on a Linux native environment or virtual machines (e.g., elementary OS).

# 1. Setup virtual environment
<pre><code>python3 -m venv bio_env
source bio_env/bin/activate</code></pre>

# 2. Install core science stacks & tools
<pre><code>pip install numpy torch biopython requests lightdock
git clone https://github.com/dauparas/ProteinMPNN.git && cd ProteinMPNN && pip install -e . && cd ..
pip install git+https://github.com/facebookresearch/esm.git</code></pre>

---

## 💻 Running the Pipeline (Step-by-Step)

Executing these three files in sequence drives raw inputs from the /data directory through the entire computational screening cascade:

### Step 1: Sequence Optimization (ProteinMPNN)
Generates 10,000 unique sequences based on the geometric framework of the p16 backbone, filters them programmatically by energy stability, and exports the top 200 candidates.

<pre><code>bash ./scripts/1_run_proteinmpnn.sh</code></pre>

*Output: `./data/top_200_redesigned.fasta`*

### Step 2: High-Throughput Folding (ESMFold)
Batch-processes the 200 filtered sequences, running neural network structure prediction to fold them into structural PDB assets.

<pre><code>python ./scripts/2_run_esmfold.py</code></pre>

*Output: `./data/esmfold_structures/` (Contains peptide_1.pdb to peptide_200.pdb)*

### Step 3: Interaction Simulation (LightDock)
Isolates the top 10 structural candidates and docks them via rigid-body simulations against the cdk6_receptor.pdb. It utilizes DFIRE scoring, extracts the top-ranked models out of the primary interaction swarms, and cleans up temporary spaces.

<pre><code>bash ./scripts/3_run_lightdock.sh</code></pre>

*Output: `./data/final_results/` (Contains complex_peptide_1.pdb to complex_peptide_10.pdb)*

---

## 📊 My Champion Results Highlights (`/results`)

The data preserved within the /results folder represents the verified champion candidate from my engineering run:
- **Structure Prediction:** `p16_CDK6_bestdock.pdb` was isolated as the optimal stable structural fold.
- **Interface Complementarity:** Rigid-body docking simulation within the regulatory ankyrin-repeat interface yielded 273 atom-to-atom contacts at a 3.5 Å threshold.
- **Biocompatibility:** Features an upgraded hydrogen-bonding web compared to wild-type p16, indicating strong therapeutic promise.
