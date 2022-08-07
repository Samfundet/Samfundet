Added this directory such that docker-compose can ignore it when mounting the project.
Solves the issue of syncing local sqlite3 database file. It was overriden after Dockerfile COPY.
