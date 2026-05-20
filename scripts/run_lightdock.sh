#!/bin/bash
# Input: ./data/cdk6_receptor.pdb + die ersten 10 Strukturen aus ./data/esmfold_structures/
# Output: Erzeugt 10 Docking-Läufe und speichert die finalen Komplexe in ./data/final_results/

RECEPTOR="./data/cdk6_receptor.pdb"
STRUCTURES_DIR="./data/esmfold_structures"
FINAL_DIR="./data/final_results"
mkdir -p "$FINAL_DIR"

echo "=== Schritt 3: LightDock (10 Top-Kandidaten docken) ==="

for i in {1..10}
do
    LIGAND="$STRUCTURES_DIR/peptide_${i}.pdb"
    if [ ! -f "$LIGAND" ]; then echo "Fehler: $LIGAND fehlt."; exit 1; fi

    echo "Docking Run $i/10 für peptide_${i}.pdb..."
    RUN_DIR="./docking_run_${i}"
    mkdir -p "$RUN_DIR" && cp "$RECEPTOR" "$RUN_DIR/" && cp "$LIGAND" "$RUN_DIR/" && cd "$RUN_DIR"

    lightdock3_setup.py ./cdk6_receptor.pdb "./peptide_${i}.pdb" -s 100 -g 200 --noxt --noh
    lightdock3.py setup.json 200 -c 4 -s dfire
    lgd_cluster.py setup.json generate_lightdock.list 100 200

    # Retten des "Champions" aus dem biologischen Hotspot (Swarm 54) nach /data/final_results
    if [ -d "./swarm_54" ]; then
        cp ./swarm_54/lightdock_0.pdb "../$FINAL_DIR/complex_peptide_${i}.pdb"
    else
        cp ./swarm_0/lightdock_0.pdb "../$FINAL_DIR/complex_peptide_${i}.pdb"
    fi
    cd .. && rm -rf "$RUN_DIR"
done
echo "Pipeline beendet. Die 10 fertigen Komplexe liegen in: $FINAL_DIR/"
