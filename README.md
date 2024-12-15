# Projeto para Build Automático

## Visão Geral
Este repositório contém um script para automatizar a instalação, configuração e build do Projeto 'eesc-aero-embbed-systems' do Henrique Gargia (Grilo).

**Autores:** 
- `Alexandre Barros de Araújo, 11802989`; 
- `Ana Luiza Soares Mineiro Rocha, 12549832`; 
- `Arthur Pompeu dos Santos Rocha, 12549363`


## Instalação

### Requisitos:
- **Git**: Para clonar repositórios.
- **Docker**: Para criar e executar contêineres.
- **Bash**: Para executar o script de automação.

### Passos para execução do código:

1. **Acesse a pasta scripts no repositório principal**

    No github navegue até a pasta `scripts`

2. **Copie o código do script build_and_run.sh**

    Copie o conteúdo do script `build_and_run.sh` para o local onde deseja executá-lo. 


3. **Dê permissão de execução ao script**

    Antes de executar o script, dê permissão de execução ao arquivo:
    ```bash
    chmod +x build_and_run.sh
    ```

4. **Execute o script**

    Use o script para clonar, configurar e buildar o projeto. Você pode personalizar as seguintes opções:

    - `--folder-name`: Define o nome da pasta onde o repositório será clonado. Padrão: `projeto`.
    - `--clean-install`: Define se os arquivos temporários serão removidos (`1`) ou mantidos (`0`). Padrão: `1`.
    - `--arch-target`: Seleciona a arquitetura do build: `arm32` | `x86_64` | `riscv64`. Padrão: `arm32`.

    Exemplo de execução:

    ```bash
    ./build_and_run.sh --folder-name=sistema-embarcado --clean-install=1 --arm-target=1
    ```

## Resultado

Ao final da execução do script, os arquivos buildados serão copiados para a pasta correspondente à arquitetura selecionada:

- Para ARM32: `build-arm32`
- Para x86_64: `build-x86_64`
- Para riscv64: `build-riscv64`

E existirá uma docker image na qual as bibliotecas foram buildadas.

- `builder-arm32` ou `builder-x86_64` ou `builder-riscv64`

Se a opção `--clean-install=1` foi utilizada, os arquivos temporários serão removidos

Por exemplo, ao executar:

```bash
./build_and_run.sh --clean-install=1 --arm-target=0
```

Haverá um arquivo chamado 'eesc-aero-embedded-systems' dentro do diretório build-x86_64.

Para verificar o arquivo use o comando:

```bash
file build-x86_64/eesc-aero-embedded-systems
```

Isso exibirá:

```text
build-x86_64/eesc-aero-embedded-systems: ELF 64-bit LSB pie executable, x86-64, version 1 (GNU/Linux), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=959c035f157b88b3d94b2e12f7b331f9dfdc52e6, for GNU/Linux 3.2.0, with debug_info, not stripped
```

### Notas

Para ver as opções do script, utilize a flag `--help`:

```bash
./build_and_run.sh --help
```

Isso exibirá:

```text
Uso: build_and_run.sh [--folder-name=NOME_DA_PASTA] [--clean-install=0|1] [--arch-target=x86_64|arm32|riscv64]

Opções:
  --folder-name=NOME_DA_PASTA   Define o nome da pasta onde o repositório será clonado. Padrão: 'projeto'.
  --clean-install=0|1           Define se os arquivos temporários serão excluídos (1) ou não (0). Padrão: 1.
  --arch-target=x86_64|arm32|riscv64 Escolhe arquitetura do Build. Padrão: 'arm32'.
```

## Contribuição

Este script automatiza o processo de configuração do ambiente, tornando mais fácil trabalhar com o projeto. Caso encontre algum problema ou tenha sugestões de melhoria, sinta-se à vontade para abrir uma issue neste repositório.