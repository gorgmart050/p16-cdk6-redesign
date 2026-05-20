#!/bin/bash
# Input: ./data/p16_backbone.pdb + ./data/fixed_positions.jsonl
# Output: Erstellt 10.000 Sequenzen und filtert die Top 200 nach /data

INPUT_PDB="./data/p16_backbone.pdb"
FIXED_JSON="./data/fixed_positions.jsonl"
OUTPUT_DIR="./data/mpnn_outputs"
TOP_200_FASTA="./data/top_200_redesigned.fasta"

echo "=== Schritt 1: ProteinMPNN (10.000 Sequenzen) ==="

python protein_mpnn_run.py \
    --pdb_path "$INPUT_PDB" \
    --pdb_path_chains "B" \
    --fixed_positions_jsonl "$FIXED_JSON" \
    --out_folder "$OUTPUT_DIR" \
    --num_seq_per_target 10000 \
    --sampling_temp "0.1" \
    --seed 37

echo "Filtere die Top 200 stabilsten Sequenzen..."

python3 -c "
with open('$OUTPUT_DIR/seqs/p16_backbone.fa', 'r') as f:
    content = f.read().split('>')
parsed = []
for entry in content[1:]:
    lines = entry.strip().split('\n')
    if not lines: continue
    header = lines[0]
    seq = ''.join(lines[1:])
    score = float(header.split('score=')[1].split(',')[0])
    parsed.append((score, header, seq))
parsed.sort(key=lambda x: x[0])
with open('$TOP_200_FASTA', 'w') as out:
    for i in range(min(200, len(parsed))):
        out.write(f'>{parsed[i][1]}\n{parsed[i][2]}\n')
"
echo "Top 200 Sequenzen gespeichert unter: $TOP_200_FASTA"
