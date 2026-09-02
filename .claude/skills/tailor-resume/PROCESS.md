# Processo core (compartilhado)

Este documento descreve o processo completo usado pelas skills **tailor-resume** e **tailor-resume-full**. As duas seguem exatamente este processo; a única diferença entre elas é o **limiar** usado no passo 5 (quais lacunas geram pergunta), definido no `SKILL.md` de cada uma. Nunca duplique este processo dentro de um `SKILL.md` — sempre referencie este arquivo.

Raiz do projeto: `C:\Users\edxlty\projects\tailor-resume` (caminho absoluto — este processo é pessoal e específico deste projeto, não precisa descobrir a raiz dinamicamente).

## Regra inegociável

**Nunca invente experiência, responsabilidade, habilidade ou fato que não esteja presente nas fontes de verdade (currículo-base + `InformacoesAdicionais.md`, ver passo 2).** Você só pode reescrever a *ênfase* e a *ordem* do que já existe — nunca adicionar conteúdo novo. Na dúvida se algo conta como "já existe", não inclua. A única forma de incorporar um fato que não está em nenhuma das duas fontes é confirmá-lo com o usuário no passo 5 e, depois, persisti-lo no passo 12 — nunca assumir por conta própria.

Também nunca use texto oculto, cor igual ao fundo, ou blocos soltos de palavras-chave só para enganar sistemas de triagem automática (ATS). Qualquer alinhamento com os termos da vaga deve ser uma reescrita natural e visível de conteúdo verdadeiro.

> ⚠️ **Limitação conhecida e esperada — links de vaga em plataformas de ATS**
> Muitos sites de vaga usados no Brasil (InHire, Gupy, Kenoby, LinkedIn, entre outros) bloqueiam requisições automatizadas e retornam erro (ex: HTTP 403) mesmo com o link certo, acessível normalmente num navegador. **Isso não é um bug da skill, é bloqueio anti-bot do site**, e não deve ser contornado. Quando acontecer: pare, avise o usuário com essa explicação, e sugira colar o texto da vaga ou salvar a página como arquivo (PDF/texto) e apontar o arquivo — o caminho de arquivo funciona mesmo para páginas "impressas" em PDF sem camada de texto, porque a leitura é multimodal.

## Processo

1. **Obtenha o texto da vaga**, conforme o formato em que ela chegou:
   - **Texto colado**: use o texto exatamente como está na conversa.
   - **Link**: busque o conteúdo com WebFetch. Se o link for inacessível (erro de rede, 404, timeout, paywall/login, ou bloqueio anti-bot de ATS — ver aviso acima) ou o WebFetch não retornar uma descrição de vaga reconhecível, **pare e informe claramente ao usuário** que não foi possível acessar o link, em vez de prosseguir com uma vaga vazia, incompleta ou inventada.
   - **Arquivo**: leia com Read (texto simples, `.md`, ou `.pdf` — a ferramenta já extrai texto de PDF). Se o arquivo não existir ou o conteúdo extraído não parecer uma descrição de vaga, **pare e informe claramente ao usuário** em vez de seguir adiante.

   Em qualquer um dos três casos, o texto obtido alimenta o restante do processo abaixo exatamente da mesma forma — nenhuma lógica de reescrita muda por causa da origem da vaga.

2. **Leia as fontes de verdade.**
   - Leia `C:\Users\edxlty\projects\tailor-resume\docs\EduardoSoldiCV.tex`, independente de qual seja o diretório de trabalho atual. Se esse caminho não existir mais, pare e avise o usuário em vez de adivinhar outro local (o projeto pode ter sido movido; este documento precisaria ser atualizado). Este arquivo é **somente leitura** — nunca escreva nele.
   - Se existir, leia também `C:\Users\edxlty\projects\tailor-resume\docs\InformacoesAdicionais.md` por inteiro. É opcional — pode não existir ainda (primeira vez que uma lacuna é persistida). Quando existir, seu conteúdo vale como fonte de verdade tão legítima quanto o currículo-base para fins da regra inegociável: um fato listado lá **não** é mais uma "lacuna" no passo 5, mesmo que não esteja no `.tex`.

3. **Extraia da vaga**: nome da empresa e o título do cargo. Serão usados no nome da pasta de saída. Normalize assim: minúsculas, sem acentos, remova qualquer caractere que não seja letra, número ou espaço (inclusive `&`, `/`, parênteses), depois troque espaços por hífen (ex: "Analista de T.I. (Sênior)" → `analista-de-ti-senior`).

