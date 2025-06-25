#!/usr/bin/env bash

echo "Downloading stories15M.bin"
if [ -x "$(command -v curl)" ]; then
	curl -s -o stories15M.bin -L https://huggingface.co/karpathy/tinyllamas/resolve/main/stories15M.bin
else
	wget -q https://huggingface.co/karpathy/tinyllamas/resolve/main/stories15M.bin
fi

echo "Converting stories15M.bin to stories15M.o"
ld -r -b binary -o stories15M.o stories15M.bin
