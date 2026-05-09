# Backend

API REST Spring Boot do desafio técnico **AGT Viagens - Desafio Técnico**.

Este README resume apenas os comandos principais do backend. A documentação completa da entrega está no [README da raiz](../README.md).

## Como rodar

A partir desta pasta (`backend/`):

```powershell
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=dev"
```

Após subir o backend:

- API: http://localhost:8080
- Swagger: http://127.0.0.1:8080/swagger-ui/index.html
- H2 Console: http://127.0.0.1:8080/h2-console

## Testes

A partir desta pasta (`backend/`):

```powershell
.\mvnw.cmd test
```

## Observações

- Use Java 21.
- Em perfil dev, o H2 é em memória.
- Credenciais de teste, endpoints, regras de status e decisões técnicas estão documentados no README principal.
