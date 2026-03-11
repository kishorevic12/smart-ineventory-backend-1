# Harbor Inventory — Backend (Spring Boot)

Spring Boot REST API for Harbor Inventory.

## Requirements

- Java 17
- Maven

## Run locally

### Option A: VS Code tasks (recommended)

From the VS Code task runner:

- `Backend: Spring Boot (8080)`
- `Backend: Stop (8080)`
- `Backend: Reset DB (delete backend/data)` (only relevant when using a file-based DB)

The backend listens on `http://localhost:8080`.

### Option B: PowerShell script

From the repo root:

```powershell
./backend/run-backend.ps1 -Port 8080
```

Health check:

- `http://localhost:8080/actuator/health`

Stop:

```powershell
./backend/stop-backend.ps1 -Port 8080
```

### Option C: Maven

```powershell
cd backend
mvn spring-boot:run
```

## API

Base path: `http://localhost:8080/api`

Endpoints:

- Items
  - `GET /api/items`
  - `GET /api/items/{id}`
  - `POST /api/items`
  - `PUT /api/items/{id}`
  - `DELETE /api/items/{id}`
  - `POST /api/items/{id}/movements`
- Locations
  - `GET /api/locations`
  - `POST /api/locations`
  - `PUT /api/locations/{id}`
  - `DELETE /api/locations/{id}`
- Movements
  - `GET /api/movements?itemId=&type=&locationId=&limit=100`

## Database

By default, this project is configured to use an **in-memory H2 database** (data resets on each restart).

H2 console:

- `http://localhost:8080/h2-console`

If you want persistence in local dev, set a file-based JDBC URL, for example:

```powershell
$env:SPRING_DATASOURCE_URL = 'jdbc:h2:file:./data/harbor-inventory;AUTO_SERVER=TRUE'
```

Docker Compose (in this repo) already configures a file-based H2 database stored in a named volume.

A PostgreSQL driver is included in the Maven dependencies; switching to Postgres is done by setting standard Spring `spring.datasource.*` properties.

## CORS

CORS is applied to `/api/**`.

- Default behavior is permissive for development (`allowedOriginPatterns("*")`).
- To lock it down, set one of:
  - `app.cors.allowed-origins`
  - `app.cors.allowed-origin-patterns`

## Docker

From the repo root:

```powershell
docker compose up --build
```

- Backend: `http://localhost:8080`
- Health: `http://localhost:8080/actuator/health`

## Challenges faced (and fixes)

### 1) Frontend could not reach backend after deployment

**Problem**: A deployed frontend (Vercel) cannot call `localhost`, so API requests fail if the client is configured for local URLs.

**Fix**:

- Host the backend publicly (Render/Railway/Azure/etc.).
- Configure the frontend to use that backend base URL (for CRA: `REACT_APP_API_BASE_URL=https://<host>/api`).

### 2) CORS errors during local/dev testing

**Problem**: Browser blocked cross-origin requests when frontend and backend were on different origins.

**Fix**:

- CORS is configured on `/api/**` via `app.cors.*` settings.
- For production, lock allowed origins down to your frontend domain.

### 3) Docker port mapping confusion

**Problem**: The backend listens on port **8080** inside the container. If you map a different host port, you must use that host port in your browser/API client.

**Fix**:

- Docker Compose (this repo): backend is exposed as `http://localhost:8080` via `8080:8080`.
- If you run manually with a different host port, use `-p <hostPort>:8080`.

## Deploy to Azure App Service (fixing the “ASP.NET Core Module” error)

If Azure shows errors mentioning **ASP.NET Core Module** / **.NET Hosting Bundle**, that App Service was created for **.NET**.
This repository is **Java (Spring Boot)**, so deploy it using one of the Java-friendly options below.

### Option A (recommended): App Service for Containers (uses this repo’s Dockerfile)

1) Create an App Service on **Linux** with **Docker Container**.
2) Build/push the image (ACR recommended), then configure the Web App to pull that image.
3) In App Service Configuration, set:
  - `WEBSITES_PORT=8080`

Notes:
- The container listens on `${PORT:-8080}` (Azure typically sets `PORT` automatically).
- Health endpoint: `/actuator/health`

### Option B: App Service “Code” (Java 17) + deploy the runnable jar

1) Create an App Service on **Linux** (or Windows) with Runtime stack **Java 17**.
2) Build the jar:

```powershell
mvn -DskipTests clean package
```

3) Deploy `target/app.jar` to the App Service (for example via Zip Deploy, GitHub Actions, or Azure CLI).

If you see `Error: Unable to access jarfile app.jar`, it means Azure is running `java -jar app.jar` but the deployed files do not include `app.jar` at the expected path.
Fix by ensuring `app.jar` is actually deployed to `/home/site/wwwroot/app.jar` and set Startup Command to:

`java -jar /home/site/wwwroot/app.jar`

App settings you may need:
- `PORT` is already supported by the app (`server.port: ${PORT:8080}`), so usually no extra port config is required.
- If you switch from the default in-memory H2 to PostgreSQL, set `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, `SPRING_DATASOURCE_PASSWORD`.

### 4) “Operation violates data integrity constraints” (HTTP 409)

**Problem**: Creating/updating data can fail with a constraint violation (for example, duplicate values where a unique constraint exists).

**Fix**:

- Use unique values (e.g., SKU/code) when creating records.
- If testing repeatedly, reset the database state (in-memory H2 resets on restart; for file-based DB remove the local DB files or Docker volume).

# Screenshots

![Api text]_(https://github.com/kishorevic12/smart-ineventory-backend/blob/main/Screenshot%20(478).png)
![Api text]_(https://github.com/Kishore-Vickram-org/smart-ineventory-backend/blob/main/Screenshot%20(606).png)

# Presentation

[Download Project PPT]_(https://github.com/kishorevic12/smart-ineventory-backend/blob/main/Smart-Harbor-Inventory-System.pptx)

# Backend Link
https://smart-ineventory-backend.onrender.com
