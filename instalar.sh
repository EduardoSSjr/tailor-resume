#!/usr/bin/env bash
# Instalador Unix (Linux/macOS) do tailor-resume: pergunta os dados do
# config.json, detecta pdflatex no PATH, cria os links simbólicos globais
# das duas skills. Pode ser rodado de novo sobre uma instalação existente
# sem duplicar nada nem corromper o config.json. Equivalente ao
# instalar.ps1 (Windows), trocando junction por symlink (ln -s).

set -u

RAIZ_DO_PROJETO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="$RAIZ_DO_PROJETO/config.json"
CURRICULO_DIR="$RAIZ_DO_PROJETO/meu-curriculo"

echo "== Instalador do tailor-resume =="
echo "Raiz do projeto: $RAIZ_DO_PROJETO"
echo

# --- Leitura mínima do config.json existente (schema plano e conhecido,
#     não precisamos de um parser de JSON de verdade nem de depender de
#     jq/python estarem instalados). Não desfaz \\ escapado -- se algum dia
#     ler um config.json escrito pelo instalar.ps1 (ConvertTo-Json escapa
#     barras invertidas), um caminho Windows viria com \\ duplicado. Baixo
#     impacto: cada SO gera e usa o próprio config.json. ---
json_get_string() {
    grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$2" 2>/dev/null \
        | sed -E 's/.*:[[:space:]]*"([^"]*)"/\1/' | head -n1
}
json_get_number() {
    grep -o "\"$1\"[[:space:]]*:[[:space:]]*[0-9][0-9]*" "$2" 2>/dev/null \
        | sed -E 's/.*:[[:space:]]*([0-9]+)/\1/' | head -n1
}
# Escapa \\ e " antes de gravar uma string no JSON -- sem isso, um caminho
# ou nome de arquivo com aspas quebraria o config.json gerado.
json_escape() {
    printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

DEFAULT_ARQUIVO=""
DEFAULT_PAGINAS="1"
DEFAULT_CAMINHO=""
if [ -f "$CONFIG_PATH" ]; then
    if grep -q '"raizDoProjeto"' "$CONFIG_PATH" 2>/dev/null; then
        echo "config.json existente encontrado -- valores atuais viram sugestão, aperte Enter pra manter."
        valor="$(json_get_string arquivoCurriculo "$CONFIG_PATH")"
        [ -n "$valor" ] && DEFAULT_ARQUIVO="$valor"
        valor="$(json_get_number maximoDePaginas "$CONFIG_PATH")"
        [ -n "$valor" ] && DEFAULT_PAGINAS="$valor"
        valor="$(json_get_string caminhoPdflatex "$CONFIG_PATH")"
        [ -n "$valor" ] && DEFAULT_CAMINHO="$valor"
    else
        echo "Aviso: config.json existente não pôde ser lido (JSON inválido) -- ignorando e pedindo os valores de novo." >&2
    fi
fi

# --- Nome do arquivo de currículo ---
prompt="Nome do arquivo do seu currículo dentro de meu-curriculo/"
[ -n "$DEFAULT_ARQUIVO" ] && prompt="$prompt [$DEFAULT_ARQUIVO]"
read -r -p "$prompt: " resposta
ARQUIVO_CURRICULO="${resposta:-$DEFAULT_ARQUIVO}"
if [ -z "$ARQUIVO_CURRICULO" ]; then
    echo "Erro: nome do arquivo de currículo é obrigatório." >&2
    exit 1
fi

if [ ! -f "$CURRICULO_DIR/$ARQUIVO_CURRICULO" ]; then
    echo "Aviso: não encontrei '$ARQUIVO_CURRICULO' em meu-curriculo/ ainda -- coloque o arquivo lá antes de usar a skill. Continuando a instalação." >&2
fi

# --- Máximo de páginas ---
while true; do
    read -r -p "Máximo de páginas do currículo final [$DEFAULT_PAGINAS]: " resposta
    resposta="${resposta:-$DEFAULT_PAGINAS}"
    if [[ "$resposta" =~ ^[0-9]+$ ]] && [ "$resposta" -gt 0 ]; then
        MAXIMO_DE_PAGINAS="$resposta"
        break
    fi
    echo "Aviso: '$resposta' não é um número inteiro maior que zero -- tente de novo." >&2
done

# --- pdflatex: PATH primeiro, pergunta só se não achar ---
CAMINHO_PDFLATEX=""
if encontrado="$(command -v pdflatex 2>/dev/null)" && [ -n "$encontrado" ]; then
    echo "pdflatex encontrado no PATH ($encontrado) -- não vou perguntar o caminho."
else
    prompt="pdflatex não encontrado no PATH. Caminho completo do executável"
    [ -n "$DEFAULT_CAMINHO" ] && prompt="$prompt [$DEFAULT_CAMINHO]"
    read -r -p "$prompt: " resposta
    CAMINHO_PDFLATEX="${resposta:-$DEFAULT_CAMINHO}"
fi

# --- Escreve config.json ---
cat > "$CONFIG_PATH" <<EOF
{
  "raizDoProjeto": "$(json_escape "$RAIZ_DO_PROJETO")",
  "arquivoCurriculo": "$(json_escape "$ARQUIVO_CURRICULO")",
  "maximoDePaginas": $MAXIMO_DE_PAGINAS,
  "caminhoPdflatex": "$(json_escape "$CAMINHO_PDFLATEX")"
}
EOF
echo
echo "config.json escrito em $CONFIG_PATH"

# --- Links simbólicos globais das duas skills ---
instalar_skill_symlink() {
    local nome="$1"
    local origem="$RAIZ_DO_PROJETO/.claude/skills/$nome"
    local skills_globais="$HOME/.claude/skills"
    local destino="$skills_globais/$nome"
    local alvo_atual

    if [ ! -d "$origem" ]; then
        ULTIMO_ERRO="pasta da skill não encontrada: $origem"
        return 1
    fi
    mkdir -p "$skills_globais"

    if [ -L "$destino" ]; then
        alvo_atual="$(readlink "$destino")"
        if [ "$alvo_atual" = "$origem" ]; then
            echo "Link de '$nome' já existe e aponta pro lugar certo -- nada a fazer."
            return 0
        fi
        echo "Link de '$nome' existe mas aponta pra outro lugar -- recriando."
        rm "$destino"
    elif [ -e "$destino" ]; then
        ULTIMO_ERRO="'$destino' já existe e não é um link simbólico (é uma pasta ou arquivo real). Remova manualmente antes de rodar o instalador de novo."
        return 1
    fi

    if ! ln -s "$origem" "$destino"; then
        ULTIMO_ERRO="'ln -s' falhou ao criar o link em $destino"
        return 1
    fi
    echo "Link criado: $destino -> $origem"
}

erros=()
for nome in tailor-resume tailor-resume-full; do
    ULTIMO_ERRO=""
    if ! instalar_skill_symlink "$nome"; then
        echo "Aviso: falha ao instalar o link de '$nome': $ULTIMO_ERRO" >&2
        erros+=("'$nome': $ULTIMO_ERRO")
    fi
done

echo
if [ "${#erros[@]}" -gt 0 ]; then
    echo "Instalação concluída com pendências -- o config.json foi escrito, mas nem toda skill foi linkada:" >&2
    for erro in "${erros[@]}"; do
        echo "  - $erro" >&2
    done
    echo "Resolva o que está listado acima e rode o instalador de novo -- ele não duplica o que já deu certo." >&2
    exit 1
fi

echo "Instalação concluída. Abra o Claude Code em qualquer pasta e cole uma vaga para testar."
