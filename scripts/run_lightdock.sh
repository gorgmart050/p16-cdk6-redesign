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
    mkdir -p "$RUN_DIR"
    cp "$RECEPTOR" "$RUN_DIR/"
    cp "$LIGAND" "$RUN_DIR/"

    pushd "$RUN_DIR" > /dev/null

    lightdock3_setup.py cdk6_receptor.pdb "peptide_${i}.pdb" -s 25 -g 200 --noxt --noh
    lightdock3.py setup.json 200 -c 4 -s dfire

    # Konformationen für alle Swarms generieren
    for swarm_dir in swarm_*/; do
        lgd_generate_conformations.py setup.json "$swarm_dir" 200
    done

    # Bestes Modell anhand DFIRE-Score auswählen
    lgd_cluster_binder.py setup.json

    BEST=$(ls swarm_*/lightdock_*.pdb 2>/dev/null | head -1)
    if [ -n "$BEST" ]; then
        cp "$BEST" "../$FINAL_DIR/complex_peptide_${i}.pdb"
    else
        echo "Warnung: Kein Docking-Ergebnis für peptide_${i}.pdb"
    fi

    popd > /dev/null
    rm -rf "$RUN_DIR"
done

echo "Pipeline beendet. Die fertigen Komplexe liegen in: $FINAL_DIR/"
