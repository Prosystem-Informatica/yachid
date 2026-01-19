# Script PowerShell para deploy automático na VM Azure Windows Server
# Este script faz o build e prepara os arquivos para deploy

param(
    [string]$NginxPath = "C:\nginx",
    [string]$AppPath = "C:\nginx\html\yachid",
    [switch]$SkipBuild = $false
)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Deploy Yachid para Azure VM" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Verifica se estamos no diretório correto
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "ERRO: pubspec.yaml não encontrado!" -ForegroundColor Red
    Write-Host "Execute este script a partir do diretório raiz do projeto." -ForegroundColor Yellow
    exit 1
}

# Build do Flutter Web
if (-not $SkipBuild) {
    Write-Host "Executando build do Flutter Web..." -ForegroundColor Yellow
    & "$PSScriptRoot\build-web.ps1"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO no build!" -ForegroundColor Red
        exit 1
    }
    Write-Host ""
}

# Cria diretório de destino se não existir
Write-Host "Criando diretório de destino..." -ForegroundColor Yellow
if (-not (Test-Path $AppPath)) {
    New-Item -ItemType Directory -Path $AppPath -Force | Out-Null
    Write-Host "Diretório criado: $AppPath" -ForegroundColor Green
} else {
    Write-Host "Diretório já existe: $AppPath" -ForegroundColor Green
}
Write-Host ""

# Copia arquivos do build para o diretório do NGINX
Write-Host "Copiando arquivos do build..." -ForegroundColor Yellow
$buildPath = "build\web"
if (-not (Test-Path $buildPath)) {
    Write-Host "ERRO: Diretório build\web não encontrado!" -ForegroundColor Red
    Write-Host "Execute o build primeiro ou remova a flag -SkipBuild" -ForegroundColor Yellow
    exit 1
}

# Remove conteúdo antigo (exceto se for primeira vez)
Write-Host "Limpando diretório de destino..." -ForegroundColor Yellow
Get-ChildItem -Path $AppPath -Exclude ".gitkeep" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Copia novos arquivos
Write-Host "Copiando novos arquivos..." -ForegroundColor Yellow
Copy-Item -Path "$buildPath\*" -Destination $AppPath -Recurse -Force
Write-Host "Arquivos copiados com sucesso!" -ForegroundColor Green
Write-Host ""

# Verifica se NGINX está rodando
Write-Host "Verificando status do NGINX..." -ForegroundColor Yellow
$nginxService = Get-Service -Name "nginx" -ErrorAction SilentlyContinue
if ($nginxService) {
    if ($nginxService.Status -eq "Running") {
        Write-Host "NGINX está rodando. Reiniciando serviço..." -ForegroundColor Yellow
        Restart-Service -Name "nginx" -Force
        Write-Host "NGINX reiniciado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "NGINX não está rodando. Iniciando serviço..." -ForegroundColor Yellow
        Start-Service -Name "nginx"
        Write-Host "NGINX iniciado com sucesso!" -ForegroundColor Green
    }
} else {
    Write-Host "AVISO: Serviço NGINX não encontrado!" -ForegroundColor Yellow
    Write-Host "Certifique-se de que o NGINX está instalado e configurado." -ForegroundColor Yellow
}
Write-Host ""

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Deploy concluído com sucesso!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Aplicação disponível em: http://localhost" -ForegroundColor Cyan
Write-Host ""
