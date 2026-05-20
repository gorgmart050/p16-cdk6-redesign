# p16-CDK6 Interaction Redesign Pipeline

This repository contains the computational pipeline and structural data for the redesign and optimization of a p16INK4a-mimetic peptide targeting CDK6. 

As an Embedded Systems student, I developed this workflow to apply technical system optimization and pipeline automation principles to structural biology, utilizing AI-assisted deep learning tools.

## 🛠 The Pipeline Workflow

The project avoids simple fragment matching by executing a rigorous three-step computational pipeline to alter and optimize the interface sequence:

1. **Sequence Redesign (ProteinMPNN):** The native p16INK4a backbone was used as a template. ProteinMPNN was deployed to perform target-focused sequence redesign at the interaction interface, optimizing for higher energetic stability and binding affinity.
2. **Structure Validation (ESMFold):** The newly generated sequences were folded de-novo using ESMFold to verify that the mutated peptides successfully adopt the required secondary structure without losing integrity.
3. **Rigid-Body Docking (LightDock):** The folded champion candidate was docked against the regulatory ankyrin-repeat interface of CDK6 to simulate the binding pose and evaluate surface complementarity.

## 📊 Key Results

- **Interface Complementarity:** The final "champion" candidate isolated via PyMOL shows an exceptional fit into the CDK6 catalytic loop.
- **Atomic Contacts:** **273 atom-to-atom contacts** identified within a 3.5 Å threshold.
- **Interaction Network:** Enhanced hydrogen-bonding networks compared to the native wild-type p16 sequence.

## 📁 Repository Structure

```text
├── data/
│   ├── native_p16.fasta          # Original wild-type sequence
│   ├── redesigned_p16.fasta      # Optimized ProteinMPNN sequence
│   ├── esmfold_prediction.pdb    # Folded structure of the redesigned peptide
│   └── final_complex_docked.pdb  # Top-scoring LightDock cluster complex
├── scripts/
│   ├── run_proteinmpnn.sh        # Bash wrapper/parameters for sequence generation
│   ├── run_lightdock.sh          # LightDock simulation setup and execution
│   └── interface_analysis.pml    # PyMOL script used for contact calculation
└── visuals/
    └── cdk6_interface_render.png # High-resolution PyMOL interface rendering
