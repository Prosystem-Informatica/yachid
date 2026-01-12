Yachid

# 🚀 Flutter Web • Clean Architecture + BLoC

> Arquitetura limpa, modular e escalável para aplicações Flutter Web.

Este projeto utiliza uma **Clean Architecture adaptada**, com **BLoC/Cubit** para gerenciamento de estado, priorizando organização por domínio, manutenibilidade e crescimento sustentável do código.

---

## 📁 Estrutura de Pastas

lib/
└─ app/
├─ core/                 # Recursos compartilhados
│   ├─ config/
│   ├─ helpers/
│   ├─ rest/
│   └─ ui/
├─ features/             # Camada de UI e regras de cada módulo
│   └─ auth/
│       └─ ui/
├─ model/                # Entidades e modelos globais
├─ repositories/         # Regras de negócio e fontes de dados
├─ app_routes.dart
├─ app_widget.dart
├─ bloc_injector.dart
└─ main.dart

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