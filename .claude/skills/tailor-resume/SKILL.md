---
name: tailor-resume
description: Adapta o currículo LaTeX de Eduardo Soldi Junior para uma vaga específica. Use sempre que o usuário colar, anexar, linkar ou mencionar uma descrição de vaga/job posting e quiser um currículo adaptado para ela, ou quando o usuário digitar /tailor-resume.
---

# Tailor Resume

Adapta o currículo-base em LaTeX para uma vaga específica, gerando uma nova aplicação sem nunca inventar experiência.

## Quando usar

- O usuário colou o texto de uma descrição de vaga na conversa
- O usuário pediu explicitamente para adaptar/customizar o currículo para uma vaga
- O usuário digitou `/tailor-resume`

Nesta versão da skill, a vaga chega como **texto colado diretamente na conversa**, em português. (Entrada por link ou arquivo, e vagas em inglês, ainda não são suportadas — ver o restante do backlog do projeto.)

## Regra inegociável

**Nunca invente experiência, responsabilidade, habilidade ou fato que não esteja presente no currículo-base.** Você só pode reescrever a *ênfase* e a *ordem* do que já existe — nunca adicionar conteúdo novo. Na dúvida se algo conta como "já existe", não inclua.

Também nunca use texto oculto, cor igual ao fundo, ou blocos soltos de palavras-chave só para enganar sistemas de triagem automática (ATS). Qualquer alinhamento com os termos da vaga deve ser uma reescrita natural e visível de conteúdo verdadeiro.

## Processo

1. **Leia o currículo-base** em `docs/EduardoSoldiCV.tex`, relativo à raiz do projeto (a pasta que contém `docs/`, `aplicacoes/`, este `.claude/`). Se o diretório de trabalho atual não for a raiz do projeto, localize-a antes de continuar.

2. **Extraia da vaga**: nome da empresa e o título do cargo. Serão usados no nome da pasta de saída. Normalize para minúsculas, sem acentos, com hífens no lugar de espaços (ex: "Analista de TI" → `analista-de-ti`).

3. **Identifique o que é editável e o que é fixo** no currículo-base:
   - **Editável** (pode reescrever texto e reordenar itens, usando só fatos já presentes): `Objetivo`; os itens da lista em `Perfil e Competências`; os bullets dentro de cada `\role{...}` (Experiência Profissional); os bullets dentro de cada `\project{...}` (Projetos).
   - **Fixo** (conteúdo nunca muda — no máximo a ordem dos blocos pode mudar, nunca o texto): cabeçalho de contato; os argumentos de `\role{cargo}{empresa}{datas}` e `\project{nome}`; `Formação`; `Cursos e Certificações`; `Idiomas`.

4. **Reescreva as seções editáveis** com foco na vaga:
   - Reordene os itens de `Perfil e Competências` colocando primeiro o que é mais relevante para a vaga.
   - Ajuste a redação do `Objetivo` e dos bullets de Experiência/Projetos para usar, quando genuinamente verdadeiro, termos e palavras-chave que aparecem na vaga — sem alterar o fato descrito, só a forma de descrevê-lo.
   - Você pode omitir itens editáveis pouco relevantes à vaga (isso ajuda a caber em 1 página), mas não pode adicionar itens novos.

5. **Escreva o novo arquivo** em `aplicacoes/<empresa>-<cargo>-<AAAA-MM>/curriculo.tex` (mês/ano atual). Nunca escreva em `docs/EduardoSoldiCV.tex` — esse arquivo é somente leitura para esta skill.

6. **Compile o PDF**: rode `pdflatex -interaction=nonstopmode -output-directory=<pasta-da-aplicação> <caminho-do-curriculo.tex>` (o executável do MiKTeX deve estar no PATH; se não estiver, localize `pdflatex.exe` sob a instalação do MiKTeX). Rode duas vezes se necessário para resolver referências. Se a compilação falhar, leia o `.log` gerado, corrija o `.tex` e recompile — nunca entregue um PDF que não compilou.

   Esta versão da skill **não** verifica nem corrige contagem de páginas — isso é tratado em uma extensão futura da skill. Por enquanto, apenas confirme que o PDF foi gerado sem erros de compilação.

7. **Salve a vaga original** em `aplicacoes/<empresa>-<cargo>-<AAAA-MM>/vaga.md`, com o texto exatamente como o usuário colou.

8. **Entregue um resumo curto** (2 a 4 linhas) do que foi priorizado/reescrito — por exemplo, quais competências foram colocadas em destaque e por quê. Não peça aprovação antes de finalizar; os arquivos já estão salvos quando você reporta o resumo.

## O que esta versão NÃO faz (fora de escopo aqui)

- Não corta conteúdo automaticamente se o PDF passar de 1 página
- Não aceita vaga por link ou arquivo, só texto colado
- Não traduz para inglês
