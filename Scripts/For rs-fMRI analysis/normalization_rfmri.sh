#!/bin/bash


#for subj in `seq -w 78 82`;do
for subj in 81;do


echo "sub-0321${subj}  starts"

cd $workdir

in_img=epi_mc_mean
out_img=epi_mc_mean_atlas_space
in_img2=epi_mc
out_img2=epi_mc_atlas_space
str_img=t1_brain
str_img_atlas_space=t1_brain_atlas_space
templateDir=/Applications/NHPPipelines-master/global/templates/
template=MacaqueYerkes19_T1w_0.5mm_brain


echo "1/2"
echo "regstration to structure image"
echo ""
cp ${templateDir}/${template}.nii.gz ./

#bet epi_mc_mean.nii.gz  epi_mc_mean_brain.nii.gz -r 25
#bet epi_mc_mean.nii.gz  epi_mc_mean_brain.nii.gz -r 30 # for sub-032164
#bet epi_mc_mean.nii.gz  epi_mc_mean_brain.nii.gz -r 30 # for sub-032165


flirt -in ${in_img}_brain -ref ${str_img}_tmp -out ${in_img}_str_space -dof 6 -omat ./mat/rfmri2str_flirt.mat
convert_xfm -omat ./mat/rfmri2atlas_flirt.mat -concat ./mat/str2atlas_flirt.mat ./mat/rfmri2str_flirt.mat
convert_xfm -omat ./mat/atlas2rfmri_flirt.mat -inverse ./mat/rfmri2atlas_flirt.mat
flirt -in ${templateDir}/${template}.nii.gz -ref ${in_img} -out ${template}_rfmri_space.nii.gz -applyxfm -init ./mat/atlas2rfmri_flirt.mat
fslmaths ${template}_rfmri_space.nii.gz -bin ${template}_mask_rfmri_space.nii.gz

echo "2/2"
echo "normalization to atlas space"
echo ""
flirt -in ${templateDir}/${template}.nii.gz -ref ${templateDir}/${template}.nii.gz -out ${template}_2mmiso.nii.gz -applyisoxfm 2.0
#applywarp --in=${in_img} --ref=${template}_2mmiso.nii.gz --out=${out_img} --premat=./mat/rfmri2str_flirt.mat --warp=./mat/str2atlas_flirtfnirt
#applywarp --in=${in_img2} --ref=${template}_2mmiso.nii.gz --out=${out_img2} --premat=./mat/rfmri2str_flirt.mat --warp=./mat/str2atlas_flirtfnirt
applywarp --in=${in_img} --ref=${template}_2mmiso.nii.gz --out=${out_img} --premat=./mat/rfmri2atlas_flirt.mat
applywarp --in=${in_img2} --ref=${template}_2mmiso.nii.gz --out=${out_img2} --premat=./mat/rfmri2atlas_flirt.mat

echo "Completed"

done

