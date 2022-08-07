# imports
from django.core import management
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
        print("\t 1. Call command 'migratezero'.")
        print("\t 2. Call command 'deletemigrations'.")
        print("\t 3. Call command 'setupmigrations2'.")
        print("\t 4. Call command 'makemigrations'.")
        print("\t 5. Call command 'migrate'.")

        print('\n== Are you sure? DOUBLE-CHECK that this is not production server ==')

        while answer not in yes + no:
            answer = input("Type 'y(es)' or 'n(o)': ").lower()

        return answer in yes

    def handle(self, *args, **options):

        if options['interactive']:
            if not self.confirmation():
                print('== ABORT ==')
                return

        management.call_command('migratezero', interactive=options['interactive'])
        management.call_command('deletemigrations', interactive=options['interactive'])
        management.call_command('setupmigrations2')
        management.call_command('makemigrations')
        management.call_command('migrate')
