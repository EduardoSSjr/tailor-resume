---
name: tailor-resume
description: Adapta o currículo LaTeX de Eduardo Soldi Junior para uma vaga específica, em português ou inglês. Use sempre que o usuário colar o texto de uma descrição de vaga/job posting, mandar um link de uma vaga, ou anexar/apontar um arquivo (texto, markdown ou PDF) com a vaga, e quiser um currículo adaptado para ela — ou quando o usuário digitar /tailor-resume. Este é o modo rápido (só pergunta sobre lacunas em requisitos obrigatórios); para o modo completo, que pergunta sobre toda lacuna, veja a skill tailor-resume-full (só dispara por pedido explícito).
---

# Tailor Resume

Adapta o currículo-base em LaTeX para uma vaga específica, gerando uma nova aplicação sem nunca inventar experiência. Modo **rápido**: caminho padrão, sem fricção extra além do estritamente necessário.

## Quando usar

- O usuário colou o texto de uma descrição de vaga na conversa
- O usuário mandou um link de uma vaga
- O usuário anexou ou apontou um arquivo (texto, markdown ou PDF) com a descrição de uma vaga
- O usuário pediu explicitamente para adaptar/customizar o currículo para uma vaga
- O usuário digitou `/tailor-resume`

Esta é a skill que dispara **automaticamente** ao reconhecer uma vaga — é o caminho padrão. Para o modo completo (pergunta sobre toda lacuna, não só obrigatórias), veja `tailor-resume-full`, que só roda por pedido explícito.

## Processo

Siga **integralmente** o processo descrito em `C:\Users\edxlty\projects\tailor-resume\.claude\skills\tailor-resume\PROCESS.md` — regra inegociável, limitações conhecidas, e os 13 passos. Não duplique esse conteúdo aqui.

## Limiar de lacunas (passo 5 do processo)

**Só pergunte sobre lacunas em requisitos obrigatórios/necessários da vaga.** Lacunas em requisitos desejáveis continuam sendo omitidas em silêncio, como o processo já fazia antes desta funcionalidade existir — não pergunte sobre elas nesta skill.

## Instalação

Esta skill é instalada globalmente via **junction do NTFS** (`mklink /J`), não por cópia: `C:\Users\edxlty\.claude\skills\tailor-resume` aponta para `C:\Users\edxlty\projects\tailor-resume\.claude\skills\tailor-resume`. Isso mantém o repositório do projeto como única fonte de verdade — qualquer edição neste arquivo já vale globalmente, sem precisar reinstalar nem sincronizar duas cópias — e permite que a skill seja reconhecida em qualquer pasta de trabalho aberta no Claude Code nesta máquina (CLI, app desktop ou extensão de IDE), não só dentro deste projeto.

Symlink normal (`New-Item -ItemType SymbolicLink`) exige privilégio de administrador no Windows; a junction não exige. Se a junction for perdida (ex: reinstalação do Windows, nova máquina), recrie com:

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills" | Out-Null
cmd /c mklink /J "$env:USERPROFILE\.claude\skills\tailor-resume" "$env:USERPROFILE\projects\tailor-resume\.claude\skills\tailor-resume"
```

Validado com smoke test: rodando `claude -p` a partir de uma pasta fora do projeto, tanto o gatilho automático (colar uma vaga) quanto o comando explícito `/tailor-resume` reconheceram a skill corretamente e geraram a saída nos caminhos absolutos certos do projeto (`aplicacoes/`, `docs/EduardoSoldiCV.tex`), nunca relativos à pasta de onde a sessão foi aberta.
