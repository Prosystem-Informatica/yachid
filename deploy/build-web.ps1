# Script PowerShell para build do Flutter Web
# Execute este script antes de fazer o deploy

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Build Flutter Web - Yachid" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Verifica se Flutter está instalado
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterPath) {
    Write-Host "ERRO: Flutter não encontrado no PATH!" -ForegroundColor Red
    Write-Host "Por favor, instale o Flutter ou adicione-o ao PATH." -ForegroundColor Yellow
    exit 1
}

Write-Host "Flutter encontrado: $($flutterPath.Source)" -ForegroundColor Green
Write-Host ""

# Verifica se estamos no diretório correto
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "ERRO: pubspec.yaml não encontrado!" -ForegroundColor Red
    Write-Host "Execute este script a partir do diretório raiz do projeto." -ForegroundColor Yellow
    exit 1
}

# Verifica se existe arquivo .env
if (-not (Test-Path ".env")) {
    Write-Host "AVISO: Arquivo .env não encontrado!" -ForegroundColor Yellow
    Write-Host "Certifique-se de criar o arquivo .env antes do build." -ForegroundColor Yellow
    Write-Host ""
}

# Limpa builds anteriores
Write-Host "Limpando builds anteriores..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Obtém dependências
Write-Host "Obtendo dependências..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO ao obter dependências!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Build para web em modo release
Write-Host "Fazendo build para web (modo release)..." -ForegroundColor Yellow
flutter build web --release --base-href /
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO no build!" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Build concluído com sucesso!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Arquivos gerados em: build/web/" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Copie o conteúdo de build/web/ para C:/nginx/html/yachid/" -ForegroundColor White
Write-Host "2. Verifique a configuração do NGINX" -ForegroundColor White
Write-Host "3. Reinicie o serviço NGINX" -ForegroundColor White
Write-Host ""
