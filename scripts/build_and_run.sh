#!/bin/bash

# Parar o script em caso de erro
set -e

# Clonar o repositório principal
echo "Clonando o repositório principal..."
git clone https://github.com/XandeBarros/sistemas-embarcados.git projeto
cd projeto

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
docker exec "$CONTAINER_ID" /eesc-aero/scripts/build_in_docker.sh

# Finalizar e remover o contêiner após o processo
echo "Finalizando o contêiner..."
docker stop "$CONTAINER_ID"
docker rm "$CONTAINER_ID"

# Copiar Arquivos buildados para a pasta local
echo "Copiando arquivos buildados..."
mv $(pwd)/projeto/build-arm32 $(pwd)

# Remover arquivos do Build
echo "Removendo arquivos do build..."
rm -rfv projeto

echo "Processo concluído com sucesso!"
