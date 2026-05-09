#!/bin/bash 
  if [ -S /ssh-agent ]; then 
    sudo chmod 666 /ssh-agent 
  fi 
exec "$@"
