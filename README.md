## Desafio

O objetivo do desafio era criar um ambiente Docker contendo uma aplicação Laravel simples e um banco PostgreSQL, garantindo que ambos os containers se conectassem corretamente e que o banco tivesse um usuário dedicado com permissões limitadas.

## Configuração

Primeiro defini a imagem PHP e criei o Dockerfile utilizando multi-stage build para reduzir o tamanho final da imagem.

Em seguida montei o docker-compose, definindo os serviços:

- app → container PHP (Laravel)

- db → container PostgreSQL

#### Também configurei:

- volumes, para persistência do banco

- network interna, para comunicação entre os serviços

#### Variáveis de ambiente
Para organizar melhor as configurações, separei o ambiente em dois arquivos:

- .env → Variáveis utilizadas pelo Docker (PostgreSQL root, porta, usuário da aplicação, etc.)

- .env.laravel → Variáveis do Laravel (credenciais de conexão, DB_HOST, DB_PORT, DB_DATABASE, etc.)

#### Criação de usuário limitado no Postgres
Criei um script init-user.sh responsável por:

- Criar um usuário específico da aplicação
- Criar o banco
- Ajustar permissões mínimas (CRUD, sequences, migrations)

Adicionei esse script em docker-entrypoint-initdb.d/ através de um Dockerfile customizado do Postgres para garantir que o arquivo já viesse com permissão de execução.

Com tudo configurado, foi possível gerar a imagem e subir os containers sem erros.

## Inicializando a aplicação
Antes de criar a imagem, deve-se criar 2 envs e configurar suas variáveis de ambiente, como a porta em que o postgres vai estar e suas credenciais. 

- Copie o .env.example.laravel e renomeie como .env.laravel. Nele, configure o db_username, password, nome do banco e a porta. Lembre-se que estamos utilizando o postgres. 
- Depois copie o .env.example.docker e renomeie como .env. Nele, configure as mesmas variáveis de username, password e nome do banco (primeiros os padrões do postgres). E depois configure essas mesmas variáveis mais para o usuário específico da nossa aplicação. Note que essas variáveis serão utilizadas no init-user.sh para criar o usuário e dar as devidas permissões a ele. 

Com essas configurações feitas, basta seguir os seguintes comandos: 

- docker compose up -d 
- docker exec -it laravel_app /bin/sh  
- php artisan migrate -> cria tabelas que esse projeto padrão laravel pede 

Após executar as migrations, a aplicação estará disponível em:

 - http://localhost:8000

Ao acessar normalmente, vemos que os containers estão conectados entre si. 

