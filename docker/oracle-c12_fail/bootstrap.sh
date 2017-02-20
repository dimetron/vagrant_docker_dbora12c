#!/bin/bash

if [[ $1 == "-d" ]]; then
  service dbstart start  
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi