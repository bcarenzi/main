# 🎬 Cinepass - Ficha de Filmes Assistidos

Aplicação Rails simples para gerenciar filmes assistidos no cinema com sistema de avaliação por estrelas.

## Funcionalidades

- ✅ CRUD completo de filmes
- ⭐ Sistema de avaliação por estrelas (1-5)
- 📅 Registro da data de exibição
- 📝 Campo de notas e observações
- 📥 Exportação para JSON (individual ou todos os filmes)
- 🎨 Interface web simples e funcional

## Requisitos

- Ruby (qualquer versão recente)
- Rails 7.0
- SQLite3 (já incluído)

## Instalação e Uso

1. Entre na pasta do projeto:
```bash
cd cinepass
```

2. Instale as dependências:
```bash
bundle install
```

3. Crie o banco de dados e execute as migrations:
```bash
rails db:create
rails db:migrate
```

4. Inicie o servidor:
```bash
rails server
```

5. Acesse a aplicação no navegador:
```
http://localhost:3000
```

## Uso

### Adicionar um Filme
- Clique em "Adicionar Novo Filme"
- Preencha o título (obrigatório)
- Selecione a data que assistiu (obrigatório)
- Escolha uma avaliação de 1 a 5 estrelas (opcional)
- Adicione notas e observações (opcional)

### Editar um Filme
- Clique em "Editar" no card do filme
- Modifique os campos desejados
- Salve as alterações

### Exportar para JSON
- **Filme individual**: Clique em "Exportar" no card do filme
- **Todos os filmes**: Clique em "Exportar Todos (JSON)" na página principal

## Estrutura do Banco de Dados

### Tabela: movies
- `id` (integer, primary key)
- `title` (string, obrigatório)
- `watched_at` (date, obrigatório)
- `rating` (integer, 1-5, opcional)
- `notes` (text, opcional)
- `created_at` (datetime)
- `updated_at` (datetime)

## Rotas

- `GET /` - Lista todos os filmes
- `GET /movies` - Lista todos os filmes
- `GET /movies/new` - Formulário para novo filme
- `POST /movies` - Cria um novo filme
- `GET /movies/:id` - Mostra detalhes de um filme
- `GET /movies/:id/edit` - Formulário para editar filme
- `PATCH/PUT /movies/:id` - Atualiza um filme
- `DELETE /movies/:id` - Remove um filme
- `GET /movies/:id/export` - Exporta um filme para JSON
- `GET /movies/export/all` - Exporta todos os filmes para JSON

## Tecnologias

- Ruby on Rails 7.0
- SQLite3
- HTML/CSS/JavaScript

## Licença

Este projeto é de código aberto e está disponível sob a licença MIT.

