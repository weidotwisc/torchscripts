#!/bin/bash
# Usage: run.sh lua_scripts_dir data_dir cache_dir nGPU
cmd_log=`echo $0 $@`
echo "cmd log is ${cmd_log}"

# step 1 test if there are the right number of arguments 
if [[ "$#" -ne 5 ]]; then
    echo "Usage: $0 lua_scripts_dir data_dir cache_dir nGPU netType(alexnet | overfeat | alexnetowtbn | vgg | googlenet)" >&2
    exit 1
fi 
lua_scripts_dir=$1
data_dir=$2
cache_dir=$3
nGPU=$4
bs=128
nEpochs=55
netType=$5

jobid=${netType}_bs${bs}_nEpochs${nEpochs}_nGPU${nGPU}
timestamp=`date +"%Y-%m-%d-%T"`
mkdir -p ${jobid}
pushd ${jobid}
mkdir -p ${timestamp}
pushd ${timestamp}
# (th main.lua -data /nfs_weiz/mfeng/imagenet/ -cache /nfs_weiz/imgnet_cache -nGPU 4 -nDonkeys 12 -nEpochs 55 -batchSize 128 -epochSize 10000 -netType alexnetowtbn >  4L.stdout) &> 4L.stderr

rm -fr log.std*
ln -s ${lua_scripts_dir}/*.lua ./
ln -s ${lua_scripts_dir}/models ./

cmdline="(th main.lua -data ${data_dir} -cache ${cache_dir} -nGPU ${nGPU} -nDonkeys 12 -nEpochs ${nEpochs} -batchSize ${bs} -epochSize 10000 -netType ${netType} >  log.stdout) &> log.stderr"

echo $cmd_log >> ./cmdlog

rm -fr ./run.sh
echo $cmdline >> ./run.sh
chmod +x ./run.sh
popd
popd


# plain run
