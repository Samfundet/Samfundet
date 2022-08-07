# imports
from django.db import IntegrityError, OperationalError, ProgrammingError
from django.conf import settings
from django.apps import AppConfig
from django.core import management
from django.core.management.base import CommandError

from backend.root.constants import Environment
# End: imports -----------------------------------------------------------------


class AccountsConfig(AppConfig):
    name = 'backend.accounts'

    def ready(self):
        import backend.accounts.signals  # pylint: disable=import-outside-toplevel,unused-import

        if settings.ENV == Environment.DEV:
            try:
                # Define credentials in '.env'.
                management.call_command('createsuperuser', interactive=False)
            except (CommandError, OperationalError, ValueError, ProgrammingError, IntegrityError) as e:
                print(f'==> {__file__}: {e}')
                # Multiple calls of 'createsuperuser' will raise exception because the username is already taken.
                # Error is raised if database doesn't exist.
