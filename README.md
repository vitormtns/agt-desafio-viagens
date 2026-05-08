# AGT Viagens - Desafio Técnico

## Descrição

Este projeto é uma solução para gerenciamento de viagens corporativas, composta por:

- backend Spring Boot;
- app Flutter.

O backend fornece uma API REST com autenticação JWT, regras de domínio e persistência em H2. O app Flutter consome essa API e oferece uma interface em português do Brasil para login, listagem, criação e acompanhamento das viagens.

## Estrutura do projeto

```text
backend/
app/
README.md
```

- `backend/`: API REST Spring Boot.
- `app/`: aplicativo Flutter.

## Tecnologias utilizadas

Backend:

- Java 21
- Spring Boot
- Maven
- Spring Security/JWT
- H2 em memória

App:

- Flutter 3.x+
- Dart null safety
- Provider/ChangeNotifier
- http
- flutter_secure_storage
- intl

## Funcionalidades implementadas

Backend:

- `GET /viagens`
- `POST /viagens`
- `PATCH /viagens/{id}/status`
- autenticação JWT
- validações e regras de status

App:

- login
- armazenamento seguro de tokens
- sessão persistente
- listagem de viagens
- criação de viagem
- detalhe da viagem
- alteração de status
- estados de loading, erro, vazio e retry
- tratamento de timeout/erro de rede
- interface em pt-BR

## Regras de status

- `AGENDADA` -> `EM_ANDAMENTO` ou `CANCELADA`
- `EM_ANDAMENTO` -> `CONCLUIDA` ou `CANCELADA`
- `CONCLUIDA` -> sem transições
- `CANCELADA` -> sem transições

## Pré-requisitos

- Java 21+
- Maven 3.9+ ou Maven Wrapper
- Flutter 3.x+
- Android Studio/Android Emulator

## Como rodar o backend

No Windows:

```powershell
cd backend
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=dev"
```

Após subir o backend:

- API: http://localhost:8080
- Swagger: http://127.0.0.1:8080/swagger-ui/index.html
- H2 Console: http://127.0.0.1:8080/h2-console

## Credenciais de teste

- Usuário: `usuario.teste`
- Senha: `senha123`

## Como rodar o app Flutter

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

O endereço `10.0.2.2` é usado pelo Android Emulator para acessar o `localhost` da máquina. Nos testes locais via navegador, `127.0.0.1` funcionou melhor.

## Como executar testes e validações

Backend:

```powershell
cd backend
.\mvnw.cmd test
```

App:

```powershell
cd app
flutter analyze
flutter test
```

## Fluxo manual de teste

1. Subir backend.
2. Abrir app.
3. Fazer login.
4. Ver lista de viagens.
5. Criar nova viagem.
6. Abrir detalhe.
7. Iniciar viagem.
8. Concluir viagem.
9. Criar outra viagem e cancelar.
10. Testar backend desligado para ver erro/retry.

## Decisões técnicas

- Provider/ChangeNotifier foi escolhido por simplicidade e aderência ao escopo.
- Services separam o consumo da API das telas.
- TokenStorage usa `flutter_secure_storage`.
- Backend manteve a arquitetura original do scaffold.
- Regra de status centralizada no backend.
- UI pensada para uso corporativo, com identidade visual inspirada na AGT/Agroterenas.

## Observações

- Em perfil dev, o banco H2 é em memória. Dados criados manualmente são perdidos ao reiniciar o backend.
- O refresh token é armazenado, mas a renovação automática do access token não foi implementada nesta versão.
- Ao expirar a sessão, o usuário pode fazer login novamente.

## Melhorias futuras

- refresh token automático;
- testes automatizados adicionais;
- filtros por status;
- paginação;
- melhoria de redirecionamento automático em sessão expirada;
- CORS mais restritivo para produção.
