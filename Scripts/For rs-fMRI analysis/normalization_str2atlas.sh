#!/bin/bash

#for subj in `seq -w 78 82`;do
for subj in 81;do


echo "sub-0321${subj}  starts"

cd $workdir

in_img=t1
out_img=t1_atlas_space
in_brain_img=t1_brain
out_brain_img=t1_brain_atlas_space
templateDir=/Applications/NHPPipelines-master/global/templates/
template=MacaqueYerkes19_T1w_0.5mm_brain

echo "1/2"
echo "inv warp"
echo ""
mkdir -p ./mat

invwarp -w ./mat/atlas2str_flirtfnirt.nii.gz -o ./mat/str2atlas_flirtfnirt.nii.gz -r ${templateDir}/${template}

echo "2/2"
echo "applywarp"
echo ""

#applywarp --in=${in_brain_img} --ref=${templateDir}/${template} --out=${out_brain_img} --warp=./mat/str2atlas_flirtfnirt
#applywarp --in=${in_img} --ref=${templateDir}/${template} --out=${out_img} --warp=./mat/str2atlas_flirtfnirt
applywarp --in=${in_brain_img} --ref=${templateDir}/${template} --out=${out_brain_img} --premat=./mat/str2atlas_flirt.mat
applywarp --in=${in_img} --ref=${templateDir}/${template} --out=${out_img} --premat=./mat/str2atlas_flirt.mat

echo "Completed"

done
