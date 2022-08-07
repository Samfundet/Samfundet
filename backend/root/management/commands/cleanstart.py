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

    def handle(self, *args, **options):
        management.call_command('deploymigrations', interactive=options['interactive'])
        management.call_command('flush', interactive=options['interactive'])
        management.call_command('collectstatic', interactive=options['interactive'])
