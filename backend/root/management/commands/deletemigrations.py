# imports
import os
import glob
import shutil

from django.conf import settings
from django.core.management.base import BaseCommand
# End: imports -----------------------------------------------------------------

# pylint: disable=positional-arguments


class Command(BaseCommand):

    def add_arguments(self, parser):
        parser.add_argument(
            '--noinput',
            '--no-input',
            action='store_false',
            dest='interactive',
            help='Tells Django to NOT prompt the user for input of any kind.',
        )

    def confirmation(self):
        answer = None
        yes = ['yes', 'y']
        no = ['no', 'n']
        print('== This command will:')
        print('\t 1. Delete all migration files.')

        print('\n== Are you sure? DOUBLE-CHECK that this is not production server ==')

        while answer not in yes + no:
            answer = input("Type 'y(es)' or 'n(o)': ").lower()

        return answer in yes

    def handle(self, *args, **options):
        """ Delete all migration files for each installed app """

        if options['interactive']:
            if not self.confirmation():
                print('== ABORT ==')
                return

        for app in settings.INSTALLED_APPS:
            try:
                path = app.replace('.', '/')
                migrations = f'{path}/migrations'
                app_migrations = glob.glob(f'{migrations}/[0-9]*')

                for f in app_migrations:
                    os.remove(f)
                    print(f'Removed {f}')

                pycache = f'{migrations}/__pycache__'
                shutil.rmtree(pycache)
                print(f'Removed {pycache}')

            except Exception as _e:  # pylint: disable=broad-except
                pass
                # print(f'{app} failed. {_e}')
