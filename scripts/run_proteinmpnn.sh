#!/bin/bash

INPUT_PDB="./data/input_backbone.pdb"
FIXED_JSON="./data/fixed_positions.jsonl"
OUTPUT_DIR="./data/mpnn_outputs"
TOP_200_FASTA="./data/top_200_redesigned.fasta"

echo "=== Schritt 1: ProteinMPNN ($10.000$ Sequenzen) ==="

# Generiert exakt 10.000 Sequenzen
python protein_mpnn_run.py \
    --pdb_path "$INPUT_PDB" \
    --pdb_path_chains "B" \
    --fixed_positions_jsonl "$FIXED_JSON" \
    --out_folder "$OUTPUT_DIR" \
    --num_seq_per_target 10000 \
    --sampling_temp "0.1" \
    --seed 37

echo "Filtere die Top 200 stabilsten Sequenzen heraus..."

# Ein Python-Einzeiler, der die FASTA nach dem ProteinMPNN-Score sortiert und die besten 200 extrahiert
python3 -c "
import sys
with open('$OUTPUT_DIR/seqs/input_backbone.fa', 'r') as f:
    content = f.read().split('>')
header_seq = content[0] # Wildtyp
parsed = []
for entry in content[1:]:
    lines = entry.strip().split('\n')
    if not lines: continue
    header = lines[0]
    seq = ''.join(lines[1:])
    # Score extrahieren (score=X.XXXX)
    score = float(header.split('score=')[1].split(',')[0])
    parsed.append((score, header, seq))
# Sortieren nach bestem Score (niedrigster Wert = stabilste Energie)
parsed.sort(key=lambda x: x[0])
with open('$TOP_200_FASTA', 'w') as out:
    for i in range(min(200, len(parsed))):
        out.write(f'>{parsed[i][1]}\n{parsed[i][2]}\n')
"

echo "Die 200 besten Sequenzen wurden in $TOP_200_FASTA gespeichert."
