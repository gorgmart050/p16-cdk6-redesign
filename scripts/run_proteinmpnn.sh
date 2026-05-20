# Running the ProteinMPNN model on the p16 backbone targeting specific interface residues
python protein_mpnn_run.py \
    --pdb_path ./data/p16_target.pdb \
    --pdb_path_chains "B" \
    --fixed_positions_jsonl ./data/fixed_positions.jsonl \
    --out_folder ./data/mpnn_outputs \
    --num_seq_per_target 100 \
    --sampling_temp "0.1" \
    --seed 37
