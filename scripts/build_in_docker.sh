#!/bin/bash

# Função para exibir ajuda
show_help() {
  echo "Uso: build_in_docker.sh [--arm-target=0|1]"
  echo ""
  echo "Opções:"
  echo "  --arm-target=0|1              Escolhe arquitetura do Build (1) ARM32 ou (0) X86_64. Padrão: 1 ARM32"
  exit 1
}

# Parsear argumentos
for ARG in "$@"; do
  case $ARG in
    --arm-target=*)
      IS_ARM="${ARG#*=}"
      ;;
    --help|-h)
      show_help
      ;;
    *)
      echo "Opção desconhecida: $ARG"
      show_help
      ;;
  esac
done

# Parar o script em caso de erro
set -e

echo "Entrando no diretório do projeto..."
echo "Criando diretório de build para ARM32..."
cd /eesc-aero
mkdir build-arm32
cd build-arm32

echo "Executando CMake com o ARM_TARGET..."
cmake -DARM_TARGET=IS_ARM ..

echo "Construindo o programa com make..."
make

echo "Build concluído com sucesso!"
