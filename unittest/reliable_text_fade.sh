#!/bin/bash -x
#
# Tests reliable_text fading channel performance, using a simulated channel

results=$(mktemp -d)
mode=$1
snr=$2
min_text_packets=$3
clip=$4
build_folder=$5
fading_dir=${build_folder}/../unittest
rx=$build_folder/freedv_rx
tx=$build_folder/freedv_tx

if [ $clip -eq 1 ]; then 
    clip_args="--txbpf 1 --clip 1"
else
    clip_args=
fi

$tx $mode ../raw/ve9qrp.raw - --reliabletext AB1CDEF $clip_args | $build_folder/cohpsk_ch - - $snr --mpp --Fs 8000 -f -5 --fading_dir $fading_dir > $results/reliable_fade.raw 
$rx $mode $results/reliable_fade.raw /dev/null --txtrx $results/reliable_fade.txt --reliabletext
if [ `cat $results/reliable_fade.txt | wc -l` -ge $min_text_packets ]; then
    exit 0
else
    exit -1
fi
