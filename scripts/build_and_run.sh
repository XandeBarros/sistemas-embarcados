#!/bin/bash

# Valores padrão
FOLDER_NAME="projeto"  # Nome padrão da pasta
CLEAN_INSTALL=1        # Limpeza ativada por padrão
IS_ARM=1               # Seleciona Arm32 como padrão

# Função para exibir ajuda
show_help() {
  echo "Uso: build_and_run.sh [--folder-name=NOME_DA_PASTA] [--clean-install=0|1] [--arm-target=0|1]"
  echo ""
  echo "Opções:"
  echo "  --folder-name=NOME_DA_PASTA   Define o nome da pasta onde o repositório será clonado. Padrão: 'projeto'."
  echo "  --clean-install=0|1           Define se os arquivos temporários serão excluídos (1) ou não (0). Padrão: 1."
  echo "  --arm-target=0|1              Escolhe arquitetura do Build (1) ARM32 ou (0) X86_64. Padrão: 1 ARM32"
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
      echo "Opção desconhecida: $ARG"
      show_help
      ;;
  esac
done

# Parâmetros definidos
echo "Nome da pasta: $FOLDER_NAME"
echo "Clean install: $CLEAN_INSTALL"

# Parar o script em caso de erro
set -e

# Clonar o repositório principal
echo "Clonando o repositório principal..."
git clone https://github.com/XandeBarros/sistemas-embarcados.git "$FOLDER_NAME"
cd "$FOLDER_NAME"

cd dockerfile

# Clonar a biblioteca necessária
echo "Clonando a biblioteca necessária..."
git clone https://github.com/lely-industries/lely-core.git

# Construir a imagem Docker
echo "Construindo a imagem Docker..."
docker build . -t builder 

echo "Retornando ao diretório raiz..."
cd ..

# Rodar o contêiner e executar o script interno
echo "Rodando o contêiner e configurando o ambiente..."
CONTAINER_ID=$(docker run -dit --volume $(pwd):/eesc-aero builder)

# Garantir permissões de execução para o script de build
echo "Dando permissão de execução ao script build_in_docker.sh dentro do contêiner..."
docker exec "$CONTAINER_ID" chmod +x /eesc-aero/scripts/build_in_docker.sh

# Executar o script de build dentro do contêiner
echo "Executando o script de build dentro do contêiner..."
docker exec "$CONTAINER_ID" /eesc-aero/scripts/build_in_docker.sh --arm-target=IS_ARM

# Finalizar e remover o contêiner após o processo
echo "Finalizando o contêiner..."
docker stop "$CONTAINER_ID"
docker rm "$CONTAINER_ID"
cd ..

# Copiar Arquivos buildados para a pasta local
echo "Copiando arquivos buildados..."
mv $(pwd)/"$FOLDER_NAME"/build-arm32 $(pwd)

# Verificar se o usuário pediu para limpar os arquivos temporários
if [ "$CLEAN_INSTALL" -eq 1 ]; then
  echo "Removendo arquivos do build..."
  rm -rfv "$FOLDER_NAME"
else
  echo "Arquivos temporários mantidos em '$FOLDER_NAME'."
fi

echo "Processo concluído com sucesso!"
