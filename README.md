## Informações técnicas

### Dependências
- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15

### Como executar o projeto

#### 1. Executando a aplicação sem Docker

**Pré-requisitos:**
Certifique-se de ter as seguintes ferramentas instaladas e configuradas em seu ambiente local:
- Ruby (versão 3.3.1)
- Rails (versão 7.1.3.2)
- PostgreSQL (versão 16)
- Redis (versão 7.0.15)

**Passos para execução:**
1. Instale as dependências do projeto:
   ```bash
   bundle install
   ```
2. Configure o banco de dados (crie e execute as migrações):
   ```bash
   rails db:create db:migrate
   ```
3. Execute o Sidekiq (processador de jobs em segundo plano):
   ```bash
   bundle exec sidekiq -C config/sidekiq.yml
   ```
4. Inicie o servidor Rails:
   ```bash
   bundle exec rails server
   ```
   A aplicação estará disponível em `http://localhost:3000`.

#### 2. Executando a aplicação com Docker

**Pré-requisitos:**
Certifique-se de ter o Docker e o Docker Compose instalados em sua máquina.

**Passos para execução:**
1. Navegue até o diretório raiz do projeto no seu terminal.
2. Construa as imagens Docker (isso pode levar alguns minutos na primeira vez):
   ```bash
   docker compose build
   ```
3. Inicie os serviços da aplicação (servidor web, banco de dados, Redis e Sidekiq) em segundo plano:
   ```bash
   docker compose up -d
   ```
4. Execute as migrações do banco de dados dentro do contêiner `web`:
   ```bash
   docker compose exec web rails db:create db:migrate
   ```
5. Acesse a aplicação em seu navegador:
   ```
   http://localhost:3000
   ```
   Você também pode acessar a interface web do Sidekiq para monitorar os jobs agendados em `http://localhost:3000/sidekiq` 

**Executando testes com Docker:**
Para rodar os testes, você pode usar o seguinte comando:
```bash
docker compose exec web bundle exec rspec
```

**Parando a aplicação Docker:**
Para parar e remover os contêineres, execute:
```bash
docker compose down
```
