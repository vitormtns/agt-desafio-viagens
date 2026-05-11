# AGT Viagens - Desafio Técnico

## Descrição

Solução para gerenciamento de viagens corporativas, composta por:

- backend Spring Boot;
- app Flutter.

O backend fornece uma API REST com autenticação JWT, regras de domínio, persistência em H2 em memória no perfil de desenvolvimento e documentação via Swagger. O app Flutter consome essa API e oferece uma interface em português do Brasil para login, listagem, criação, acompanhamento e alteração de status das viagens.

## Estrutura do projeto

```text
backend/
app/
README.md
```

- `backend/`: API REST Spring Boot.
- `app/`: aplicativo Flutter.
- `README.md`: documentação principal da entrega.

## Tecnologias utilizadas

Backend:

- Java 21
- Spring Boot
- Maven/Maven Wrapper
- Spring Security/JWT
- H2 em memória
- Swagger

App Flutter:

- Flutter 3.x+
- Dart null safety
- Provider/ChangeNotifier
- http
- flutter_secure_storage
- intl
- flutter_localizations

## Funcionalidades implementadas

Backend:

- autenticação com JWT;
- domínios de finalidades e transportes;
- listagem de viagens;
- criação de viagens;
- alteração de status de viagens;
- validação das regras de transição de status.

Endpoints prontos no scaffold:

- `POST /auth/login`
- `POST /auth/refresh`
- `GET /dominios/finalidades`
- `GET /dominios/transportes`

Endpoints de viagens implementados no desafio:

- `GET /viagens`
- `POST /viagens`
- `PATCH /viagens/{id}/status`

App Flutter:

- login real integrado à API;
- armazenamento seguro de `accessToken` e `refreshToken`;
- sessão persistente;
- tratamento automático de sessão expirada;
- lista de viagens;
- criação de viagem;
- detalhe da viagem;
- alteração de status;
- botões condicionais por status;
- estados de carregamento, erro, vazio, tentar novamente e timeout;
- interface em português do Brasil;
- polimento visual inspirado na identidade AGT/Agroterenas, sem uso de logotipo oficial ou assets externos.

## Ordenação das viagens no app

O backend retorna `GET /viagens` ordenado por criação mais recente, conforme o desafio.

No app, foi aplicada uma ordenação visual adicional para priorizar viagens acionáveis:

1. Em andamento
2. Agendada
3. Concluída
4. Cancelada

Dentro do mesmo status, a ordenação por viagens mais recentes é preservada.

## Regras de status

- `AGENDADA` -> `EM_ANDAMENTO` ou `CANCELADA`
- `EM_ANDAMENTO` -> `CONCLUIDA` ou `CANCELADA`
- `CONCLUIDA` -> sem transições
- `CANCELADA` -> sem transições

As regras de status ficam centralizadas no backend. O app exibe apenas as ações permitidas para cada status.

## Pré-requisitos

- Java 21+
- Maven 3.9+ ou Maven Wrapper
- Flutter 3.x+
- Android Studio, Android Emulator, Chrome ou dispositivo físico configurado para desenvolvimento Flutter

## Como rodar o backend

A partir da raiz do projeto, no Windows:

```powershell
cd backend
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=dev"
```

O perfil `dev` utiliza H2 em memória e facilita a execução local do desafio.

Após subir o backend:

- API: http://localhost:8080
- Swagger: http://127.0.0.1:8080/swagger-ui/index.html
- H2 Console: http://127.0.0.1:8080/h2-console

## Credenciais de teste

- Usuário: `usuario.teste`
- Senha: `senha123`

## Como rodar o app Flutter

A partir da raiz do projeto:

```powershell
cd app
flutter pub get
```

Android Emulator:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

Chrome/local:

```powershell
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8080
```

Celular físico:

Use o IP da máquina que está executando o backend, desde que o computador e o celular estejam na mesma rede.

```powershell
flutter run --dart-define=API_BASE_URL=http://IP_DA_MAQUINA:8080
```

