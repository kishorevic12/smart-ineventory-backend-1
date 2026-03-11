FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /workspace

# Cache dependencies
COPY pom.xml ./
RUN mvn -q -DskipTests dependency:go-offline

# Build
COPY src ./src
RUN mvn -q -DskipTests clean package \
	&& ls -1t target/*.jar \
		| grep -v '\\.jar\\.original$' \
		| grep -v 'plain\\.jar$' \
		| head -n 1 \
		| xargs -I{} cp {} /workspace/app.jar

FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /workspace/app.jar /app/app.jar

EXPOSE 8080

# Healthcheck uses Actuator (already included in this project).
# Install curl for a lightweight, reliable check.
RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl \
	&& rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=10s --timeout=3s --retries=12 CMD \
	curl -fsS http://127.0.0.1:${PORT:-8080}/actuator/health | grep -q '"status"\s*:\s*"UP"' || exit 1

ENTRYPOINT ["sh","-c","java -jar /app/app.jar --server.port=${PORT:-8080}"]
