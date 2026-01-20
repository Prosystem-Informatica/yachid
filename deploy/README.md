# Deploy Rápido - Yachid

## Resumo dos Arquivos

- **`nginx.conf`** - Configuração NGINX para HTTP (desenvolvimento/testes)
- **`nginx-https.conf`** - Configuração NGINX para HTTPS (produção - OBRIGATÓRIO)
- **`build-web.ps1`** - Script para build do Flutter Web
- **`deploy-to-azure.ps1`** - Script de deploy automatizado
- **`install-nginx-windows.ps1`** - Script de instalação do NGINX
- **`env.example.txt`** - Exemplo de arquivo .env
- **`DEPLOY.md`** - Documentação completa de deploy

## Deploy Rápido (5 passos)

1. **Instalar NGINX**:
```powershell
.\deploy\install-nginx-windows.ps1
```

2. **Configurar NGINX** (usar versão HTTPS para produção):
```powershell
Copy-Item deploy\nginx-https.conf C:\nginx\conf\nginx.conf
# Ajustar caminhos de certificados SSL no arquivo
```

3. **Criar arquivo .env** na raiz do projeto:
```
BASE_URL=seudominio.com
```

4. **Build e Deploy**:
```powershell
.\deploy\deploy-to-azure.ps1
```

5. **Verificar**:
- Acesse `https://seudominio.com`
- Teste as chamadas de API

## Estrutura na VM

```
C:\nginx\
├── conf\nginx.conf
├── html\yachid\        ← App Flutter Web aqui
└── logs\
```

## Importante

- ⚠️ **HTTPS é obrigatório** - O Flutter usa `Uri.https()` para todas as APIs
- ⚠️ Configure certificados SSL antes do deploy
- ⚠️ Abra portas 80 e 443 no firewall da Azure

Veja `DEPLOY.md` para documentação completa.
