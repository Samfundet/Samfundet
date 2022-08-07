import logging
import secrets
from contextvars import ContextVar

from django.http import HttpRequest, HttpResponse

LOG = logging.getLogger(__name__)

# This token can be imported anywhere to retrieve the values.
request_contextvar: ContextVar = ContextVar('request_contextvar', default=None)


def remote_address_middleware(get_response):
    # pylint: disable=positional-arguments

    def remote_address_middleware_impl(request):
        if 'HTTP_X_REAL_IP' in request.META:
            request.META['REMOTE_ADDR'] = request.META['HTTP_X_REAL_IP']
        return get_response(request)

    return remote_address_middleware_impl


class RequestLogMiddleware:
    """Request Logging Middleware."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request: HttpRequest):
        """ Log request/response context before and after processing. """

        request.request_id = request.headers.get('X-Request-ID', f'local-{secrets.token_hex(16)}')

        # Add request to context.
        # Make the current request available in a ContextVar.
        # This ContextVar is used by `RequestContextFilter` to attach request information to all log messages.
        request_token = request_contextvar.set(request)

        try:
            # Request passes on to controller.
            LOG.info('Processing HTTP request')
            response: HttpResponse = self.get_response(request)
            LOG.info('Processing HTTP request complete', extra={'status_code': response.status_code})
        finally:
            # Cleanup context.
            request_contextvar.reset(request_token)

        return response

    def process_exception(self, request, exception):
        """Log unhandled exceptions."""

        LOG.error('Unhandled exception while processing request', exc_info=exception)
