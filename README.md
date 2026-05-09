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
- 6 testes executados

App:

```powershell
cd app
flutter analyze
flutter test
```

Resultados atuais:

- `flutter analyze` sem issues
- `flutter test` com 17 testes executados

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

## Decisões técnicas

- Provider/ChangeNotifier foi escolhido por simplicidade e aderência ao escopo.
- Services separam o consumo da API das telas.
- TokenStorage usa `flutter_secure_storage` para persistir os tokens com segurança.
- Backend manteve a arquitetura original do scaffold.
- Regras de status foram centralizadas no backend.
- App possui ordenação visual adicional por status para priorizar viagens acionáveis.
- UI pensada para uso corporativo, com identidade inspirada na AGT/Agroterenas, sem uso de logotipo oficial ou assets externos.

## Observações importantes

- Em perfil dev, o H2 é em memória. Dados criados manualmente são perdidos ao reiniciar o backend.
- O backend retorna `GET /viagens` ordenado por criação mais recente, conforme o desafio.
- O app aplica uma ordenação visual adicional por status para priorizar viagens acionáveis; dentro de cada status, preserva mais recentes primeiro.
- O refresh token é armazenado, mas a renovação automática do access token não foi implementada nesta versão.
- Quando a API retorna `401` ou `403`, o app limpa a sessão local, volta para o login e informa que a sessão expirou.

## Possível evolução: modo offline e sincronização

Nesta versão, o app trabalha no modelo online-first. As viagens são enviadas diretamente para a API Java, e apenas os tokens são armazenados localmente.

Uma evolução futura poderia incluir:

- banco local no app, como SQLite/Drift;
- fila de operações pendentes;
- campo `syncStatus` com valores como `PENDENTE`, `ENVIANDO`, `SINCRONIZADO` e `ERRO`;
- sincronização automática quando houver conexão;
- envio para a API Java, que persistiria no banco corporativo, como Oracle ou PostgreSQL;
- tratamento de conflitos entre dados locais e servidor.

Essa seção descreve uma melhoria futura. O modo offline e a sincronização local não fazem parte das funcionalidades implementadas nesta versão.

## Melhorias futuras

- refresh token automático;
- filtros simples por status;
- busca por destino;
- paginação;
- testes automatizados adicionais de widget/service;
- CORS mais restritivo para produção;
- modo offline/sincronização.
