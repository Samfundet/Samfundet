# imports
from django.conf import settings
from django.core import management
from django.core.management.base import BaseCommand
# End: imports -----------------------------------------------------------------


class Command(BaseCommand):

    def handle(self, *args, **options):

        for app in settings.INSTALLED_APPS:

            appname = app.split('.')[-1]

            try:
                management.call_command('makemigrations', appname)

            except Exception as _e:  # pylint: disable=broad-except
                # pass
                print(f'{app} failed. {_e}')
