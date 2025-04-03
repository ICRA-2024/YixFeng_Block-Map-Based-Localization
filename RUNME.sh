#!/usr/bin/env bash

if ! curl -V &>/dev/null; then
  echo "Prerequisite error: curl not found"
  exit 1
fi

if ! docker -v &>/dev/null; then
  echo "Prerequisite error: Docker not found"
  exit 1
fi

if ! nvidia-container-toolkit --version &>/dev/null; then
  echo "Prerequisite error: NVIDIA container toolkit not found"
  exit 1
fi

if ! docker compose version &>/dev/null; then
  echo "Prerequisite error: Docker compose plugin not found"
  exit 1
fi

FILEID=1Z2K56jTkMOouZhM4c9JhPvqyDxGFiXSY
FILENAME1=BMs_for_test.zip
FILENAME2=M2DGR_BMs.zip
FILENAME3=NCLT_BMs.zip
DATAFOLDER=dataset
FOLDERNAME=BMs_for_test

if ! test -d $DATAFOLDER/$FOLDERNAME; then
  mkdir -p $DATAFOLDER/$FOLDERNAME
  curl "https://drive.usercontent.google.com/download?id={$FILEID}&confirm" -o $DATAFOLDER/$FOLDERNAME/$FILENAME1
  cd $DATAFOLDER/$FOLDERNAME && unzip $FILENAME1 && \
  unzip $FILENAME2 && unzip $FILENAME3
fi

export UID
export GID=`id -g`

export LAUNCH_SCRIPT=run_nclt.launch
#export LAUNCH_SCRIPT=run_m2dgr.launch

docker compose up

