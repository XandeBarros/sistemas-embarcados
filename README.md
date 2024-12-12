# Projeto para Build Automático

Este repositório contém um script para automatizar a instalação, configuração e build do Projeto 'eesc-aero-embbed-systems' do Henrique Gargia (Grilo). Siga as etapas abaixo para realizar a configuração do projeto corretamente.

**Autores:** 
- `Alexandre Barros de Araújo, 11802989`; 
- `Ana Luiza Soares Mineiro Rocha, 12549832`; 
- `Arthur Pompeu dos Santos Rocha, 12549363`


## Requisitos

Antes de iniciar, certifique-se de que os seguintes itens estão instalados no seu sistema:

- **Git**: Para clonar repositórios.
- **Docker**: Para criar e executar contêineres.
- **Bash**: Para executar o script de automação.

## Instalação

### 1. Acesse a pasta `scripts` no repositório principal

No github navegue até a pasta `scripts`:

### 2. Copie o código do script `build_and_run.sh`

Copie o conteúdo do script `build_and_run.sh` para o local onde deseja executá-lo. 

O código se encontra abaixo caso encontre dificuldades para encontrar o arquivo.

```bash
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

# Verificar se o usuário pediu para limpar os arquivos temporários
if [ "$IS_ARM" -eq 1 ]; then
  echo -e "${GREEN}Acessando a Pasta Docker em '${ARCH_TYPE}' ${RESET}"
  cd dockerfile_arm32
else
  echo -e "${GREEN}Acessando a Pasta Docker em '${ARCH_TYPE}' ${RESET}"
  cd dockerfile_x86_64
fi

# Clonar a biblioteca necessária
echo -e "${YELLOW}Clonando a biblioteca necessária...${RESET}"
git clone https://github.com/lely-industries/lely-core.git

BUILDER_NAME=$( [ "$IS_ARM" -eq 1 ] && echo "builder-arm32" || echo "builder-x86_64" )

# Construir a imagem Docker
echo -e "${YELLOW}Construindo a imagem Docker...${RESET}"
docker build . -t "$BUILDER_NAME"

echo -e "${YELLOW}Retornando ao diretório raiz...${RESET}"
cd ..

# Rodar o contêiner e executar o script interno
echo -e "${YELLOW}Rodando o contêiner e configurando o ambiente...${RESET}"
CONTAINER_ID=$(docker run -dit --volume $(pwd):/eesc-aero "$BUILDER_NAME")

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

```

### 3. Dê permissão de execução ao script

Antes de executar o script, dê permissão de execução ao arquivo:

```bash
chmod +x build_and_run.sh
```

### 4. Execute o script

Use o script para clonar, configurar e buildar o projeto. Você pode personalizar as seguintes opções:

- `--folder-name`: Define o nome da pasta onde o repositório será clonado. Padrão: `projeto`.
- `--clean-install`: Define se os arquivos temporários serão removidos (1) ou mantidos (0). Padrão: `1`.
- `--arm-target`: Seleciona a arquitetura do build: `1` para ARM32 ou `0` para x86_64. Padrão: `1`.

Exemplo de execução:

```bash
./build_and_run.sh --folder-name=sistema-embarcado --clean-install=1 --arm-target=1
```

### 5. Resultado do Build

Ao final da execução do script, os arquivos buildados serão copiados para a pasta correspondente à arquitetura selecionada:

- Para ARM32: `build-arm32`
- Para x86_64: `build-x86_64`

Se a opção `--clean-install=1` foi utilizada, os arquivos temporários serão removido

Por exemplo, ao executar:

```bash
./build_and_run.sh --clean-install=1 --arm-target=0
```
Haverá um arquivo chamado 'eesc-aero-embedded-systems' dentro do diretório `build-x86_64`.

Para verificar o arquivo use o comando:

```bash
file build-x86_64/eesc-aero-embedded-systems
```

Isso exibirá:

```text
build-x86_64/eesc-aero-embedded-systems: ELF 64-bit LSB pie executable, x86-64, version 1 (GNU/Linux), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=959c035f157b88b3d94b2e12f7b331f9dfdc52e6, for GNU/Linux 3.2.0, with debug_info, not stripped
```

## Ajuda

Para ver as opções do script, utilize a flag `--help`:

```bash
./build_and_run.sh --help
```

Isso exibirá:

```text
Uso: build_and_run.sh [--folder-name=NOME_DA_PASTA] [--clean-install=0|1] [--arm-target=0|1]

Opções:
  --folder-name=NOME_DA_PASTA   Define o nome da pasta onde o repositório será clonado. Padrão: 'projeto'.
  --clean-install=0|1           Define se os arquivos temporários serão excluídos (1) ou não (0). Padrão: 1.
  --arm-target=0|1              Escolhe arquitetura do Build (1 para ARM32 ou 0 para X86_64). Padrão: 1.
```

## Conclusão

Este script automatiza o processo de configuração do ambiente, tornando mais fácil trabalhar com o projeto. Caso encontre algum problema ou tenha sugestões de melhoria, sinta-se à vontade para abrir uma *issue* neste repositório.
