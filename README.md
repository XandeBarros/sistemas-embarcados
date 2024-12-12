# Projeto para Build Automático

Este repositório contém um script para automatizar a instalação, configuração e build do Projeto 'eesc-aero-embbed-systems' do Henrique Gargia (Grilo). Siga as etapas abaixo para realizar a configuração do projeto corretamente.

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

Se a opção `--clean-install=1` foi utilizada, os arquivos temporários serão removidos.

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
