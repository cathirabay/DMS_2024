#!/bin/bash


for subj in `seq -w 78 82`;do

echo "sub-0321${subj}  starts"

cd $workdir

in_img=../func/sub-0321${subj}_ses-001_task-resting_run-1_bold
out_ref_img=epi_ref
out_img=epi_mc


echo ${i}
echo "Extract first image of the rsfmri (reference)"
echo ""

fslroi ${in_img} ${out_ref_img} 0 1

echo "mcflirt_acc processing"
echo ""

mcflirt_acc.sh ${in_img} ${out_img} ${out_ref_img}
fslmaths ${out_img} -Tmean ${out_img}_mean
echo "mcflirt_acc comleted"

done
