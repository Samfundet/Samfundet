from __future__ import annotations

import logging

from django.http import HttpRequest

from backend.root.middlewares import request_contextvar

LOG = logging.getLogger(__name__)


class RequestContextFilter(logging.Filter):
    """Filter to inject request/response context to each log message.

    NOTE:
    Not a typical Filter because no messages are actually filtered.
    The purpose of this class is to simply retrieve context vars and feed them into every log message.
    """

    def filter(self, record: logging.LogRecord) -> bool:
        # pylint: disable=positional-arguments

        # NOTE: Each field is added as an attribute to the record and will thus be
        # interpreted as an 'extra'-field in the JsonFormatter this filter is hooked to.

        ### Add request-fields to the record. ###
        request_obj: HttpRequest = request_contextvar.get()

        if request_obj is None:
            # We are not currently in a request, so we cannot attach any request information to the log message.
            return True

        user = getattr(request_obj, 'user', None)
        if user:
            record.username = user.username

        client_ip: str = request_obj.META.get('REMOTE_ADDR')
        if client_ip:
            record.client_ip = client_ip

        record.request_id = request_obj.request_id
        record.request_method = request_obj.method
        record.request_path = request_obj.path

        return True
