# imports
import os

from backend.root.constants import Environment
from .base import *  # pylint: disable=wildcard-import,unused-wildcard-import
# End: imports -----------------------------------------------------

ALLOWED_HOSTS = ['127.0.0.1', 'localhost']
if os.environ.get('DOMAIN'):
    ALLOWED_HOSTS.append(os.environ.get('DOMAIN'))

SECRET_KEY = os.environ['SECRET_KEY']
DEBUG = True

# Ensure correct ENV
ENV = Environment.DEV

# Security
X_FRAME_OPTIONS = 'SAMEORIGIN'
CSRF_COOKIE_SECURE = False
SECURE_HSTS_SECONDS = 0
SECURE_SSL_REDIRECT = False
SECURE_HSTS_PRELOAD = False
SESSION_COOKIE_SECURE = False
SECURE_BROWSER_XSS_FILTER = False
SECURE_CONTENT_TYPE_NOSNIFF = False
SECURE_HSTS_INCLUDE_SUBDOMAINS = False

# Database
# https://docs.djangoproject.com/en/3.2/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'database' / 'db.sqlite3',
    }
}
