# Setting up the rigid-body docking simulation with 100 swarms and 200 glows
lightdock3_setup.py ./data/cdk6_target.pdb ./data/esmfold_prediction.pdb \
    -s 100 \
    -g 200 \
    --noxt \
    --noh

# Executing the simulation (using scoring functions optimized for protein complexes)
lightdock3.py setup.json 100 -c 4 -s dfire

# Clustering the top results to isolate the "Champion" pose
lgd_cluster.py setup.json generate_lightdock.list 100 200
