#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KAOLIN_DIR="${KAOLIN_DIR:-/kaolin}"

if [ ! -d "${KAOLIN_DIR}" ]; then
  if [ -d "${ROOT}/kaolin" ]; then
    KAOLIN_DIR="${ROOT}/kaolin"
  else
    echo "Kaolin source not found. Clone it to /kaolin (docker) or ${ROOT}/kaolin (local)."
    echo "Example: git clone --recursive https://github.com/NVIDIAGameWorks/kaolin ${ROOT}/kaolin"
    exit 1
  fi
fi

if ! command -v cmake >/dev/null 2>&1; then
  echo "cmake is required but was not found in PATH."
  exit 1
fi

if ! command -v nvcc >/dev/null 2>&1; then
  echo "nvcc is required to compile CUDA extensions. Please install CUDA toolkit first."
  exit 1
fi

cd "${KAOLIN_DIR}" && pip install -e .
cd "${ROOT}/mycuda" && rm -rf build *egg* && pip install -e .
cd "${ROOT}/BundleTrack" && rm -rf build && mkdir build && cd build && cmake .. && make -j"$(nproc)"
