# Backend

API REST Spring Boot do desafio técnico **AGT Viagens - Controle de Viagens Corporativas**.

Este README resume apenas os comandos principais do backend. A documentação completa da entrega está no [README da raiz](../README.md).

## Pré-requisitos

- Java 21+
- Maven 3.9+ ou Maven Wrapper

## Como rodar

No Windows:

```powershell
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=dev"
```

Após subir o backend:

- API: http://localhost:8080
- Swagger: http://127.0.0.1:8080/swagger-ui/index.html
- H2 Console: http://127.0.0.1:8080/h2-console

## Credenciais de teste

- Usuário: `usuario.teste`
- Senha: `senha123`

## Endpoints principais

- `POST /auth/login`
- `POST /auth/refresh`
- `GET /dominios/finalidades`
- `GET /dominios/transportes`
- `GET /viagens`
- `POST /viagens`
- `PATCH /viagens/{id}/status`

## Testes

```powershell
.\mvnw.cmd test
```

## Observações

- Em perfil dev, o banco H2 é em memória.
- Os endpoints de viagens já estão implementados.
- As regras de transição de status são validadas no backend.
