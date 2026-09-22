---
name: tailor-resume-full
description: Modo completo de adaptação do currículo LaTeX do usuário para uma vaga específica — pergunta sobre toda lacuna da vaga (obrigatória ou desejável) não coberta no currículo-base, não só as obrigatórias. Use APENAS quando o usuário pedir explicitamente o modo completo/thorough (ex: "modo completo", "pergunta sobre tudo", "quero a versão completa"), ou quando o usuário digitar /tailor-resume-full. NÃO use só porque o usuário colou uma vaga — isso é o gatilho automático da skill tailor-resume (modo rápido), não desta.
---

# Tailor Resume (modo completo)

Mesmo processo core da `tailor-resume`, mas com um limiar mais amplo de perguntas sobre lacunas. Nunca dispara sozinha — só por pedido explícito, pra não adicionar fricção ao caminho padrão rápido.

## Quando usar

- O usuário pede explicitamente o "modo completo" ou equivalente ("pergunta sobre tudo", "versão completa", "modo thorough") ao adaptar o currículo para uma vaga
- O usuário digitou `/tailor-resume-full`

**Nunca dispare apenas porque uma vaga foi colada/linkada/anexada** — esse é o gatilho automático da `tailor-resume`. Se não houver pedido explícito de modo completo, deixe a `tailor-resume` (modo rápido) lidar com a vaga.

## Processo

Siga **integralmente** o processo descrito em `../tailor-resume/PROCESS.md` (caminho relativo a esta pasta — o motor compartilhado vive na skill `tailor-resume`, não é duplicado aqui) — regra inegociável, limitações conhecidas, e os 13 passos. Não duplique esse conteúdo aqui.

## Limiar de lacunas (passo 5 do processo)

**Pergunte sobre toda lacuna da vaga, obrigatória ou desejável**, desde que ainda não coberta pelo currículo-base nem por `meu-curriculo/InformacoesAdicionais.md`. Não pergunte sobre um requisito que já está coberto por qualquer uma das duas fontes, mesmo que fraseado diferente na vaga.

## Instalação

Instalada globalmente por link, pelo mesmo instalador e no mesmo padrão da `tailor-resume` (ver a seção "Instalação" do `SKILL.md` dela). Para localizar a raiz do projeto, resolva o link **desta** pasta, conforme o `PROCESS.md`. Se o link for perdido, rode o instalador de novo.
