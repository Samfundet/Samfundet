# imports
import os

from backend.root.constants import Environment
from .base import *  # pylint: disable=wildcard-import, unused-wildcard-import
# End: imports -----------------------------------------------------

ALLOWED_HOSTS = [os.environ['DOMAIN']]

SECRET_KEY = os.environ['SECRET_KEY']
DEBUG = False

# Ensure correct ENV
ENV = Environment.PROD

# Security
X_FRAME_OPTIONS = 'DENY'
CSRF_COOKIE_SECURE = True
SECURE_HSTS_SECONDS = 60  # TODO: Find a decent value
SECURE_SSL_REDIRECT = True
SECURE_HSTS_PRELOAD = True
SESSION_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_INCLUDE_SUBDOMAINS = True

DATABASES = {
    'default':
        {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': os.environ['DB_NAME'],
            'USER': os.environ['DB_USER'],
            'PASSWORD': os.environ['DB_PASSWORD'],
            'HOST': os.environ['DB_HOST'],
            'PORT': os.environ['DB_PORT'],
        }
}
