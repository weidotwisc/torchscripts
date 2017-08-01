#!/bin/bash
# Usage: run.sh lua_scripts_dir data_dir depth nGPU
cmd_log=`echo $0 $@`
echo "cmd log is ${cmd_log}"

# step 1 test if there are the right number of arguments 
if [[ "$#" -ne 5 ]]; then
    echo "Usage: $0 lua_scripts_dir data_dir depth nGPU bs" >&2
    exit 1
fi 
lua_scripts_dir=$1
data_dir=$2
depth=$3
nGPU=$4
bs=$5
nEpochs=90
netType=resnet${depth}

jobid=${netType}_bs${bs}_nEpochs${nEpochs}_nGPU${nGPU}
timestamp=`date +"%Y-%m-%d-%T"`
mkdir -p ${jobid}
pushd ${jobid}
mkdir -p ${timestamp}
pushd ${timestamp}
# th main.lua -depth 101 -nGPU 4 -nThreads 12 -batchSize 256 -shareGradInput true -data /mnt/glusterfs/GVolDist1/DEEPLEARN/torch_imagenet1K
rm -fr log.std*
ln -s ${lua_scripts_dir}/*.lua ./
ln -s ${lua_scripts_dir}/models ./
ln -s ${lua_scripts_dir}/datasets ./
ln -s ${lua_scripts_dir}/pretrained ./


cmdline="(th main.lua -depth ${depth} -nGPU ${nGPU} -nThreads 12 -batchSize ${bs} -shareGradInput true -data ${data_dir} > log.stdout) &> log.stderr"

echo $cmd_log >> ./cmdlog

rm -fr ./run.sh
echo $cmdline >> ./run.sh
chmod +x ./run.sh
popd
popd


# plain run
