# Guia de Deploy - Yachid na Azure VM (Windows Server)

Este guia descreve como fazer o deploy da aplicação Flutter Web Yachid em uma VM Azure com Windows Server, utilizando NGINX como servidor web e fazendo proxy reverso para o backend NestJS.

## Pré-requisitos

- VM Azure com Windows Server configurada
- Backend NestJS rodando (geralmente na porta 3000)
- PostgreSQL configurado e acessível
- PowerShell com permissões de administrador
- Flutter SDK instalado (para build local ou na VM)

## Estrutura do Deploy

```
VM Azure (Windows Server)
├── NGINX (Porta 80) - Servidor Web
│   ├── Serve Flutter Web App (C:\nginx\html\yachid)
│   └── Proxy Reverso para NestJS (/api/* → localhost:3000)
└── NestJS (Porta 3000) - Backend API
    └── PostgreSQL Database
```

## Passo 1: Instalar NGINX no Windows Server

### Opção 1: Script Automático (Recomendado)

1. Copie o arquivo `deploy/install-nginx-windows.ps1` para a VM
2. Abra PowerShell como Administrador
3. Execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install-nginx-windows.ps1
```

### Opção 2: Instalação Manual

1. Baixe o NGINX para Windows: http://nginx.org/en/download.html
2. Extraia para `C:\nginx`
3. Configure o serviço Windows usando NSSM (opcional): https://nssm.cc/download

## Passo 2: Configurar NGINX

1. Copie o arquivo `deploy/nginx.conf` para `C:\nginx\conf\nginx.conf`
2. Ajuste as seguintes configurações no arquivo:

```nginx
server_name _;  # Substitua pelo seu domínio ou IP da VM

# Se o NestJS estiver em outra porta, ajuste aqui:
proxy_pass http://localhost:3000/;
```

3. Crie o diretório para a aplicação:
```powershell
New-Item -ItemType Directory -Path "C:\nginx\html\yachid" -Force
```

4. Crie os diretórios de log (se não existirem):
```powershell
New-Item -ItemType Directory -Path "C:\nginx\logs" -Force
```

## Passo 3: Configurar Variáveis de Ambiente

1. Na raiz do projeto Flutter, crie o arquivo `.env` baseado em `deploy/env.example.txt`:
```bash
BASE_URL=seudominio.com  # Ou o IP da VM (sem http:// ou https://)
```

**IMPORTANTE:** 
- O código Flutter usa `Uri.https()`, então sempre usará HTTPS
- O valor de `BASE_URL` deve ser apenas o domínio ou IP (sem protocolo)
- Exemplo: `BASE_URL=api.meudominio.com` ou `BASE_URL=192.168.1.100`
- Certifique-se de que o NGINX está configurado com HTTPS (veja Passo 6)

## Passo 4: Build do Flutter Web

### No seu ambiente local (recomendado):

1. Execute o script de build:
```powershell
.\deploy\build-web.ps1
```

2. Isso gerará os arquivos em `build/web/`

### Ou na VM (se tiver Flutter instalado):

1. Clone/transfira o código para a VM
2. Execute o mesmo script de build

## Passo 5: Deploy dos Arquivos

### Opção 1: Script Automático

Na VM, execute:
```powershell
.\deploy\deploy-to-azure.ps1
```

Este script:
- Faz o build (a menos que use `-SkipBuild`)
- Copia os arquivos para `C:\nginx\html\yachid`
- Reinicia o serviço NGINX

### Opção 2: Deploy Manual

1. Copie todo o conteúdo de `build/web/` para `C:\nginx\html\yachid\`

2. Reinicie o NGINX:
```powershell
# Se instalado como serviço:
Restart-Service -Name "nginx"

# Ou manualmente:
cd C:\nginx
.\nginx.exe -s reload
```

## Passo 6: Configurar HTTPS (Obrigatório)

Veja a seção "Configuração de HTTPS (OBRIGATÓRIO)" abaixo.

## Passo 7: Verificar e Testar

1. Abra o navegador e acesse: `https://IP-DA-VM` ou `https://seudominio.com`
   - Se usar HTTP, será redirecionado automaticamente para HTTPS (se configurado)

2. Verifique se a aplicação carrega corretamente

