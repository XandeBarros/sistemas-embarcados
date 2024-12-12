#!/bin/bash

# Parar o script em caso de erro
set -e

echo "Entrando no diretório do projeto..."
echo "Criando diretório de build para ARM32..."
cd /eesc-aero
mkdir build-arm32
cd build-arm32

echo "Executando CMake com o ARM_TARGET..."
cmake -DARM_TARGET=1 ..

echo "Construindo o programa com make..."
make

echo "Build concluído com sucesso!"
