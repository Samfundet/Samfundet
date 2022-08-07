#!/bin/sh
set -e

python -m pipenv run python manage.py collectstatic --noinput
python -m pipenv run python manage.py makemigrations
python -m pipenv run python manage.py migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
