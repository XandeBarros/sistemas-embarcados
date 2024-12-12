#!/bin/bash

# Códigos de cores ANSI
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Função para exibir ajuda
show_help() {
  echo -e "${YELLOW}Uso: build_in_docker.sh [--arm-target=0|1]${RESET}"
  echo -e "\nOpções:"
  echo -e "  ${BLUE}--arm-target=0|1${RESET}              Escolhe arquitetura do Build (1) ARM32 ou (0) X86_64. Padrão: 1 ARM32"
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
      echo -e "${RED}Opção desconhecida: $ARG${RESET}"
      show_help
      ;;
  esac
done

# Parar o script em caso de erro
set -e

# Determinar o tipo de arquitetura
ARCH_TYPE=$( [ "$IS_ARM" -eq 1 ] && echo "ARM32" || echo "X86_64" )
BUILD_FOLDER=$( [ "$IS_ARM" -eq 1 ] && echo "build-arm32" || echo "build-x86_64" )

# Entrar no diretório do projeto
echo -e "${BLUE}Entrando no diretório do projeto...${RESET}"
cd /eesc-aero

# Criar diretório de build
echo -e "${YELLOW}Criando diretório de build para ${ARCH_TYPE}...${RESET}"
mkdir "$BUILD_FOLDER"
cd "$BUILD_FOLDER"

# Executar CMake
echo -e "${GREEN}Executando CMake para ${ARCH_TYPE}...${RESET}"
cmake -DARM_TARGET=$IS_ARM ..

# Construir com make
echo -e "${GREEN}Construindo o programa com make...${RESET}"
make

# Build concluído
echo -e "${GREEN}Build concluído com sucesso!${RESET}"
