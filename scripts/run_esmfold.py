import torch
import esm
import os
import sys

def predict_structure(fasta_path, output_pdb_path):
    print(f"Lese Sequenz aus: {fasta_path}")
    model = esm.pretrained.esmfold_v1().eval().cuda()

    with open(fasta_path, 'r') as f:
        lines = f.readlines()
        sequence = "".join([line.strip() for line in lines if not line.startswith(">")])

    print("Berechne Faltung via ESMFold...")
    with torch.no_grad():
        output = model.infer_pdb(sequence)

    with open(output_pdb_path, "w") as f:
        f.write(output)
    print(f"Struktur erfolgreich gespeichert unter: {output_pdb_path}")

if __name__ == "__main__":
    # Standardpfade für den Nutzer der Anleitung
    FASTA_INPUT = "./data/redesigned_peptide.fasta"
    PDB_OUTPUT = "./data/esmfold_prediction.pdb"
    
    if os.path.exists(FASTA_INPUT):
        predict_structure(FASTA_INPUT, PDB_OUTPUT)
    else:
        print(f"Fehler: {FASTA_INPUT} nicht gefunden.")
