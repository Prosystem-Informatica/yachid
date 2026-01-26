Yachid

# 🚀 Flutter Web • Clean Architecture + BLoC

> Arquitetura limpa, modular e escalável para aplicações Flutter Web.

Este projeto utiliza uma **Clean Architecture adaptada**, com **BLoC/Cubit** para gerenciamento de estado, priorizando organização por domínio, manutenibilidade e crescimento sustentável do código.

---

## 📁 Estrutura de Pastas

<pre> lib/ └── app/ ├── core/ # Recursos compartilhados │ ├── config/ │ ├── helpers/ │ ├── rest/ │ └── ui/ ├── features/ # Camada de UI (módulos) │ └── auth/ │ └── ui/ ├── model/ # Entidades e modelos globais ├── repositories/ # Regras de negócio e fontes de dados ├── app_routes.dart ├── app_widget.dart ├── bloc_injector.dart └── main.dart </pre>

---

## 🧱 Arquitetura

A aplicação segue uma **Clean Architecture adaptada ao Flutter**, baseada em módulos, garantindo:

- Separação clara de responsabilidades
- Baixo acoplamento
- Alta escalabilidade
- Código previsível e testável

---

## 🧠 Gerenciamento de Estado

- flutter_bloc
- Cubit
- Equatable
- Geração automática de código com `build_runner`

---

## ⚙️ Geração de Código

Sempre que criar ou modificar `State`s de Cubits/BLoCs, execute:

```bash
dart run build_runner build --delete-conflicting-outputs

▶️ Executando o Projeto
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome

🧩 Organização de Módulos

Cada módulo (feature) segue o padrão:

features/
└─ feature_name/
└─ ui/


Modelos e regras de negócio ficam centralizados em:

model/
repositories/

## 🚀 Instruções de Deploy na VM (Docker)

### 1. Gere a imagem Docker do seu projeto

No diretório raiz do seu projeto (onde está o `Dockerfile`), execute o comando abaixo para criar a imagem do Docker:

```bash
docker build -t yachid-web-image .
```

### 2. Rode o container com Docker

Execute o comando a seguir para iniciar o container. Esse comando irá:

- Liberar as portas 80 (HTTP) e 443 (HTTPS)
- Montar os certificados SSL da sua VM para dentro do container (para HTTPS)
- Nomear o container como `yachid-web-container`
- Usar a imagem que criamos acima

```bash
docker run -d \
  -p 80:80 \
  -p 443:443 \
  -v /etc/letsencrypt:/etc/letsencrypt:ro \
  --name yachid-web-container \
  yachid-web-image
```

### 3. Checando o status do container

Verifique se o container está rodando:

```bash
docker ps
```

# ⚠️ não usar "docker ps -a" pois ele listará todos os container criados e queremos somente os ativos.

Se por algum motivo em docker ps não aparecer o container yachid-web-container.

rode o comando docker logs yachid-web-container e trará todos os logs indicando o erro.



Se precisar reiniciar ou parar:

```bash
docker restart flutter-web     # Reinicia
docker stop flutter-web        # Para
docker rm flutter-web          # Remove
```

---

> Certifique-se de que sua configuração de certificados SSL em `/etc/letsencrypt` está correta na VM para HTTPS funcionar.
> Se necessário, ajuste os caminhos e portas conforme seu ambiente.

---

