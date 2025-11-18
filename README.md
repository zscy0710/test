# Hierarchical Feature Selection (HFS)

This repository contains MATLAB implementations of a hierarchical feature selection method that seeks to **maximize inter-class independence** while **minimizing intra-class redundancy**. The approach leverages both the class hierarchy and correlations among features to choose discriminative, non-redundant subsets across related tasks.

Key ideas:
- Structural relation regularization enforces independence between unrelated classes using the hierarchy encoded in a parent vector.
- Feature relation regularization penalizes redundant features within each class while keeping the solution sparse.
- The two regularizers are unified in `HFS_psrlianheDAG.m` to balance structural guidance and feature sparsity.

## Files of interest
- `HFS_psrlianheDAG.m` — Core optimization routine for hierarchical feature selection.
- `SubDAGRelationMatrix_Fs.m` and helpers in `patch/` — Utilities for working with tree/DAG structures and computing structural weights.
- `demo_hfs_synthetic.m` — End-to-end example that constructs a toy hierarchy, runs HFS, and prints the selected features per node.

## Running the synthetic demo
1. Launch MATLAB and make sure the repository root is on the MATLAB path. The demo adds the `patch/` folder automatically for helper functions.
2. Execute the demo:
   ```matlab
   demo_hfs_synthetic
   ```
3. The script will generate synthetic data for two leaf nodes under a common root and report the top features chosen for each leaf. Set `flag = 1` inside the script if you want to visualize the objective value over iterations.

## References
The implementation follows the hierarchical feature selection strategy described in the accompanying project notes: leveraging both structural and feature relations to deliver efficient, effective feature subsets as the number of classes and dimensions grows.
