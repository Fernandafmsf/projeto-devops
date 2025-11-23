## Desafio
O desafio proposto era criar um container no docker que armazenasse uma aplicação simples e que tivesse conexão com o banco de dados. 

## Configuração
Comecei primeiro escolhendo a imagem php que eu iria usar e montei o Dockerfile, usando multi estágio. 

Depois disso, comecei a montar o docker-compose, onde defini o serviço app (php) e o db (postgres). 

Nele defini o volumes a ser utilizado e a network também. 

Logo após comecei a configuração do usário específico para o banco de dados, o que me fez precisar mais ainda declarar variáveis, então declarei todas que iria precisar. Separei 2 arquivos .env, um para o laravel e outro para o docker 
- .env -> variáveis do docker, como usuário para se conectar ao banco e credenciais do novo usuário também
- .env.laravel -> variáveis do laravel, como as de conexão com o banco 
Com essas variáveis prontas, criei um arquivo init-user.sh para criar o usuário com as permissões específicas. Criei também um dockerfile específico para o postgres para que eu pudesse rodar a permissão para o init-user

Com essas configurações feitas, foi possível criar a imagem e subir o container 

## Comandos 
- docker compose up -d 
- docker exec -it laravel_app /bin/sh  
- php artisan migrate -> cria tabelas que esse projeto padrão laravel pede 

Com isso já é possível acessar em localhost:8000. 

Ao acessar normalmente, vemos que os containers estão conectados entre si. 

