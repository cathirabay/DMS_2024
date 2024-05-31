#!/bin/bash


for hemi in L R;do
wb_command -volume-to-surface-mapping ./spmT_templatespace.nii.gz $surfacedir/MacaqueYerkes19_v1.2.$hemi.midthickness.32k_fs_LR.surf.gii ./spmT_templatespace.$hemi.func.gii -ribbon-constrained $surfacedir/MacaqueYerkes19_v1.2.$hemi.white.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.$hemi.pial.32k_fs_LR.surf.gii
done

echo "OTHER" > VolumeLabel.txt
echo "1 255 255 255 255" >> VolumeLabel.txt

fslmaths ${subcortidal_mask} -bin ./mask.nii.gz

wb_command -volume-label-import ./mask.nii.gz VolumeLabel.txt ./mask.nii.gz

wb_command -cifti-create-dense-scalar spmT_templatespace.dscalar.nii -volume ./spmT_templatespace.nii.gz ./mask.nii.gz -left-metric ./spmT_templatespace.L.func.gii -right-metric ./spmT_templatespace.R.func.gii 

rm ./pet_templatespace.L.func.gii ./pet_templatespace.R.func.gii 

wb_view $surfacedir/MacaqueYerkes19_v1.2.L.midthickness.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.R.midthickness.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.L.inflated.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.R.inflated.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.L.very_inflated.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.R.very_inflated.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.L.flat.32k_fs_LR.surf.gii $surfacedir/MacaqueYerkes19_v1.2.R.flat.32k_fs_LR.surf.gii spmT_templatespace.dscalar.nii ./mri_templatespace.nii.gz ~/MacaqueYerkes19_v1.2_Vj_976nz/parcellations/Yerkes19_Parcellations_v2.32k_fs_LR.dlabel.nii


