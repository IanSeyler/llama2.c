#!/usr/bin/env bash

echo "Downloading stories15M.bin"

if [ -x "$(command -v curl)" ]; then
	curl -s -o stories15M.bin https://huggingface.co/karpathy/tinyllamas/resolve/main/stories15M.bin
else
	wget -q https://huggingface.co/karpathy/tinyllamas/resolve/main/stories15M.bin
fi