3. Teste as chamadas de API:
   - Abra o DevTools (F12) → Network
   - Verifique se as requisições para `/api/*` estão sendo redirecionadas corretamente
   - Verifique se as requisições estão usando HTTPS

4. Verifique os logs do NGINX:
```powershell
Get-Content C:\nginx\logs\yachid_access.log -Tail 20
Get-Content C:\nginx\logs\yachid_error.log -Tail 20
```

## Configuração de Firewall (Azure)

1. No Portal Azure, vá para sua VM → Networking
2. Adicione regra de Inbound Port:
   - **Port: 80** (HTTP - redireciona para HTTPS)
   - **Port: 443** (HTTPS - obrigatório)
   - Port: 3000 (apenas se precisar acesso direto ao backend, não recomendado para produção)

## Configuração de HTTPS (OBRIGATÓRIO)

**IMPORTANTE:** O código Flutter usa `Uri.https()` para todas as chamadas de API, então você DEVE configurar HTTPS no NGINX, mesmo que o backend NestJS esteja rodando em HTTP internamente.

Para adicionar HTTPS:

1. Obtenha certificado SSL:
   - **Let's Encrypt** (gratuito, recomendado): Use certbot ou outro cliente ACME
   - **Azure App Service Certificate** (se disponível)
   - **Certificado auto-assinado** (apenas para testes)

2. Copie os certificados para `C:\nginx\conf\`:
   - `cert.pem` (certificado)
   - `key.pem` (chave privada)

3. Use o arquivo `nginx-https.conf` ao invés de `nginx.conf`:
```powershell
Copy-Item deploy\nginx-https.conf C:\nginx\conf\nginx.conf -Force
```

4. Ajuste os caminhos dos certificados no arquivo se necessário

5. Reinicie o NGINX:
```powershell
Restart-Service -Name "nginx"
```

**Nota sobre certificados auto-assinados:** Se usar certificado auto-assinado, os navegadores mostrarão avisos de segurança. Para produção, use certificados válidos.

## Estrutura de Diretórios Final

```
C:\nginx\
├── conf\
│   └── nginx.conf
├── html\
│   └── yachid\          # Aplicação Flutter Web
│       ├── index.html
│       ├── main.dart.js
│       └── ...
├── logs\
│   ├── yachid_access.log
│   ├── yachid_error.log
│   └── service.log
└── nginx.exe
```

## Troubleshooting

### NGINX não inicia
- Verifique se a porta 80 está livre: `netstat -ano | findstr :80`
- Verifique a sintaxe: `C:\nginx\nginx.exe -t`
- Verifique os logs: `C:\nginx\logs\error.log`

### Aplicação não carrega
- Verifique se os arquivos estão em `C:\nginx\html\yachid\`
- Verifique as permissões do diretório
- Verifique o console do navegador (F12) para erros

### API não funciona
- Verifique se o NestJS está rodando: `netstat -ano | findstr :3000`
- Verifique se o proxy reverso está configurado corretamente no `nginx.conf`
- Teste o backend diretamente: `http://localhost:3000/api/health`

### Problemas de CORS
- Configure CORS no NestJS para aceitar requisições do domínio do frontend
- Verifique os headers no NGINX (`proxy_set_header`)

## Atualização da Aplicação

Para atualizar a aplicação:

1. Faça as alterações no código
2. Execute `.\deploy\build-web.ps1` novamente
3. Execute `.\deploy\deploy-to-azure.ps1` (ou copie manualmente)
4. O NGINX será reiniciado automaticamente

## Comandos Úteis

```powershell
# Iniciar NGINX
Start-Service -Name "nginx"
# ou
cd C:\nginx; .\nginx.exe

# Parar NGINX
Stop-Service -Name "nginx"
# ou
cd C:\nginx; .\nginx.exe -s stop

# Reiniciar NGINX
Restart-Service -Name "nginx"
# ou
cd C:\nginx; .\nginx.exe -s reload

# Verificar sintaxe
cd C:\nginx; .\nginx.exe -t

# Ver logs em tempo real
Get-Content C:\nginx\logs\yachid_access.log -Wait -Tail 50
```

## Suporte

Em caso de problemas, verifique:
- Logs do NGINX
- Logs do NestJS
- Console do navegador (F12)
- Firewall da Azure
