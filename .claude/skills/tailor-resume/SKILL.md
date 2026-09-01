---
name: tailor-resume
description: Adapta o currículo LaTeX de Eduardo Soldi Junior para uma vaga específica. Use sempre que o usuário colar o texto de uma descrição de vaga/job posting em português e quiser um currículo adaptado para ela, ou quando o usuário digitar /tailor-resume. Não use para vaga enviada por link, arquivo anexado, ou em inglês — ainda não suportado.
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

1. **Leia o currículo-base.** A raiz do projeto é sempre `C:\Users\edxlty\projects\tailor-resume` (caminho absoluto — esta skill é pessoal e específica deste projeto, não precisa descobrir a raiz dinamicamente). Leia `C:\Users\edxlty\projects\tailor-resume\docs\EduardoSoldiCV.tex`, independente de qual seja o diretório de trabalho atual. Se esse caminho não existir mais, pare e avise o usuário em vez de adivinhar outro local (o projeto pode ter sido movido; esta linha do SKILL.md precisaria ser atualizada).

2. **Extraia da vaga**: nome da empresa e o título do cargo. Serão usados no nome da pasta de saída. Normalize assim: minúsculas, sem acentos, remova qualquer caractere que não seja letra, número ou espaço (inclusive `&`, `/`, parênteses), depois troque espaços por hífen (ex: "Analista de T.I. (Sênior)" → `analista-de-ti-senior`).

3. **Identifique o que é editável e o que é fixo** no currículo-base:
   - **Editável** (pode reescrever texto e reordenar itens, usando só fatos já presentes): `Objetivo`; os itens da lista em `Perfil e Competências`; os bullets dentro de cada `\role{...}` (Experiência Profissional); os bullets dentro de cada `\project{...}` (Projetos).
   - **Fixo** (conteúdo nunca muda — no máximo a ordem dos blocos pode mudar, nunca o texto): cabeçalho de contato; os argumentos de `\role{cargo}{empresa}{datas}` e `\project{nome}`; `Formação`; `Cursos e Certificações`; `Idiomas`.

4. **Reescreva as seções editáveis** com foco na vaga:
   - Reordene os itens de `Perfil e Competências` colocando primeiro o que é mais relevante para a vaga.
   - Ajuste a redação do `Objetivo` e dos bullets de Experiência/Projetos para usar, quando genuinamente verdadeiro, termos e palavras-chave que aparecem na vaga — sem alterar o fato descrito, só a forma de descrevê-lo.
   - Você pode omitir itens editáveis pouco relevantes à vaga, mas não pode adicionar itens novos. (Isso é só sobre relevância — esta versão da skill não verifica nem tenta controlar contagem de páginas; ver passo 6.)

5. **Defina a pasta da aplicação**: `aplicacoes/<empresa>-<cargo>-<AAAA-MM>/` (mês/ano atual), a partir da raiz do projeto do passo 1. Se essa pasta já existir (segunda aplicação para a mesma empresa/cargo no mesmo mês), acrescente um sufixo numérico: `-2`, `-3`, etc., até chegar num nome que não existe ainda. Nunca sobrescreva uma aplicação anterior.

   Escreva o novo `.tex` em `curriculo.tex` dentro dessa pasta. Nunca escreva em `docs/EduardoSoldiCV.tex` — esse arquivo é somente leitura para esta skill.

6. **Compile o PDF**: rode `pdflatex -interaction=nonstopmode -output-directory=<pasta-da-aplicação> curriculo.tex` de dentro da pasta da aplicação. O executável costuma estar em `pdflatex` (se o PATH já tiver sido atualizado) ou em `C:\Users\edxlty\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe` (instalação padrão do MiKTeX nesta máquina) — tente o primeiro, caia para o segundo se não for encontrado.

   Rode até 2 vezes se necessário para resolver referências. Se a compilação falhar, leia o `.log` gerado, corrija o `.tex` e recompile — no máximo **3 tentativas de correção** no total. Se ainda assim não compilar, pare, explique o erro ao usuário e não entregue um PDF quebrado.

   Esta versão da skill **não** verifica nem corrige contagem de páginas — isso é tratado em uma extensão futura da skill. Por enquanto, apenas confirme que o PDF foi gerado sem erros de compilação.

   Depois de compilar com sucesso, apague os arquivos auxiliares que o `pdflatex` gerou na pasta da aplicação (`curriculo.aux`, `curriculo.log`, `curriculo.out`); só `curriculo.tex` e `curriculo.pdf` devem sobrar dessa etapa.

7. **Salve a vaga original** em `vaga.md`, dentro da mesma pasta da aplicação, com o texto exatamente como o usuário colou.

8. **Entregue um resumo curto** (2 a 4 linhas) do que foi priorizado/reescrito — por exemplo, quais competências foram colocadas em destaque e por quê. Não peça aprovação antes de finalizar; os arquivos já estão salvos quando você reporta o resumo.

## O que esta versão NÃO faz (fora de escopo aqui)

- Não corta conteúdo automaticamente se o PDF passar de 1 página
- Não aceita vaga por link ou arquivo, só texto colado
- Não traduz para inglês
