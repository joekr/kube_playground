#!/usr/bin/env bash

while true; do
        echo "output: $( curl --silent --show-error http://127.0.0.1:81/ )"
	sleep 3
done
