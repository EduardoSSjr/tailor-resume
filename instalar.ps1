<#
Instalador Windows do tailor-resume: pergunta os dados do config.json,
detecta pdflatex no PATH, cria as junctions globais das duas skills.
Pode ser rodado de novo sobre uma instalação existente sem duplicar
nada nem corromper o config.json.
#>

$ErrorActionPreference = 'Stop'

$raizDoProjeto = $PSScriptRoot
$configPath = Join-Path $raizDoProjeto 'config.json'
$curriculoDir = Join-Path $raizDoProjeto 'meu-curriculo'

Write-Host '== Instalador do tailor-resume ==' -ForegroundColor Cyan
Write-Host "Raiz do projeto: $raizDoProjeto"
Write-Host ''

$existente = $null
if (Test-Path $configPath) {
    try {
        $existente = Get-Content $configPath -Raw | ConvertFrom-Json
        Write-Host 'config.json existente encontrado -- valores atuais viram sugestão, aperte Enter pra manter.' -ForegroundColor Yellow
    } catch {
        Write-Warning "config.json existente não pôde ser lido (JSON inválido) -- ignorando e pedindo os valores de novo."
        $existente = $null
    }
}

# --- Nome do arquivo de currículo ---
$defaultArquivo = if ($existente -and $existente.arquivoCurriculo) { $existente.arquivoCurriculo } else { $null }
$prompt = 'Nome do arquivo do seu currículo dentro de meu-curriculo\'
if ($defaultArquivo) { $prompt += " [$defaultArquivo]" }
$resposta = Read-Host $prompt
$arquivoCurriculo = if ([string]::IsNullOrWhiteSpace($resposta)) { $defaultArquivo } else { $resposta }
if ([string]::IsNullOrWhiteSpace($arquivoCurriculo)) {
    throw 'Nome do arquivo de currículo é obrigatório.'
}

$caminhoCurriculo = Join-Path $curriculoDir $arquivoCurriculo
if (-not (Test-Path $caminhoCurriculo)) {
    Write-Warning "Não encontrei '$arquivoCurriculo' em meu-curriculo\ ainda -- coloque o arquivo lá antes de usar a skill. Continuando a instalação."
}

# --- Máximo de páginas ---
$defaultPaginas = if ($existente -and $existente.maximoDePaginas) { $existente.maximoDePaginas } else { 1 }
$resposta = Read-Host "Máximo de páginas do currículo final [$defaultPaginas]"
$maximoDePaginas = if ([string]::IsNullOrWhiteSpace($resposta)) { [int]$defaultPaginas } else { [int]$resposta }

# --- pdflatex: PATH primeiro, pergunta só se não achar ---
$caminhoPdflatex = ''
$encontrado = Get-Command pdflatex -ErrorAction SilentlyContinue
if ($encontrado) {
    Write-Host "pdflatex encontrado no PATH ($($encontrado.Source)) -- não vou perguntar o caminho." -ForegroundColor Green
} else {
    $defaultCaminho = if ($existente -and $existente.caminhoPdflatex) { $existente.caminhoPdflatex } else { $null }
    $prompt = 'pdflatex não encontrado no PATH. Caminho completo do executável (ex: C:\Program Files\MiKTeX\miktex\bin\x64\pdflatex.exe)'
    if ($defaultCaminho) { $prompt += " [$defaultCaminho]" }
    $resposta = Read-Host $prompt
    $caminhoPdflatex = if ([string]::IsNullOrWhiteSpace($resposta)) { $defaultCaminho } else { $resposta }
}

# --- Escreve config.json ---
$config = [ordered]@{
    raizDoProjeto    = $raizDoProjeto
    arquivoCurriculo = $arquivoCurriculo
    maximoDePaginas  = $maximoDePaginas
    caminhoPdflatex  = $caminhoPdflatex
}
($config | ConvertTo-Json) | Set-Content -Path $configPath -Encoding utf8
Write-Host ''
Write-Host "config.json escrito em $configPath" -ForegroundColor Green

# --- Junctions globais das duas skills ---
function Install-SkillJunction {
    param([string]$Nome)

    $origem = Join-Path $raizDoProjeto ".claude\skills\$Nome"
    $skillsGlobais = Join-Path $env:USERPROFILE '.claude\skills'
    $destino = Join-Path $skillsGlobais $Nome

    if (-not (Test-Path $origem)) {
        throw "Pasta da skill não encontrada: $origem"
    }
    New-Item -ItemType Directory -Force -Path $skillsGlobais | Out-Null

    if (Test-Path $destino) {
        $item = Get-Item $destino -Force
        $ehJunction = $item.LinkType -eq 'Junction'
        $apontaCerto = $ehJunction -and ($item.Target | Where-Object { $_ -ieq $origem })

        if ($apontaCerto) {
            Write-Host "Junction de '$Nome' já existe e aponta pro lugar certo -- nada a fazer." -ForegroundColor Yellow
            return
        }
        if ($ehJunction) {
            Write-Host "Junction de '$Nome' existe mas aponta pra outro lugar -- recriando." -ForegroundColor Yellow
            $item.Delete()
        } else {
            throw "'$destino' já existe e não é uma junction (é uma pasta ou arquivo real). Remova manualmente antes de rodar o instalador de novo."
        }
    }

    cmd /c mklink /J "$destino" "$origem" | Out-Null
    Write-Host "Junction criada: $destino -> $origem" -ForegroundColor Green
}

Install-SkillJunction -Nome 'tailor-resume'
Install-SkillJunction -Nome 'tailor-resume-full'

Write-Host ''
Write-Host 'Instalação concluída. Abra o Claude Code em qualquer pasta e cole uma vaga para testar.' -ForegroundColor Cyan
