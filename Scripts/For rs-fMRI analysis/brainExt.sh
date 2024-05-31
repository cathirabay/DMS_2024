#!/bin/bash


for subj in 69;do

echo "sub-0321${subj}  starts"

workdir=/Users/yukihori/Desktop/horiDir/qst/misc/Oxford_Macaque_MRIdata/oxford/site-oxford/sub-0321${subj}/ses-001/

cd $workdir/anat/

tmp=sub-0321${subj}_ses-001_run-1_T1w.nii.gz
num=1
for i in 2 3 4 5 6;do

 if [ -e sub-0321${subj}_ses-001_run-${i}_T1w.nii.gz ]; then
    tmp=`echo "$tmp -add sub-0321${subj}_ses-001_run-${i}_T1w.nii.gz"` 
    num=$((num+1))
 fi
done
echo $num
echo $tmp

fslmaths $tmp -div ${num} sub-0321${subj}_ses-001_mean_T1w.nii.gz


cd $workdir/
mkdir -p analysis
cd analysis/
fslreorient2std ../anat/sub-0321${subj}_ses-001_mean_T1w.nii.gz ./t1.nii.gz

in_img=t1
out_img=t1_brain
radius=43
templateDir=/Applications/NHPPipelines-master/global/templates/
template=MacaqueYerkes19_T1w_0.5mm_brain
FNIRTConfig="/Applications/NHPPipelines-master/global/config/T1_2_MNI_NHP.cnf"

echo "1/4"
echo "BET processing"
echo ""

bet ${in_img} ${out_img}_bet -m -f 0.5 -r ${radius}



echo "2/4"
echo "FLIRT processing"
echo ""
mkdir -p ./mat

flirt -in ${templateDir}/${template} -ref ${out_img}_bet -out ${template}_flirt_str_space -dof 12 -omat ./mat/atlas2str_flirt.mat -searchrx -30 30 -searchry -30 30 -searchrz -30 30 

#flirt -in ${templateDir}/${template} -ref ${out_img}_bet -out ${template}_flirt_str_space -dof 12 -omat ./mat/atlas2str_flirt.mat

convert_xfm -omat ./mat/str2atlas_flirt.mat -inverse ./mat/atlas2str_flirt.mat 

fslmaths ${template}_flirt_str_space -bin ${out_img}_mask_tmp
fslmaths ${out_img}_mask_tmp -mul ${in_img} ${out_img}_tmp



echo "3/4"
echo "FNIRT processing"
echo ""

#fnirt --in=${templateDir}/${template} --ref=${in_img} --iout=${template}_flirtfnirt_str_space --aff=./mat/atlas2str_flirt.mat --fout=./mat/atlas2str_flirtfnirt --config="$FNIRTConfig"

fnirt --in=${templateDir}/${template} --ref=${out_img}_tmp --iout=${template}_flirtfnirt_str_space --aff=./mat/atlas2str_flirt.mat --fout=./mat/atlas2str_flirtfnirt --config="$FNIRTConfig"

echo "4/4"
echo "Making brain mask"
echo ""

fslmaths ${template}_flirtfnirt_str_space -bin ${out_img}_mask

fslmaths ${out_img}_mask -mul ${in_img} ${out_img}

echo "sub-0321${subj}  Completed"


done


