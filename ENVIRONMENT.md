# Environment variables (single source of truth)

This Spring Boot backend reads configuration from **environment variables** (recommended for Azure) and/or from `application.yml` defaults.

## Using a single `.env` file (local development)

This project supports loading a `.env` file automatically at startup.

- Template: `.env.example`
- Your file: `.env` (already gitignored)

Notes:
- `.env` is intended for **local development**.
- On Azure App Service, prefer setting values in **Configuration → Application settings** (unless you intentionally deploy a `.env` file to the server).

## Required (Azure/App Service)

### `PORT`
- What: HTTP port the server binds to.
- Default: `8080`
- Where read: `server.port: ${PORT:8080}` in `src/main/resources/application.yml`.

## Database

By default the app uses **in-memory H2**:
- `spring.datasource.url=jdbc:h2:mem:testdb`
- `spring.datasource.username=sa`
- `spring.datasource.password=` (empty)

To use PostgreSQL (typical in Azure), set:

### `SPRING_DATASOURCE_URL`
- Example: `jdbc:postgresql://<host>:5432/<db>`

### `SPRING_DATASOURCE_USERNAME`
- Example: `postgres`

### `SPRING_DATASOURCE_PASSWORD`
- Example: `yourStrongPassword`

## JPA / Hibernate

### `SPRING_JPA_HIBERNATE_DDL_AUTO`
- What: Schema strategy.
- Default in repo: `update` (set in `application.yml`).
- Common values: `validate`, `update`, `create`, `create-drop`.

## CORS

CORS is applied to `/api/**`.

### `APP_CORS_ALLOWED_ORIGINS`
- What: Exact allowed origins.
- Format: comma-separated list.
- Example: `https://your-frontend.example,https://www.your-frontend.example`

### `APP_CORS_ALLOWED_ORIGIN_PATTERNS`
- What: Pattern-based allowed origins.
- Format: comma-separated list.
- Example: `https://*.example.com`

## Where to set env vars

### Azure App Service
- Azure Portal → Your App Service → Configuration → Application settings → New application setting.
- Save → Restart.

### Local PowerShell (current terminal only)
```powershell
$env:PORT = 8080
$env:SPRING_DATASOURCE_URL = 'jdbc:postgresql://localhost:5432/inventory'
$env:SPRING_DATASOURCE_USERNAME = 'postgres'
$env:SPRING_DATASOURCE_PASSWORD = 'postgres'
```
