# Script PowerShell para instalação do NGINX no Windows Server
# Este script baixa e configura o NGINX na VM Azure

param(
    [string]$InstallPath = "C:\nginx",
    [string]$NginxVersion = "1.24.0"
)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Instalação NGINX para Windows" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Verifica se está rodando como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERRO: Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Clique com o botão direito e selecione 'Executar como administrador'" -ForegroundColor Yellow
    exit 1
}

# Cria diretório de instalação
if (-not (Test-Path $InstallPath)) {
    Write-Host "Criando diretório de instalação: $InstallPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
}

# Verifica se NGINX já está instalado
$nginxExe = Join-Path $InstallPath "nginx.exe"
if (Test-Path $nginxExe) {
    Write-Host "NGINX já está instalado em $InstallPath" -ForegroundColor Yellow
    $response = Read-Host "Deseja reinstalar? (S/N)"
    if ($response -ne "S" -and $response -ne "s") {
        Write-Host "Instalação cancelada." -ForegroundColor Yellow
        exit 0
    }
    Write-Host "Parando serviço NGINX se estiver rodando..." -ForegroundColor Yellow
    Stop-Process -Name "nginx" -Force -ErrorAction SilentlyContinue
}

# Download do NGINX
Write-Host "Baixando NGINX $NginxVersion..." -ForegroundColor Yellow
$downloadUrl = "http://nginx.org/download/nginx-$NginxVersion.zip"
$zipPath = Join-Path $env:TEMP "nginx-$NginxVersion.zip"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
    Write-Host "Download concluído!" -ForegroundColor Green
} catch {
    Write-Host "ERRO ao baixar NGINX: $_" -ForegroundColor Red
    exit 1
}

# Extrai o NGINX
Write-Host "Extraindo NGINX..." -ForegroundColor Yellow
$extractPath = Join-Path $env:TEMP "nginx-extract"
if (Test-Path $extractPath) {
    Remove-Item -Path $extractPath -Recurse -Force
}
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Copia arquivos para o diretório de instalação
Write-Host "Copiando arquivos..." -ForegroundColor Yellow
$nginxExtractedPath = Join-Path $extractPath "nginx-$NginxVersion"
Copy-Item -Path "$nginxExtractedPath\*" -Destination $InstallPath -Recurse -Force

# Limpa arquivos temporários
Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "NGINX instalado com sucesso em $InstallPath" -ForegroundColor Green
Write-Host ""

# Instala NGINX como serviço Windows (requer nssm)
Write-Host "Deseja instalar o NGINX como serviço Windows?" -ForegroundColor Yellow
Write-Host "Para isso, você precisará do NSSM (Non-Sucking Service Manager)" -ForegroundColor Yellow
$response = Read-Host "Instalar como serviço? (S/N)"

if ($response -eq "S" -or $response -eq "s") {
    # Verifica se NSSM está disponível
    $nssmPath = Get-Command nssm -ErrorAction SilentlyContinue
    if (-not $nssmPath) {
        Write-Host "NSSM não encontrado. Instalando NSSM..." -ForegroundColor Yellow
        $nssmUrl = "https://nssm.cc/release/nssm-2.24.zip"
        $nssmZip = Join-Path $env:TEMP "nssm.zip"
        
        try {
            Invoke-WebRequest -Uri $nssmUrl -OutFile $nssmZip -UseBasicParsing
            $nssmExtract = Join-Path $env:TEMP "nssm-extract"
            Expand-Archive -Path $nssmZip -DestinationPath $nssmExtract -Force
            
            $nssmExe = Get-ChildItem -Path $nssmExtract -Filter "nssm.exe" -Recurse | Select-Object -First 1
            if ($nssmExe) {
                $nssmPath = $nssmExe.FullName
            }
        } catch {
            Write-Host "ERRO ao baixar NSSM: $_" -ForegroundColor Red
            Write-Host "Você pode instalar manualmente de: https://nssm.cc/download" -ForegroundColor Yellow
        }
    }
    
    if ($nssmPath) {
        Write-Host "Instalando NGINX como serviço..." -ForegroundColor Yellow
        & $nssmPath install nginx "$nginxExe"
        & $nssmPath set nginx AppDirectory $InstallPath
        & $nssmPath set nginx AppStdout (Join-Path $InstallPath "logs\service.log")
        & $nssmPath set nginx AppStderr (Join-Path $InstallPath "logs\service-error.log")
        
        Write-Host "Serviço instalado! Iniciando..." -ForegroundColor Green
        Start-Service -Name "nginx"
        Write-Host "NGINX iniciado como serviço!" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "Para iniciar o NGINX manualmente, execute:" -ForegroundColor Yellow
    Write-Host "  cd $InstallPath" -ForegroundColor White
    Write-Host "  .\nginx.exe" -ForegroundColor White
    Write-Host ""
    Write-Host "Para parar:" -ForegroundColor Yellow
    Write-Host "  .\nginx.exe -s stop" -ForegroundColor White
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Instalação concluída!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Copie o arquivo deploy/nginx.conf para $InstallPath\conf\nginx.conf" -ForegroundColor White
Write-Host "2. Ajuste as configurações conforme necessário" -ForegroundColor White
Write-Host "3. Crie o diretório C:\nginx\html\yachid" -ForegroundColor White
Write-Host "4. Execute o deploy dos arquivos Flutter Web" -ForegroundColor White
Write-Host ""
