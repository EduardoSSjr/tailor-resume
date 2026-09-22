---
name: tailor-resume
description: Adapta o currículo LaTeX do usuário para uma vaga específica, em português, inglês ou espanhol. Use sempre que o usuário colar o texto de uma descrição de vaga/job posting, mandar um link de uma vaga, ou anexar/apontar um arquivo (texto, markdown ou PDF) com a vaga, e quiser um currículo adaptado para ela — ou quando o usuário digitar /tailor-resume. Este é o modo rápido (só pergunta sobre lacunas em requisitos obrigatórios); para o modo completo, que pergunta sobre toda lacuna, veja a skill tailor-resume-full (só dispara por pedido explícito).
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

Siga **integralmente** o processo descrito em `PROCESS.md`, no mesmo diretório desta skill — regra inegociável, limitações conhecidas, e os 13 passos. Não duplique esse conteúdo aqui.

## Limiar de lacunas (passo 5 do processo)

**Só pergunte sobre lacunas em requisitos obrigatórios/necessários da vaga.** Lacunas em requisitos desejáveis continuam sendo omitidas em silêncio, como o processo já fazia antes desta funcionalidade existir — não pergunte sobre elas nesta skill.

## Instalação

Esta skill é instalada globalmente por **link, não por cópia**: o instalador do repositório (`instalar.ps1` no Windows, `instalar.sh` no Linux/macOS) cria `~/.claude/skills/tailor-resume` apontando para esta pasta — junction no Windows, que não exige privilégio de administrador, e symlink no Linux/macOS. Isso mantém o repositório como única fonte de verdade: editar este arquivo já vale globalmente, e a skill é reconhecida em qualquer pasta aberta no Claude Code, não só dentro do projeto.

Por causa do link, o caminho desta pasta não revela sozinho onde está o repositório — a seção "Localizando a raiz do projeto" do `PROCESS.md` explica como resolvê-lo. Se o link for perdido (reinstalação, máquina nova, repositório movido), rode o instalador de novo — ele é idempotente.