4. **Identifique o que é editável e o que é fixo** no currículo-base:
   - **Editável** (pode reescrever texto e reordenar itens, usando só fatos já presentes nas fontes de verdade): `Objetivo`; os itens da lista em `Perfil e Competências`; os bullets dentro de cada `\role{...}` (Experiência Profissional); os bullets dentro de cada `\project{...}` (Projetos).
   - **Fixo** (conteúdo nunca muda — no máximo a ordem dos blocos pode mudar, nunca o texto): cabeçalho de contato; os argumentos de `\role{cargo}{empresa}{datas}`; `Formação`; `Cursos e Certificações`; `Idiomas`; e todo o preâmbulo do `.tex`, incluindo os metadados do `\hypersetup` (`pdftitle`, `pdfsubject`, `pdfkeywords`).
   - **Fixo com exceção registrada**: o nome em `\project{nome}` — ver a seção "Nome de projeto" abaixo.

   **Nunca reescreva `pdfsubject`/`pdfkeywords` para refletir a vaga.** É texto invisível para quem lê o currículo e visível para parsers de ATS — ou seja, exatamente o keyword stuffing proibido pela regra inegociável, ainda que os termos sejam verdadeiros. A única alteração permitida no preâmbulo é a troca do `babel`, no passo 7.

### Nome de projeto

O nome de um `\project{}` é um rótulo que o próprio Eduardo deu ao projeto (diferente de `\role{cargo}`, que é o título atribuído pelo empregador e por isso é sempre imutável). Por isso, ajustá-lo para o vocabulário da vaga é permitido — mas só sob estas regras:

- **Modo rápido (`tailor-resume`)**: use o nome exatamente como está no currículo-base. A única exceção é aplicar um alias **já registrado** em `InformacoesAdicionais.md`, quando a vaga usa aquele vocabulário. Nunca proponha um alias novo neste modo.
- **Modo completo (`tailor-resume-full`)**: pode propor um alias novo, desde que ele continue descrevendo fielmente o mesmo projeto usando termos que já são verdadeiros dele — nunca ampliando escopo (ex: "Integração de IA com Excel via VBA" → "Integração de IA Generativa com Excel via VBA" é válido, porque a OpenAI API é de fato IA generativa; já "→ Plataforma de Agentes de IA" não seria). Pergunte antes de aplicar, junto com as perguntas do passo 5, e registre no passo 12.
- **Três travas, sempre**: (i) todo alias é ancorado no nome como aparece em `EduardoSoldiCV.tex` — nunca alias de alias; (ii) o match com o registro é **literal**, string por string — qualquer variação não listada exige nova pergunta, mesmo que pareça equivalente; (iii) isso vale **só** para nomes de projeto, nunca para cargo, empresa, datas ou formação.

5. **Verifique lacunas e pergunte, se o limiar da skill mandar.** Compare os requisitos citados na vaga contra as duas fontes de verdade lidas no passo 2 (currículo-base + `InformacoesAdicionais.md`, se existir). Um requisito é uma "lacuna" quando não há cobertura real em nenhuma das duas — não conta como lacuna algo só fraseado diferente (ex: vaga pede "APIs" e o currículo já tem "APIs REST").

   O `SKILL.md` que te invocou define o **limiar**: só requisitos obrigatórios, ou todos (obrigatórios + desejáveis). Quando a vaga não distingue claramente obrigatório de desejável, trate o requisito ambíguo como **desejável** (mais conservador — evita interromper por algo que talvez nem fosse obrigatório).

   - Se não houver lacunas dentro do limiar, pule para o passo 6 — nenhuma pergunta, nenhuma mudança de comportamento.
   - Se houver, pergunte ao usuário **numa única leva**, via `AskUserQuestion`, uma pergunta por lacuna (até 4 por chamada da ferramenta — se houver mais de 4, faça chamadas adicionais em sequência). Cada pergunta deve deixar claro qual requisito da vaga está em jogo, e oferecer a chance de descrever a experiência real ou dizer que não tem. Isso é coleta de informação pontual, não uma etapa de aprovação do resultado final — é uma exceção deliberada e limitada à regra de "sem aprovação bloqueante".
   - Para cada resposta confirmando uma experiência real: anote o fato pra usar no passo 6 (como se já estivesse numa fonte de verdade) e marque para oferecer persistência no passo 12.
   - Para cada resposta negativa ("não tenho isso"): não invente nada; apenas marque para registrar a recusa no passo 12, e simplesmente omita esse requisito da reescrita, como o processo já fazia antes desta funcionalidade existir.

