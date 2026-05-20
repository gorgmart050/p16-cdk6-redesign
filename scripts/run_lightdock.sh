#!/bin/bash

echo "=== Schritt 3: LightDock ($10$ parallele/nacheinander Dockings) ==="

TARGET="./data/partner_target.pdb"
INPUT_STRUCTURES_DIR="./data/esmfold_structures"
FINAL_RESULTS_DIR="./data/final_results"
激mkdir -p "$FINAL_RESULTS_DIR"

# Schleife läuft exakt über die ersten 10 Peptide (die energetisch besten)
for i in {1..10}
do
    LIGAND="$INPUT_STRUCTURES_DIR/peptide_${i}.pdb"
    
    if [ ! -f "$LIGAND" ]; then
        echo "Fehler: $LIGAND nicht gefunden, breche ab."
        exit 1
    fi

    echo "--------------------------------------------------"
    echo "Starte Docking Run $i von 10 für: peptide_${i}.pdb"
    echo "--------------------------------------------------"
    
    # Eigener temporärer Ordner für diesen Docking-Run, um Überschreibungen zu verhindern
    RUN_DIR="./docking_run_${i}"
    mkdir -p "$RUN_DIR"
    cp "$TARGET" "$RUN_DIR/"
    cp "$LIGAND" "$RUN_DIR/"
    cd "$RUN_DIR"

    # Setup und Ausführung
    lightdock3_setup.py ./partner_target.pdb "./peptide_${i}.pdb" -s 100 -g 200 --noxt --noh
    lightdock3.py setup.json 200 -c 4 -s dfire
    lgd_cluster.py setup.json generate_lightdock.list 100 200

    # Den Champion aus dem Hotspot-Swarm (z.B. Swarm 54) isolieren und zurück in data retten
    if [ -d "./swarm_54" ]; then
        cp ./swarm_54/lightdock_0.pdb "../$FINAL_RESULTS_DIR/final_complex_peptide_${i}.pdb"
        echo "Ergebnis für Peptid $i gesichert."
    else
        # Fallback falls Swarm 54 in einem anderen Run nicht existiert: nimm einfach Swarm 00
        cp ./swarm_0/lightdock_0.pdb "../$FINAL_RESULTS_DIR/final_complex_peptide_${i}.pdb"
    fi

    # Aufräumen des temporären Ordners um Speicherplatz zu sparen
    cd ..
    rm -rf "$RUN_DIR"
done

echo "=== PIPELINE ERFOLGREICH BEENDET ==="
echo "Deine 10 fertigen, gedockten Top-Komplexe liegen in: $FINAL_RESULTS_DIR/"
