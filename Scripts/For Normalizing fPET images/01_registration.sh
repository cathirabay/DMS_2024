#!/bin/bash


echo "mri=${mri}"
echo "template=${template}"
echo "spm=${spm}"


bet ${mri} mri_bet

echo "1"
flirt -interp spline -dof 12 -ref ${template} -in mri_bet -omat flirt.mat -out mri_templatespace_flirt.nii.gz # -searchrx -40 100 -searchry 150 210 -searchrz -30 30
echo "2"
fnirt --ref=${template} --in=mri_bet --aff=flirt.mat --fout=mri2template --iout=mri_templatespace --config="$FNIRTConfig"
echo "3"
applywarp --rel --interp=spline --ref=${template} --in=${spm} -w mri2template.nii.gz -o spmT_templatespace.nii.gz
echo "4"


