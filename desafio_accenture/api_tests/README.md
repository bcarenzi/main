# API Tests – DemoQA BookStore

Testes de API em **BDD** (Behavior Driven Development) para a [DemoQA BookStore](https://demoqa.com/swagger).

## Tecnologias

| Tecnologia | Uso |
|------------|-----|
| **Python 3** | Linguagem dos testes |
| **Behave** | BDD: cenários em Gherkin (`.feature`) e steps em Python |
| **Requests** | Chamadas HTTP às APIs |
| **pytest** | Runner alternativo / relatórios (opcional) |

Os cenários ficam em **linguagem natural** nos arquivos `.feature`; a lógica (URLs, bodies, asserts) fica nos **steps** (page object por fluxo).

## Estrutura

```
api_tests/
├── features/
│   ├── *.feature          # Cenários BDD (Gherkin)
│   ├── environment.py     # Hooks (before_all, before_scenario) e contexto
│   └── steps/             # Step definitions
│       ├── common.py      # Steps compartilhados (ex.: API disponível)
│       ├── create_user.py
│       ├── user_validation.py
│       ├── search_for_available_books.py
│       ├── rent_books.py
│       └── user_books_details.py
├── requirements.txt
└── README.md
```

### Verificação da API antes dos testes

- **`environment.py`** → No `before_scenario` é feito um GET em `/BookStore/v1/Books` para checar se a API está no ar. Se falhar, o cenário já quebra antes de rodar os steps.
- **`steps/common.py`** → Contém o step `Given the BookStore/DemoQA/Account API is available` (e variantes). Esse step só valida o resultado da checagem feita no hook; a requisição em si não se repete em cada feature.

## Como rodar

### 1. Ambiente virtual (recomendado)

Na **raiz do projeto** (onde está o `.venv`):

```bash
# Criar e ativar o venv (se ainda não existir)
python3 -m venv .venv
source .venv/bin/activate   # no Windows: .venv\Scripts\activate

# Instalar dependências
pip install -r api_tests/requirements.txt
```

### 2. Executar os testes

**A partir da raiz do projeto:**

```bash
.venv/bin/behave api_tests/features
```

**De dentro da pasta `api_tests`:**

```bash
cd api_tests
../.venv/bin/behave features
```

Ou, com o venv já ativado:

```bash
cd api_tests
behave features
```

### 3. Rodar uma feature específica

```bash
behave api_tests/features/create_userfeature
```

## Variável de ambiente (opcional)

Para usar uma senha de teste definida fora do código (ex.: CI com GitHub Secrets):

- **Nome:** `TEST_USER_PASSWORD`
- **Uso:** senha dos usuários criados nos testes. Se não for definida, é usado o valor padrão local.

No GitHub Actions, configure o secret `TEST_USER_PASSWORD` em **Settings → Secrets and variables → Actions**.
