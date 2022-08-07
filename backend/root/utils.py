from django.utils import timezone

# pylint: disable=positional-arguments


def get_current_term():
    terms = [(1, 'V'), (2, 'H')]
    t = terms[0] if timezone.now().month < 7 else terms[1]
    return (timezone.now().year * 10 + t[0], t[1] + str(timezone.now().year))


def create_url_param(params: dict) -> str:
    """
        Creates a string from a dict, which can be used as urlparameters, for simple queries
        example = {
            'search':'hi'
            'sort':'ascending'
        }
        becomes: search=hi&sort=ascending&
    """
    if len(params) > 0:
        return '&'.join([f'{param_name}={value}' for param_name, value in params.items()])
    return ''
