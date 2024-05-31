#!/bin/bash

for subj in `seq -w 63 82`;do

echo "sub-0321${subj}  starts"

cd $workdir


in_img=epi_mc
tr=2

echo "spatial smoothing"
fslmaths ${in_img}_atlas_space -s 0.849 ${in_img}_smoothed_atlas_space #FWHM=2mm
echo "temporal filtering"
fslmaths ${in_img}_smoothed_atlas_space -Tmean ${in_img}_smoothed_mean_atlas_space
fslmaths ${in_img}_smoothed_atlas_space -bptf 21.23 2.123 ${in_img}_smoothed_bptf_atlas_space #0.01-0.1 [Hz] -> 100-10 [sec] ->  FWHM:50-5 [vols] -> sigma 21.23-2.123 
fslmaths ${in_img}_smoothed_bptf_atlas_space -add ${in_img}_smoothed_mean_atlas_space ${in_img}_smoothed_bptf_meanback_atlas_space

done
