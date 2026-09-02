---
name: tailor-resume-full
description: Modo completo de adaptação do currículo LaTeX de Eduardo Soldi Junior para uma vaga específica — pergunta sobre toda lacuna da vaga (obrigatória ou desejável) não coberta no currículo-base, não só as obrigatórias. Use APENAS quando o usuário pedir explicitamente o modo completo/thorough (ex: "modo completo", "pergunta sobre tudo", "quero a versão completa"), ou quando o usuário digitar /tailor-resume-full. NÃO use só porque o usuário colou uma vaga — isso é o gatilho automático da skill tailor-resume (modo rápido), não desta.
---

# Tailor Resume (modo completo)

Mesmo processo core da `tailor-resume`, mas com um limiar mais amplo de perguntas sobre lacunas. Nunca dispara sozinha — só por pedido explícito, pra não adicionar fricção ao caminho padrão rápido.

## Quando usar

- O usuário pede explicitamente o "modo completo" ou equivalente ("pergunta sobre tudo", "versão completa", "modo thorough") ao adaptar o currículo para uma vaga
- O usuário digitou `/tailor-resume-full`

**Nunca dispare apenas porque uma vaga foi colada/linkada/anexada** — esse é o gatilho automático da `tailor-resume`. Se não houver pedido explícito de modo completo, deixe a `tailor-resume` (modo rápido) lidar com a vaga.

## Processo

Siga **integralmente** o processo descrito em `C:\Users\edxlty\projects\tailor-resume\.claude\skills\tailor-resume\PROCESS.md` — regra inegociável, limitações conhecidas, e os 13 passos. Não duplique esse conteúdo aqui.

## Limiar de lacunas (passo 5 do processo)

**Pergunte sobre toda lacuna da vaga, obrigatória ou desejável**, desde que ainda não coberta pelo currículo-base nem por `docs/InformacoesAdicionais.md`. Não pergunte sobre um requisito que já está coberto por qualquer uma das duas fontes, mesmo que fraseado diferente na vaga.

## Instalação

Instalada globalmente via **junction do NTFS**, no mesmo padrão da `tailor-resume` (ver a seção "Instalação" do `SKILL.md` dela para o racional completo): `C:\Users\edxlty\.claude\skills\tailor-resume-full` aponta para `C:\Users\edxlty\projects\tailor-resume\.claude\skills\tailor-resume-full`. Se a junction for perdida, recrie com:

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills" | Out-Null
cmd /c mklink /J "$env:USERPROFILE\.claude\skills\tailor-resume-full" "$env:USERPROFILE\projects\tailor-resume\.claude\skills\tailor-resume-full"
```