6. **Reescreva as seções editáveis** com foco na vaga:
   - Reordene os itens de `Perfil e Competências` colocando primeiro o que é mais relevante para a vaga.
   - Ajuste a redação do `Objetivo` e dos bullets de Experiência/Projetos para usar, quando genuinamente verdadeiro, termos e palavras-chave que aparecem na vaga — sem alterar o fato descrito, só a forma de descrevê-lo. Fatos confirmados no passo 5 podem ser incorporados aqui como qualquer outro fato das fontes de verdade.
   - Você pode omitir itens editáveis pouco relevantes à vaga, mas não pode adicionar itens novos além do que as fontes de verdade (incluindo o passo 5) sustentam. (Isso é só sobre relevância — o controle de contagem de páginas em si é automático e acontece no passo 10.)

7. **Traduza para inglês, se a vaga estiver em inglês.** Detecte o idioma predominante do texto obtido no passo 1. Se for português, pule este passo — nada muda. Se for inglês:
   - Traduza todo o conteúdo do currículo já reescrito no passo 6: os títulos das seções (`Objetivo` → `Objective`, `Perfil e Competências` → `Skills \& Profile`, `Experiência Profissional` → `Professional Experience`, `Projetos` → `Projects`, `Formação` → `Education`, `Cursos e Certificações` → `Courses \& Certifications`, `Idiomas` → `Languages`), o texto do Objetivo, os bullets de Perfil/Experiência/Projetos, os títulos de cargo e de formação (ex: "Suporte Técnico N1" → "IT Support Technician (Tier 1)", "Tecnólogo em Análise e Desenvolvimento de Sistemas" → "Associate Degree in Systems Analysis and Development"), as datas (ex: "Janeiro/2026 -- Atual" → "January 2026 -- Present"), e o item de idioma ("Inglês intermediário" → "Intermediate English").
   - **Nunca traduza nomes próprios**: nome da pessoa, nomes de empresas/instituições, nomes de cidade/estado.
   - Troque `\usepackage[brazil]{babel}` por `\usepackage[english]{babel}` no preâmbulo do `.tex`, para hifenização e tipografia corretas em inglês.
   - A tradução é reescrita **literal e fiel**, não uma nova oportunidade de reescrever por relevância — a regra inegociável continua valendo integralmente: nenhum fato, habilidade ou responsabilidade novo, nada que não exista (já traduzido) nas fontes de verdade.

8. **Defina a pasta da aplicação**: `aplicacoes/<empresa>-<cargo>-<AAAA-MM>/` (mês/ano atual), a partir da raiz do projeto do passo 2. Se essa pasta já existir (segunda aplicação para a mesma empresa/cargo no mesmo mês), acrescente um sufixo numérico: `-2`, `-3`, etc., até chegar num nome que não existe ainda. Nunca sobrescreva uma aplicação anterior.

   Escreva o novo `.tex` em `curriculo.tex` dentro dessa pasta.

9. **Compile o PDF**: rode `pdflatex -interaction=nonstopmode -output-directory=<pasta-da-aplicação> curriculo.tex` de dentro da pasta da aplicação. O executável costuma estar em `pdflatex` (se o PATH já tiver sido atualizado) ou em `C:\Users\edxlty\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe` (instalação padrão do MiKTeX nesta máquina) — tente o primeiro, caia para o segundo se não for encontrado.

   Rode até 2 vezes se necessário para resolver referências. Se a compilação falhar, leia o `.log` gerado, corrija o `.tex` e recompile — no máximo **3 tentativas de correção** no total. Se ainda assim não compilar, pare, explique o erro ao usuário e não entregue um PDF quebrado.

