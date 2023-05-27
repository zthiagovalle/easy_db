# Como ter um banco de dados fácil para começar sua aplicação (Postgres + Docker + Docker Compose)

## Motivação

Este post tem como motivação ensinar a criação de um setup de banco de dados postgres rápido e fácil para você começar uma aplicação.

## Requisitos

1. Docker
2. Docker Compose

## Passo a Passo

Com o docker e docker-compose previamente instalado na máquina vou criar um arquivo docker-compose.yml

<img src="https://i.imgur.com/gTVVkJS.png">
Ele é um arquivo de configuração usado pelo Docker Compose para definir, configurar e executar aplicativos multi-container.
Em vez de termos que escrever comandos docker no terminal varias e varias vezes, é nele onde escreveremos a receita do bolo uma única vez, onde posteriormente só precisaremos executar o arquivo.

Iremos escrever o seguinte:

```yaml
version: "3"

services:
	mydb:
		image: postgres
		restart: always
		environment:
			- POSTGRES_USER=postgres
			- POSTGRES_PASSWORD=123456
			- POSTGRES_DB=app
		volumes:
			- ./data:/var/lib/postgresql/data
			- ./scripts/create.sql:/docker-entrypoint-initdb.d/init.sql
		ports:
			- "5432:5432"
```

Descrição:

```yaml
version: "3"
```

Essa linha define a versão do formato do arquivo `docker-compose.yml` sendo usado. No exemplo, está usando a versão "3" da especificação do Docker Compose.

---

```yaml
services:
```

Essa linha inicia a seção de serviços no arquivo. Aqui é onde você define os serviços (contêineres) que compõem seu aplicativo.

---

```yaml
mydb:
```

Essa linha define o nome do serviço. No exemplo, o serviço é chamado de "mydb". Você pode dar o nome que desejar aos serviços.

---

```yaml
image: postgres
```

Essa linha define a imagem do contêiner que será usada para o serviço "mydb". Neste caso, está usando a imagem oficial do PostgreSQL chamada "postgres". O Docker Compose irá buscar essa imagem no Docker Hub, a menos que você já a tenha baixado anteriormente.

---

```yaml
restart: always
```

Essa linha especifica a política de reinicialização para o serviço "mydb". Neste caso, está definido como "always", o que significa que o contêiner será sempre reiniciado automaticamente se ocorrer uma falha ou se o sistema for reiniciado.

---

```yaml
environment:
  - POSTGRES_USER=postgres
  - POSTGRES_PASSWORD=123456
  - POSTGRES_DB=app
```

Essas linhas definem as variáveis de ambiente que serão configuradas dentro do contêiner do PostgreSQL. No exemplo, três variáveis de ambiente estão sendo definidas: `POSTGRES_USER` com valor "postgres", `POSTGRES_PASSWORD` com valor "123456" e `POSTGRES_DB` com valor "app". Essas variáveis de ambiente serão usadas para configurar o usuário, a senha e o banco de dados do PostgreSQL.

---

```yaml
ports:
  - "5432:5432"
```

Essa linha define a mapeamento de portas para o serviço "mydb". No exemplo, está mapeando a porta 5432 do host (máquina local) para a porta 5432 do contêiner. Isso permite que você acesse o PostgreSQL do contêiner por meio da porta 5432 em sua máquina local.

---

```yaml
volumes:
  - ./data:/var/lib/postgresql/data
  - ./scripts/create.sql:/docker-entrypoint-initdb.d/init.sql
```

Essas linhas definem os volumes que serão montados dentro do contêiner do PostgreSQL. No exemplo, dois volumes estão sendo definidos: `./data:/var/lib/postgresql/data` e `./scripts/create.sql:/docker-entrypoint-initdb.d/init.sql`.
Isso significa que o diretório local `./data` será montado no diretório `/var/lib/postgresql/data` dentro do contêiner, e o arquivo `./scripts/create.sql` será montado como `init.sql` no diretório `/docker-entrypoint-initdb.d/` dentro do contêiner. Esses volumes são usados para persistir dados do PostgreSQL e para executar scripts de inicialização.

O volume ./scripts/create.sql:/docker-entrypoint-initdb.d/init.sql é para já inicializarmos o nosso banco executando um script .sql
Nesse caso vamos criar uma pasta scripts com o arquivo create.sql, e dentro já definir um script de criação.
<img src="https://i.imgur.com/551Ow2I.png">
Criei um schema chamado thiago, uma tabela de filme e já criei o script de insert de 3 registros.

Para uma demonstração mais legal, inicializei a pasta como um projeto node.js

```bash
npm init -y
```

Instalei o pg-promise para criarmos a conexão ao banco de dados

```bash
npm install pg-promise
```

Criei uma pasta src com um arquivo main.js e dentro dele criei uma conexão com o banco que o docker-compose irá gerar e fiz um select na tabela do banco.

<img src="https://i.imgur.com/BNHsqU8.png">

Repare que a linha 3 eu passei a string de conexão ao postgres seguindo as variáveis de ambiente que definimos no docker-compose

1. Protocolo: "postgres://" indica que o protocolo de comunicação usado para a conexão é o PostgreSQL.
2. Usuário e senha: "postgres:123456" indica o nome de usuário e a senha necessários para autenticar a conexão ao banco de dados. Neste exemplo, o nome de usuário é "postgres" e a senha é "123456".
3. Host e porta: "localhost:5432" especifica o endereço do servidor onde o banco de dados está sendo executado. Neste caso, "localhost" indica que o banco de dados está sendo executado na mesma máquina em que o código está sendo executado. "5432" é o número da porta padrão usada pelo PostgreSQL para aceitar conexões.
4. Banco de dados: "app" indica o nome do banco de dados ao qual você deseja se conectar.

Agora, vamos executar o nosso arquivo docker-compose para criar o nosso banco, para isso rode o comando

```bash
docker compose up -d
```

1. `up`: Especifica que você deseja iniciar os contêineres definidos no arquivo `docker-compose.yml`.
2. `-d` : Opção para executar os contêineres em segundo plano (modo detached). Isso significa que o(s) contêineres serão iniciados e executados em segundo plano, e o controle do terminal será liberado para que você possa continuar usando-o.

<img src="https://i.imgur.com/Z3vhRyG.png">

Repare que foi criado uma pasta data na raiz do projeto, ela se refere ao volume `./data:/var/lib/postgresql/data` que definimos no docker-compose, dessa forma todos os dados do banco de dados estão espelhados nessa pasta, assim salvando o estado do banco.

Agora é só rodar o arquivo main.js

```bash
node src/main.js
```

E feito, conseguiu conectar ao banco e retornar os registros

<img src="https://i.imgur.com/Gwiz2Hj.png">

Caso queria derrubar o banco de dados, rode o comando

```bash
docker compose down
```

Ficarei muito feliz se este post tenha ajudado você de alguma forma, deixo meu muito obrigado se chegou até aqui.  
Tem alguma dica, pergunta ou feedback ? Deixe nos comentários

linkedin: https://www.linkedin.com/in/zthiagovalle/