Exemplo:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8080
```

## Validações do projeto

Backend:

```powershell
cd backend
.\mvnw.cmd test
```

Resultado atual:

- `BUILD SUCCESS`
- 6 testes executados, focados em regras críticas do backend

App:

```powershell
cd app
flutter analyze
flutter test
```

Resultados atuais:

- `flutter analyze` sem issues
- `flutter test` com 17 testes unitários focados em regras críticas do app

## Fluxo manual de teste sugerido

1. Subir o backend.
2. Rodar o app.
3. Fazer login com `usuario.teste` / `senha123`.
4. Ver a lista de viagens carregada.
5. Criar uma nova viagem.
6. Confirmar que a viagem aparece na lista como Agendada.
7. Abrir o detalhe da viagem.
8. Iniciar a viagem e confirmar o status Em andamento.
9. Concluir a viagem e confirmar o status Concluída.
10. Criar outra viagem e cancelar.
11. Desligar o backend e confirmar a exibição de erro com opção de tentar novamente.
12. Aguardar a expiração da sessão ou usar token inválido e confirmar o retorno ao login com mensagem de sessão expirada.

## Organização, clareza e tomada de decisão

Organização:

- O projeto foi separado em `backend/` e `app/`, mantendo responsabilidades bem definidas entre API Java e cliente Flutter.
- O backend preserva a arquitetura original do scaffold, com as implementações do desafio encaixadas nas camadas já existentes.
- O app está organizado em `core`, `models`, `services`, `state` e `features`, separando infraestrutura, modelos, integração com API, estado de tela e fluxos de interface.

Clareza na implementação:

- Os services isolam o consumo da API das telas, deixando a interface focada em estado, navegação e apresentação.
- Provider/ChangeNotifier centraliza estados do app sem adicionar complexidade desnecessária ao MVP.
- As telas tratam carregamento, lista vazia, erro, tentar novamente, timeout e sessão expirada.
- O fluxo principal do usuário é direto: login, lista de viagens, criação, detalhe e alteração de status.

Tomada de decisão:

- O backend foi mantido como fonte de verdade para as regras de transição de status.
- O app exibe apenas as ações possíveis para o status atual de cada viagem.
- O refresh token é armazenado com segurança, mas a renovação automática do access token não foi implementada para manter o escopo controlado.
- Quando a API retorna `401` ou `403`, o app limpa a sessão local e retorna para o login.
- Modo offline e sincronização foram documentados como evolução futura, não como parte desta versão.
- A UI foi inspirada na identidade visual da AGT/Agroterenas, sem uso de logotipo oficial ou assets externos.

## Decisões técnicas

- O app segue uma abordagem online-first, consumindo diretamente a API Java.
- TokenStorage usa `flutter_secure_storage` para persistir `accessToken` e `refreshToken`.
- O backend centraliza as regras de status e valida as transições permitidas.
- O app aplica uma ordenação visual adicional por status para priorizar viagens acionáveis, preservando a ordenação por criação mais recente dentro de cada status.
- A solução prioriza um MVP funcional, consistente e seguro, com complexidade proporcional ao prazo e ao escopo do desafio.

## Observações importantes

- Em perfil dev, o H2 é em memória. Dados criados manualmente são perdidos ao reiniciar o backend.
- O backend retorna `GET /viagens` ordenado por criação mais recente, conforme o desafio.
- O app aplica uma ordenação visual adicional por status para priorizar viagens acionáveis; dentro de cada status, preserva mais recentes primeiro.
- O refresh token é armazenado, mas a renovação automática do access token não foi implementada nesta versão.
- Quando a API retorna `401` ou `403`, o app limpa a sessão local, volta para o login e informa que a sessão expirou.

## Escopo e melhorias futuras

Implementado nesta versão:

- app online-first consumindo a API Java;
- armazenamento seguro dos tokens;
- sessão persistente;
- tratamento de sessão expirada com retorno ao login;
- timeout e opção de tentar novamente;
- testes unitários focados em regras críticas;
- polimento visual e de UX.

Deixado como melhoria futura:

- refresh token automático;
- modo offline com banco local;
- fila de operações pendentes;
- sincronização com a API Java;
- persistência futura em banco corporativo, como Oracle ou PostgreSQL;
- filtros, busca e paginação;
- testes adicionais de widget/service;
- CORS mais restritivo para produção.

Esses itens foram deixados como evolução futura por decisão de escopo, para manter o MVP funcional, consistente e seguro dentro do prazo. Eles não representam falhas da entrega atual, mas caminhos naturais de evolução para um produto em produção.
