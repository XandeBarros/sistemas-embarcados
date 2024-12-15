#!/bin/bash

# Códigos de cores ANSI
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Função para exibir ajuda
show_help() {
  echo -e "${YELLOW}Uso: build_in_docker.sh [--arch-target=x86_64|arm32|riscv64]${RESET}"
  echo -e "\nOpções:"
  echo -e "  ${BLUE}--arch-target=x86_64|arm32|riscv64${RESET}  Escolhe arquitetura do Build. Padrão: arm32"
  exit 1
}

# Valores padrão
ARCH_TARGET="arm32"

# Parsear argumentos
for ARG in "$@"; do
  case $ARG in
    --arch-target=*)
      ARCH_TARGET="${ARG#*=}"
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

# Validar a arquitetura
case $ARCH_TARGET in
  "x86_64"|"arm32"|"riscv64")
    ;;
  *)
    echo -e "${RED}Arquitetura inválida: ${ARCH_TARGET}${RESET}"
    show_help
    ;;
esac

# Determinar diretório de build
BUILD_FOLDER="build-${ARCH_TARGET}"

# Entrar no diretório do projeto
echo -e "${BLUE}Entrando no diretório do projeto...${RESET}"
cd /eesc-aero

# Criar diretório de build
echo -e "${YELLOW}Criando diretório de build para ${ARCH_TARGET}...${RESET}"
mkdir "$BUILD_FOLDER"
cd "$BUILD_FOLDER"

# Executar CMake
echo -e "${GREEN}Executando CMake para ${ARCH_TARGET}...${RESET}"
cmake -DARCH_TARGET="$ARCH_TARGET" ..

# Construir com make
echo -e "${GREEN}Construindo o programa com make...${RESET}"
make

# Build concluído
echo -e "${GREEN}Build concluído com sucesso para ${ARCH_TARGET}!${RESET}"
