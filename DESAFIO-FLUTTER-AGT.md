# Desafio Técnico — Desenvolvedor Mobile Flutter
**Empresa:** AGT  
**Prazo:** até **11/05/2026**  
**Entrega:** repositório Git público (GitHub ou GitLab)

---

## Contexto

Você irá desenvolver um aplicativo mobile de **Controle de Viagens Corporativas**.

O app permite que colaboradores registrem, acompanhem e atualizem o status de suas viagens a trabalho. Um backend Spring Boot já está disponível e será fornecido junto a este desafio. Parte da lógica de negócio ainda precisa ser implementada por você no backend, e o aplicativo Flutter deve ser construído do zero.

---

## O Que Você Vai Construir

### 1. Backend — Spring Boot (fornecido como scaffold)

**Pré-requisitos para rodar o backend:**
- Java 21+
- Maven 3.9+

O projeto Spring Boot já possui:
- Autenticação com **JWT + Refresh Token** implementada e funcional
- Entidade `Viagem` com todos os campos e enum de status
- Banco de dados **H2** em memória (sem instalação necessária)
- Endpoints de dados de referência prontos para consumo
- Usuário de teste seedado

**Você precisa implementar os seguintes endpoints:**

#### `GET /viagens`
- Requer autenticação (Bearer token)
- Retorna a lista de viagens do usuário autenticado
- Ordenadas pela data de criação (mais recentes primeiro)

#### `POST /viagens`
- Requer autenticação
- Cria uma nova viagem com status inicial `AGENDADA`
- Campos obrigatórios: `destino`, `dataIda`, `dataVolta`, `finalidade`, `transporte`
- Campo opcional: `observacoes`
- Retorna `201 Created` com o objeto criado
- Retorna `400 Bad Request` se campos obrigatórios estiverem ausentes

#### `PATCH /viagens/{id}/status`
- Requer autenticação
- Atualiza o status da viagem respeitando as **regras de transição** abaixo
- Retorna `200 OK` com o objeto atualizado
- Retorna `422 Unprocessable Entity` com mensagem descritiva se a transição for inválida
- Retorna `404 Not Found` se a viagem não existir ou não pertencer ao usuário autenticado

**Regras de transição de status:**

| Status atual | Pode ir para |
|---|---|
| `AGENDADA` | `EM_ANDAMENTO`, `CANCELADA` |
| `EM_ANDAMENTO` | `CONCLUIDA`, `CANCELADA` |
| `CONCLUIDA` | nenhum (status terminal) |
| `CANCELADA` | nenhum (status terminal) |

Qualquer outra transição deve ser rejeitada com `422`.

---

### 2. App Flutter — do zero

Construa o aplicativo mobile consumindo o backend acima.  
A URL base local é `http://10.0.2.2:8080` (emulador Android) ou `http://localhost:8080` (iOS Simulator).

#### Tela de Login
- Campos: usuário e senha
- Consome `POST /auth/login`
- Armazena o `accessToken` e `refreshToken` de forma segura
- Redireciona para a lista após login bem-sucedido
- Exibe mensagem de erro em caso de credenciais inválidas

#### Lista de Viagens
- Consome `GET /viagens`
- Exibe: destino, data de ida, data de volta, status com indicador visual (cor ou ícone)
- Estado de loading durante a requisição
- Estado vazio quando não há viagens
- Estado de erro com opção de retry em caso de falha de rede
- Botão para navegar ao formulário de nova viagem

#### Detalhe da Viagem
- Exibe todos os campos da viagem
- Exibe os **botões de ação condicionais ao status atual:**
  - `AGENDADA`: botões "Iniciar Viagem" e "Cancelar"
  - `EM_ANDAMENTO`: botões "Concluir" e "Cancelar"
  - `CONCLUIDA` / `CANCELADA`: nenhum botão de ação
- Consome `PATCH /viagens/{id}/status` ao acionar um botão
- Atualiza a UI após a resposta do servidor

#### Formulário de Nova Viagem
- Campo texto: Destino
- Date picker: Data de ida e Data de volta
- Dropdown **Finalidade** — populado via `GET /dominios/finalidades`
- Dropdown **Transporte** — populado via `GET /dominios/transportes`
- Campo texto opcional: Observações
- Validação dos campos obrigatórios antes de submeter
- Consome `POST /viagens` ao confirmar
- Retorna à lista após criação bem-sucedida

---

## Contrato da API

### Autenticação

**`POST /auth/login`**
```json
// Request
{ "username": "usuario.teste", "password": "senha123" }

// Response 200
{ "tokenType": "Bearer", "accessToken": "...", "refreshToken": "...", "expiresIn": 3600 }
```

**`POST /auth/refresh`**
```json
// Request
{ "refreshToken": "..." }

// Response 200
{ "tokenType": "Bearer", "accessToken": "...", "expiresIn": 3600 }
```

### Dados de Domínio

**`GET /dominios/finalidades`** → `["Visita Técnica", "Reunião", "Treinamento", "Entrega", "Outro"]`

**`GET /dominios/transportes`** → `["Carro Próprio", "Carro da Empresa", "Aéreo", "Ônibus"]`

### Modelo Viagem

```json
{
  "id": 1,
  "destino": "São Paulo - SP",
  "dataIda": "2026-05-10",
  "dataVolta": "2026-05-12",
  "finalidade": "Reunião",
  "transporte": "Aéreo",
  "observacoes": "Levar apresentação",
  "status": "AGENDADA",
  "criadoEm": "2026-04-29T10:00:00"
}
```

---

## Requisitos Técnicos

- Flutter estável (3.x+) com Dart null safety
- Gerenciamento de estado (BLoC, Provider, Riverpod ou GetX)
- Consumo de API REST com `http` ou `dio`
- Separação de camadas (UI / lógica / dados)
- Tratamento de erros de rede e respostas de erro da API

---

## Forma de Entrega

- Repositório Git público com **backend e app em pastas separadas** (`/backend` e `/app`)
- `README.md` na raiz com instruções de como rodar cada projeto
- Enviar o link do repositório por e-mail até **11/05/2026**

---

## Credencial de Teste

| Campo    | Valor           |
|----------|-----------------|
| username | `usuario.teste` |
| password | `senha123`      |

---

> Prefira entregar um MVP funcional com código limpo a uma solução incompleta com muitos recursos. Clareza nas decisões de arquitetura conta tanto quanto funcionalidade.
