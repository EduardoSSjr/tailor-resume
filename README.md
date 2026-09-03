# tailor-resume

Skill do [Claude Code](https://claude.com/claude-code) que adapta um currículo LaTeX para cada vaga — **sem nunca inventar experiência**.

Você cola a descrição de uma vaga no chat. A skill lê seu currículo-base, reordena e reescreve só o que é editável para destacar o que aquela vaga pede, compila o PDF, garante que cabe em uma página, e arquiva tudo junto com o texto original da vaga. Fatos que não estão no seu currículo simplesmente não aparecem no resultado.

## O problema

Adaptar currículo para cada vaga é repetitivo e fácil de fazer mal: ou você manda o mesmo PDF para todo mundo, ou reescreve à mão e acaba esquecendo de destacar o que importava naquela vaga. Pedir isso para uma IA genérica resolve a repetição e cria um problema pior — ela **inventa**. Some uma linha de Python que você nunca escreveu, aparece uma responsabilidade que nunca foi sua, e você descobre na entrevista.

Este projeto existe para automatizar a parte chata sem abrir essa porta.

## A regra inegociável

O núcleo do projeto não é a reescrita, é a restrição:

> Nunca invente experiência, responsabilidade, habilidade ou fato que não esteja presente nas fontes de verdade. Só é permitido reescrever a **ênfase** e a **ordem** do que já existe.

Na prática isso vira um mapa explícito do que pode e não pode mudar:

| Editável (reescreve e reordena) | Fixo (no máximo reordena) |
| --- | --- |
| Objetivo | Cabeçalho de contato |
| Itens de Perfil e Competências | Cargo, empresa e datas |
| Bullets de cada experiência | Formação |
| Bullets de cada projeto | Cursos e Certificações, Idiomas |

Também é proibido **keyword stuffing** — texto oculto, cor igual ao fundo, ou blocos de palavras-chave soltos para enganar sistemas de triagem (ATS). Os metadados do PDF (`pdfkeywords`, `pdfsubject`) são explicitamente intocáveis pelo mesmo motivo: são invisíveis para quem lê e visíveis para o parser. Todo alinhamento com o vocabulário da vaga precisa ser reescrita natural e visível de conteúdo verdadeiro.

Quando a vaga pede algo que **não** está no currículo, a skill não inventa e não ignora em silêncio: ela **pergunta**. Se você confirmar uma experiência real, ela é incorporada e fica registrada para as próximas vagas — sem virar pergunta de novo.

## O que a skill faz

1. Aceita a vaga por **texto colado**, **link** ou **arquivo** (txt, markdown ou PDF)
2. Lê o currículo-base e a base de conhecimento acumulada
3. Detecta lacunas entre os requisitos da vaga e o que você tem, e pergunta sobre elas
4. Reescreve as seções editáveis priorizando o que a vaga pede
5. **Traduz para inglês** automaticamente, se a vaga estiver em inglês
6. Compila o PDF e aplica a **regra de 1 página**, cortando os itens menos relevantes e recompilando até caber
7. Arquiva `curriculo.tex`, `curriculo.pdf` e `vaga.md` numa pasta por aplicação
8. Explica em 2–4 linhas o que priorizou e por quê

O currículo-base nunca é sobrescrito — é somente leitura para a skill.

### Dois modos

| Skill | Quando dispara | Sobre o que pergunta |
| --- | --- | --- |
| `tailor-resume` | Automaticamente, ao reconhecer uma vaga | Só lacunas em requisitos **obrigatórios** |
| `tailor-resume-full` | Só por pedido explícito | **Toda** lacuna, obrigatória ou desejável |

As duas compartilham o mesmo motor ([`PROCESS.md`](.claude/skills/tailor-resume/PROCESS.md), 13 passos). A única diferença é o limiar de perguntas — o modo rápido existe para não colocar fricção no caminho padrão.

## Como foi construído

O projeto inteiro foi desenvolvido com **spec-driven development**, usando as [skills de engenharia do Matt Pocock](https://github.com/mattpocock/skills). O histórico está todo aberto nas issues:

- **[#1](../../issues/1)** — a spec: 23 user stories, decisões de implementação e de teste
- **[#2](../../issues/2)–[#8](../../issues/8)** — os tickets, cada um uma fatia vertical demonstrável, com grafo de dependência entre eles (`#7` bloqueado por `#2` e `#3`, e assim por diante)

O fluxo foi: entrevista de requisitos (`grill`) → spec formal → tickets → implementação → code review em dois eixos (aderência a padrões e aderência à spec), com os achados corrigidos antes de fechar cada ticket.

Uma das features nasceu justamente de um teste real: ao processar uma vaga que exigia Python, a skill não encontrou Python no currículo — e a decisão de "perguntar em vez de inventar ou ignorar" virou a issue [#8](../../issues/8).

## Instalação

### Pré-requisitos

- [Claude Code](https://claude.com/claude-code) instalado e autenticado
- Uma distribuição LaTeX com `pdflatex` no PATH ([MiKTeX](https://miktex.org/) no Windows, [TeX Live](https://tug.org/texlive/) no Linux/macOS)
- Um currículo em LaTeX

### Passos

```bash
git clone https://github.com/EduardoSSjr/tailor-resume.git
cd tailor-resume
```

Coloque seu currículo em `docs/` (a pasta é ignorada pelo git — nada de dado pessoal é versionado).

Instale a skill globalmente, para que funcione em qualquer pasta que você abrir no Claude Code. No Windows, via junction (não exige privilégio de administrador, ao contrário do symlink):

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills" | Out-Null
cmd /c mklink /J "$env:USERPROFILE\.claude\skills\tailor-resume" "<caminho-do-repo>\.claude\skills\tailor-resume"
cmd /c mklink /J "$env:USERPROFILE\.claude\skills\tailor-resume-full" "<caminho-do-repo>\.claude\skills\tailor-resume-full"
```

A junction mantém o repositório como fonte única de verdade: editar o arquivo aqui já vale globalmente, sem reinstalar nem sincronizar cópias.

### Uso

Abra o Claude Code em qualquer pasta e cole a descrição de uma vaga. A skill dispara sozinha. Para forçar, use `/tailor-resume` — ou `/tailor-resume-full` para o modo que pergunta sobre toda lacuna.

## Estado atual e limitações conhecidas

Sendo honesto sobre o que ainda não funciona para todo mundo:

- **Caminhos absolutos.** O `PROCESS.md` e os `SKILL.md` ainda apontam para caminhos de uma máquina específica. Clonar hoje exige editá-los à mão. Tornar isso portátil é o próximo trabalho planejado.
- **Só currículo em LaTeX**, e com as macros específicas deste projeto (`\role{}`, `\project{}`, `\sectiontitle{}`). Aceitar currículo em PDF é a evolução seguinte, e é o que destrava o uso por quem não escreve LaTeX.
- **Windows.** A instalação documentada usa junction NTFS; em Unix o equivalente é `ln -s`, ainda não documentado passo a passo.
- **Links de vaga em plataformas de ATS** (Gupy, InHire, LinkedIn e afins) costumam bloquear requisição automatizada e retornar 403. Não é bug da skill, é bloqueio anti-bot — nesse caso, cole o texto ou salve a página como PDF e aponte o arquivo.
- **A regra inegociável é hoje uma instrução, não uma verificação.** Não existe ainda uma checagem automática de que nenhum fato foi inventado — é a issue [#5](../../issues/5), ainda aberta.

## Estrutura

```
.claude/skills/
  tailor-resume/
    SKILL.md        # modo rápido: gatilho, limiar de lacunas
    PROCESS.md      # o motor: 13 passos, compartilhado pelos dois modos
  tailor-resume-full/
    SKILL.md        # modo completo: mesmo processo, limiar mais amplo
docs/               # currículo-base e conhecimento acumulado (git-ignored)
aplicacoes/         # uma pasta por vaga: .tex + .pdf + vaga.md (git-ignored)
```
