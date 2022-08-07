import json
import logging
import datetime
from collections import OrderedDict

LOG = logging.getLogger(__name__)


class JsonFormatter(logging.Formatter):
    """
    Format log messages as json.

    INIT_FIELDS defines all fields to be included from LogRecord if nothing else is specified.
    """

    # --------------------------------------------------------------------
    # Constants:
    # --------------------------------------------------------------------

    # This can be used to differentiate extra fields from default ones.
    DEFAULT_LOG_RECORD_KEYS = {
        # Create dummy LogRecord to find its default fields.
        *logging.LogRecord(
            name='',
            level=logging.INFO,
            pathname='',
            lineno=42,
            msg='foo',
            args=None,
            exc_info=None,
        ).__dict__.keys(),
    }

    # Retrieved from logging.Formatter.
    DEFAULT_FIELDS: list[str] = [
        'name',
        'levelno',
        'levelname',
        'pathname',
        'filename',
        'module',
        'lineno',
        'funcName',
        'created',
        'msecs',
        'relativeCreated',
        'thread',
        'threadName',
        'process',
        'exception',
        'message',
    ]

    # All custom fields must implement _get_<field-name>(self, *, record: logging.LogRecord)
    CUSTOM_FIELDS: list[str] = [
        'time',
        'level',
        'logger_name',
    ]

    ALL_FIELDS = DEFAULT_FIELDS + CUSTOM_FIELDS

    # Chosen from options above.
    INIT_FIELDS: list[str] = [
        'time',
        'level',
        'logger_name',
        'pathname',
        'lineno',
        'funcName',
        'message',
        'exception',
    ]

    DELIMITER = ';'

    def __init__(
        self,
        *args,
        fields: str = None,
        delimiter: str = DELIMITER,
        indent=None,
        **kwargs,
    ):
        """
        Example:
        ```python
        JsonFormatter(
            fields='name; funcName; time',
            delimiter=';',
            indent=4,
        )
        ```
        """

        # Let parent use default parameters, they are not relevant to this custom class.
        super().__init__(*args, **kwargs)

        self.indent = indent

        # Let user specify default fields to include.
        self.fields: list[str]
        if fields is None:
            self.fields = self.INIT_FIELDS
        else:
            # Transform string into list of unique fields.
            self.fields = list(set(fields.replace(' ', '').split(delimiter)))

        # Ensure provided fields exist in LogRecord.
        if not self._is_valid_fields(fields=self.fields):
            raise Exception(f'Invalid fields, must be one of {self.ALL_FIELDS}.')

    # --------------------------------------------------------------------
    # Item getters:
    # --------------------------------------------------------------------

    def _get_record_items(self, *, record: logging.LogRecord) -> dict[str, any]:
        """ Wrapper function to get specified default fields and all extra fields from LogRecord. """
        record_items = OrderedDict({k: v for k, v in record.__dict__.items() if k in self.fields})
        # Need to manually input message because the record field is named 'msg' and will not be
        # recognized as part any option in self.fields.
        if 'message' in self.fields:
            record_items['message'] = record.getMessage()
        if 'exception' in self.fields and record.exc_info is not None:
            record_items['exception'] = self.formatException(record.exc_info)

        return record_items

    def _get_custom_items(self, *, record: logging.LogRecord) -> dict[str, any]:
        """ Wrapper function to get custom implemented fields. """
        custom_fields = OrderedDict()
        # Call the getter for each specified customised field.
        for field in self.fields:
            if field in self.CUSTOM_FIELDS:
                custom_fields[field] = getattr(self, f'_get_{field}')(record=record)
        return custom_fields

    def _get_extra_items(self, *, record: logging.LogRecord) -> dict[str, any]:
        """ Wrapper function to get extra fields. """
        # Call str() on each field.
        # We do this because the input is unknown and may not be serializable, causing errors.
        # Calling str() returns the string representation of any object.
        extra_items = OrderedDict({k: str(v) for k, v in record.__dict__.items() if k not in self.DEFAULT_LOG_RECORD_KEYS})
        return extra_items

    # --------------------------------------------------------------------
    # Validation helpers:
    # --------------------------------------------------------------------

    def _is_valid_fields(self, *, fields: list[str]) -> bool:
        """ Check if specified fields are all possible options, i.e. custom or default fields. """
        return all(field in self.ALL_FIELDS for field in fields)

    # --------------------------------------------------------------------
    # Custom field getters:
    # --------------------------------------------------------------------

    def _get_time(self, *, record: logging.LogRecord):
        return datetime.datetime.fromtimestamp(
            record.created,
            tz=datetime.timezone.utc,
        ).isoformat(timespec='microseconds')

    def _get_logger_name(self, *, record: logging.LogRecord):
        return record.name

    def _get_level(self, *, record: logging.LogRecord):
        return record.levelname

    # --------------------------------------------------------------------
    # Main responsibility of the formatter:
    # --------------------------------------------------------------------

    def format(self, record: logging.LogRecord) -> str:
        """ Override with custom json formatting. """
        # pylint: disable=positional-arguments

        # Prepend custom fields.
        # NOTE: Custom fields will be overwritten by any collision with default and extra fields.
        msg = OrderedDict()
        msg.update(self._get_custom_items(record=record))
        msg.update(self._get_extra_items(record=record))
        msg.update(self._get_record_items(record=record))

        try:
            data = json.dumps(msg, indent=self.indent)
        except TypeError:
            # Fall back to default if serialization error.
            data = super().format(record=record)
        return data


# pylint: disable=logging-too-many-args
#
# Run this file for quick testing.
#
def main() -> None:
    handler = logging.StreamHandler()

    handler.setFormatter(JsonFormatter(fields='name, time, message, levelno', delimiter=',', indent=4))
    # handler.setFormatter(JsonFormatter(indent=4))
    # handler.setFormatter(JsonFormatter())

    logging.basicConfig(handlers=[handler], level=logging.DEBUG)

    logging.info('Hello!', extra={'foo': 'bar'})
    logging.info('Hello! %s', 1, extra={'foo': 'bar'})
    try:
        d = {}
        # Trigger exception.
        print(d['a'])
    except Exception:  # pylint: disable=broad-except
        logging.exception('oops')


if __name__ == '__main__':
    main()
