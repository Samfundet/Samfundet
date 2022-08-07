from fnmatch import fnmatchcase

from astroid import FunctionDef, Arguments

from pylint import checkers
from pylint import interfaces
from pylint.lint import PyLinter
from pylint.checkers import utils

# pylint: disable=unused-argument


def no_args():
    """ Checker doesn't complain when no arguments. """


def invalid(_pos_arg):  # pylint: disable=positional-arguments
    """ Checker complains with positional arguments. """


def valid(*, _named_arg):
    """ Checker doesn't complain with named arguments. """


def test_func_whitelist(_pos_arg):
    """ Checker skips function prefixed with 'test_'. """


def check_sig_whitelist(request, _pos_arg):
    """ Checker whitelists entire signature because 'request' is present. """


class NamedArgumentsChecker(checkers.BaseChecker):
    """ Checker to ensure named arguments in function definition. """

    ### Custom config ###

    # list of positional argument names that are allowed to pass this checker.
    ARG_WHITELIST: list[str] = ['self', 'cls']

    # Some functions are used differently, such as views.
    # They usually contain 'request' followed by positional arguments.
    # This set of argument names allows the entire signature to pass if seen.
    SIGNATURE_WHITELIST: list[str] = ['request']

    # Skip checker for function names containing these glob patterns.
    FUNC_WHITELIST: list[str] = [
        '_test_*',
        'test_*',
        'tests_*',
        '_tests_*',
        'fixture_*',  # Ignore our fixture declarations prefixed with 'fixture_' by convention.
        '__*__',  # Ignore magic methods.
    ]
    ### End: Custom config ###

    ### Linter config ###
    __implements__ = interfaces.IAstroidChecker

    name = 'positional-arguments'

    msgs = {
        'W1000': (
            'Positional arguments in function definition.',
            name,
            f'Function signatures should only contain named arguments, except {ARG_WHITELIST}',
        ),
    }
    ### End: Linter config ###

    @utils.check_messages(name)
    def visit_functiondef(self, node: FunctionDef):  # pylint: disable=positional-arguments
        """
        Checks for presence of positional arguments that are not whitelisted.

        Magic function-name recognised by pylint (i.e. do not change).
        This specific name catches all blocks of code where a function/method is declared.
        """

        # Skip check for functions with whitelisted substring names.
        if self._matches(name=node.name, pattern_list=self.FUNC_WHITELIST):
            return

        # Find positional arguments from signature.
        positional_arguments = node.args.args

        # Add pylint message if the node doesn't pass this checker.
        if not self._is_allowed(
            args=positional_arguments,
            whitelist=self.ARG_WHITELIST,
            sig_whitelist=self.SIGNATURE_WHITELIST,
        ):
            self.add_message(self.name, node=node)

    @staticmethod
    def _is_allowed(
        *,
        args: list[Arguments],
        whitelist: list[str],
        sig_whitelist: list[str],
    ) -> bool:
        """ Helper -- check if list of arguments is allowed. """

        for arg in args:
            # Check if positional argument is whitelisted.
            if not NamedArgumentsChecker._matches(name=arg.name, pattern_list=whitelist + sig_whitelist):
                return False

            # Allow signature to pass if certain special arguments are seen.
            if NamedArgumentsChecker._matches(name=arg.name, pattern_list=sig_whitelist):
                return True

        return True

    @staticmethod
    def _matches(*, name: str, pattern_list: list[str]) -> bool:
        """ Helper -- glob search returns if name matches any patterns given. """
        return any(fnmatchcase(name=name, pat=pattern) for pattern in pattern_list)


def register(linter: PyLinter):  # pylint: disable=positional-arguments
    """ Required method to auto register this checker. """
    linter.register_checker(NamedArgumentsChecker(linter))
