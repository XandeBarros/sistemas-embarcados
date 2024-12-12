#!/bin/bash

# Valores padrão
FOLDER_NAME="projeto"  # Nome padrão da pasta
CLEAN_INSTALL=1        # Limpeza ativada por padrão
IS_ARM=1               # Seleciona ARM32 como padrão

# Códigos de cores ANSI
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Função para exibir ajuda
show_help() {
  echo -e "${YELLOW}Uso: build_and_run.sh [--folder-name=NOME_DA_PASTA] [--clean-install=0|1] [--arm-target=0|1]${RESET}"
  echo ""
  echo -e "${BLUE}Opções:${RESET}"
  echo -e "${GREEN}  --folder-name=NOME_DA_PASTA   ${RESET}Define o nome da pasta onde o repositório será clonado. Padrão: 'projeto'."
  echo -e "${GREEN}  --clean-install=0|1           ${RESET}Define se os arquivos temporários serão excluídos (1) ou não (0). Padrão: 1."
  echo -e "${GREEN}  --arm-target=0|1              ${RESET}Escolhe arquitetura do Build (1 para ARM32 ou 0 para X86_64). Padrão: 1 (ARM32)."
  exit 1
}

# Parsear argumentos
for ARG in "$@"; do
  case $ARG in
    --folder-name=*)
      FOLDER_NAME="${ARG#*=}"
      ;;
    --clean-install=*)
      CLEAN_INSTALL="${ARG#*=}"
      ;;
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

# Parâmetros definidos
echo -e "${BLUE}Nome da pasta:${RESET} $FOLDER_NAME"
INSTALL_TYPE=$( [ "$CLEAN_INSTALL" -eq 1 ] && echo "True" || echo "False" )
echo -e "${BLUE}Clean install:${RESET} $INSTALL_TYPE"
ARCH_TYPE=$( [ "$IS_ARM" -eq 1 ] && echo "ARM32" || echo "X86_64" )
echo -e "${BLUE}Arquitetura selecionada:${RESET} $ARCH_TYPE"

# Parar o script em caso de erro
set -e

# Clonar o repositório principal
echo -e "${YELLOW}Clonando o repositório principal...${RESET}"
git clone https://github.com/XandeBarros/sistemas-embarcados.git "$FOLDER_NAME"
cd "$FOLDER_NAME"

cd dockerfile

# Clonar a biblioteca necessária
echo -e "${YELLOW}Clonando a biblioteca necessária...${RESET}"
git clone https://github.com/lely-industries/lely-core.git

# Construir a imagem Docker
echo -e "${YELLOW}Construindo a imagem Docker...${RESET}"
docker build . -t builder 

echo -e "${YELLOW}Retornando ao diretório raiz...${RESET}"
cd ..

# Rodar o contêiner e executar o script interno
echo -e "${YELLOW}Rodando o contêiner e configurando o ambiente...${RESET}"
CONTAINER_ID=$(docker run -dit --volume $(pwd):/eesc-aero builder)

# Garantir permissões de execução para o script de build
echo -e "${YELLOW}Dando permissão de execução ao script build_in_docker.sh dentro do contêiner...${RESET}"
docker exec "$CONTAINER_ID" chmod +x /eesc-aero/scripts/build_in_docker.sh

# Executar o script de build dentro do contêiner com a arquitetura selecionada
echo -e "${YELLOW}Executando o script de build dentro do contêiner para a arquitetura ${BLUE}$ARCH_TYPE${YELLOW}...${RESET}"
docker exec "$CONTAINER_ID" /eesc-aero/scripts/build_in_docker.sh --arm-target="$IS_ARM"

# Finalizar e remover o contêiner após o processo
echo -e "${YELLOW}Finalizando o contêiner...${RESET}"
docker stop "$CONTAINER_ID"
docker rm "$CONTAINER_ID"
cd ..

# Copiar arquivos buildados para a pasta local
BUILD_FOLDER=$( [ "$IS_ARM" -eq 1 ] && echo "build-arm32" || echo "build-x86_64" )
echo -e "${YELLOW}Copiando arquivos buildados ($BUILD_FOLDER)...${RESET}"
mv $(pwd)/"$FOLDER_NAME"/"$BUILD_FOLDER" $(pwd)

# Verificar se o usuário pediu para limpar os arquivos temporários
if [ "$CLEAN_INSTALL" -eq 1 ]; then
  echo -e "${RED}Removendo arquivos do build...${RESET}"
  rm -rfv "$FOLDER_NAME"
else
  echo -e "${GREEN}Arquivos temporários mantidos em '${FOLDER_NAME}'.${RESET}"
fi

echo -e "${GREEN}Processo concluído com sucesso!${RESET}"