10. **Aplique a regra de 1 página.** Depois de compilar com sucesso, confira a contagem de páginas que o `pdflatex` imprime na forma `(N page, ...)` / `(N pages, ...)`, no stdout ou no `.log`. Extraia com um padrão como `grep -oE "\([0-9]+ pages?," curriculo.log` — não procure pela linha inteira `Output written on ...`, porque quando o caminho da pasta é longo essa linha pode quebrar no meio (o parêntese com a contagem de páginas, porém, sempre fica intacto).

    - Se **N = 1**, siga direto para a limpeza de arquivos auxiliares, abaixo.
    - Se **N > 1**, corte o item editável menos relevante à vaga que ainda está no `.tex` — um bullet de `Perfil e Competências`, de Experiência ou de Projetos. **Nunca** corte conteúdo de seção fixa, e nunca remova um `\role{...}` ou `\project{...}` inteiro (a vaga/empresa/data em si é fixa; só os bullets dentro dele são editáveis). Recompile e confira a contagem de novo. Repita até caber.
    - Ordem de prioridade do corte (do primeiro a cortar para o último): (a) os últimos itens de `Perfil e Competências` — já ficaram no fim da lista por serem os menos relevantes à vaga, conforme o passo 6; (b) bullets de experiências mais antigas ou menos relacionadas à vaga; (c) bullets de Projetos menos alinhados à vaga.
    - **Limite de cortes razoáveis** — pare de cortar automaticamente, mesmo que ainda esteja em mais de 1 página, assim que qualquer uma destas condições for atingida: (i) já foram feitas 5 rodadas de corte + recompilação; (ii) o próximo corte deixaria `Perfil e Competências` com menos de 4 itens; (iii) o próximo corte deixaria algum `\role` ou `\project` sem nenhum bullet. Ao atingir o limite sem caber em 1 página, **pare, avise o usuário explicitamente** (quantas páginas o PDF ficou e o que já foi cortado) e entregue os arquivos do jeito que estão — não continue cortando além do razoável.
    - Um currículo que já compila em 1 página **não sofre nenhum corte**.

    Independentemente do resultado, depois de a contagem de páginas estar resolvida (coube em 1, ou os cortes razoáveis se esgotaram), apague os arquivos auxiliares que o `pdflatex` gerou na pasta da aplicação (`curriculo.aux`, `curriculo.log`, `curriculo.out`); só `curriculo.tex` e `curriculo.pdf` devem sobrar dessa etapa.

11. **Salve a vaga original** em `vaga.md`, dentro da mesma pasta da aplicação — **sempre no idioma original da vaga, nunca traduzido**, mesmo quando o passo 7 traduziu o currículo para inglês:
    - Se a vaga veio como **texto colado**, salve o texto exatamente como o usuário colou.
    - Se veio por **link**, salve o texto extraído pelo WebFetch, com a URL de origem na primeira linha (ex: `Fonte: https://...`).
    - Se veio por **arquivo**, salve o texto extraído, com o caminho ou nome do arquivo original na primeira linha (ex: `Fonte: vaga-tech4ai.pdf`).

12. **Persista as respostas do passo 5, se houver.** Isso é independente da pasta da aplicação — é sobre atualizar a base de conhecimento pra runs futuros.
    - Se nenhuma pergunta foi feita no passo 5, pule este passo.
    - Se houve confirmações e/ou recusas, **pergunte uma vez** (uma única pergunta de sim/não, pode agrupar todas as entradas pendentes) se o usuário quer persistir em `C:\Users\edxlty\projects\tailor-resume\docs\InformacoesAdicionais.md`. Se sim: crie o arquivo se não existir (com um título e uma frase curta de contexto), e acrescente uma seção `## AAAA-MM-DD` (data de hoje; reaproveite uma seção já existente da mesma data se houver) com uma linha por entrada:
      - Confirmação: `- Confirmado: <habilidade/experiência> — <contexto real, breve, como o usuário descreveu>`
      - Recusa: `- Não tenho: <habilidade/experiência> (perguntado ao processar vaga de <empresa>)`
    - **Alias de projeto aprovado** (só no modo completo): não vai nas seções por data, porque não é histórico e sim tabela de consulta. Registre numa seção própria e fixa `## Aliases de projeto aprovados`, logo depois da introdução do arquivo, no formato `- "<nome no EduardoSoldiCV.tex>" → "<alias aprovado>"`. Antes de propor qualquer alias no passo 6, consulte essa seção: se a troca já estiver lá literalmente, aplique sem perguntar de novo.
    - Se o usuário recusar a persistência, não escreva nada — a resposta já foi usada na aplicação atual (passo 6) e é isso que vale para esta execução.

13. **Entregue um resumo curto** (2 a 4 linhas) do que foi priorizado/reescrito — por exemplo, quais competências foram colocadas em destaque e por quê. Se a vaga estava em inglês, mencione que o currículo foi traduzido. Se alguma pergunta de lacuna foi feita no passo 5, mencione o que foi perguntado e se foi persistido no passo 12. Se algum corte automático do passo 10 foi aplicado, mencione o que foi cortado. Se o limite de cortes foi atingido sem caber em 1 página, esse é o aviso explícito ao usuário — não é opcional. Não peça aprovação antes de finalizar; os arquivos já estão salvos quando você reporta o resumo.
