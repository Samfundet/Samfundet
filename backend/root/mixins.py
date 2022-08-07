import sys
import copy
import logging

from django.db.models import DEFERRED, Model

LOG = logging.getLogger(__name__)


class FieldTrackerMixin(Model):
    """
    Mixin to cache specific fields when fetching from database.
    Attributes are prefixed with `ftm_` to mitigate name collisions.

    Optimised way of chaching the loaded values of db-fields after fetched model-instances are changed in Python.

    To enable this mixin, one must set the attribute `ftm_track_fields`.
    `ftm_track_fields` is a list of strings which specifies the names of relevant fields.

    Example usage:
    ```python
    class Person(FieldTrackerMixin, models.Model):
        age = models.IntegerField()

        ftm_track_fields = ['age']
        # or
        ftm_track_fields = '__all__' to track all fields.

        def save(self, *args, **kwargs):
            # List of fields this mixin is tracking.
            tracked_fields = gself.ftm_get_tracked_fields()
            # Get access to original values of fields (even if they have changed).
            loaded_values = gself.ftm_get_loaded_fields()
            # Get dirty fields.
            dirty_fields_old, dirty_fields_new = self.ftm_get_dirty_fields()
    ```
    """

    # pylint: disable=protected-access

    _FTM_TRACK_FIELDS_NAME = 'ftm_track_fields'  # Not private because developer should set this manually.
    _FTM_LOADED_FIELDS_NAME = '_ftm_loaded_fields'

    _FTM_FIELD_BLACKLIST = ['password']

    # Resources:
    # https://stackoverflow.com/a/64116052/12616507
    # https://docs.djangoproject.com/en/4.1/ref/models/instances/#customizing-model-loading

    class Meta:
        abstract = True

    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        if not hasattr(self, self._FTM_TRACK_FIELDS_NAME):
            raise Exception(f"Missing field '{self._FTM_TRACK_FIELDS_NAME}' : list[str]'")

        # Shorthand select all fields.
        if self.ftm_get_tracked_fields() == '__all__':
            # Fetch field_names from meta.
            track_fields = [field.attname for field in self._meta.fields if field.attname not in self._FTM_FIELD_BLACKLIST]
            setattr(self, self._FTM_TRACK_FIELDS_NAME, track_fields)

    @staticmethod
    def ftm_log_parse(*, fields: dict) -> dict:
        """
        Preprocesses fieldsets before logging.
        Need to limit large output. E.g. logo changes generates a large log.
        """
        # Deep copy to not mutate original.
        fields_copy = copy.deepcopy(fields)

        for field, item in fields_copy.items():
            try:
                if sys.getsizeof(str(item)) > 1000:
                    fields_copy[field] = 'Too large to display'
            except TypeError:
                fields_copy[field] = "Omitted, FieldTrackerMixin couldn't determine size."
        return fields_copy

    def ftm_get_tracked_fields(self):
        """Returns a list of all field names this mixin tracks."""
        return getattr(self, self._FTM_TRACK_FIELDS_NAME, [])

    def ftm_get_loaded_fields(self):
        """Returns the cached tracked values currently on the instance."""
        return getattr(self, self._FTM_LOADED_FIELDS_NAME, {})

    def ftm_get_dirty_fields(self) -> dict:
        """Detects all changes, return old and new states."""
        if not self.pk:
            return {}, {}  # No dirty fields on creation.

        # Get tracked and loaded fields.
        track_fields: list[str] = self.ftm_get_tracked_fields()
        loaded_fields: dict = self.ftm_get_loaded_fields()

        # Loop tracked field and keep fields that have changed.
        dirty_fields_old = {}
        dirty_fields_new = {}
        for field in track_fields:
            current_value = getattr(self, field)
            loaded_value = loaded_fields.get(field)
            if current_value != loaded_value:
                dirty_fields_old[field] = loaded_value
                dirty_fields_new[field] = current_value

        return dirty_fields_old, dirty_fields_new

    def save(self, *args, **kwargs):
        """Extends django 'save' to log all changes."""

        # Ensure changes are logged when attempting to save.
        try:
            is_creation = self.pk is None  # Store value before saving because id exists afterwards.
            super().save(*args, **kwargs)

            # Get all changes.
            dirty_fields_old, dirty_fields_new = self.ftm_get_dirty_fields()  # includes id after save.

            # Update loaded_fields after save.
            loaded_fields = self.ftm_get_loaded_fields()
            loaded_fields.update(dirty_fields_new)
            setattr(self, self._FTM_LOADED_FIELDS_NAME, loaded_fields)

            # Log creation or update.
            if is_creation:  # Log creation.
                LOG.info(f'{self} was created:\n\nfields: {dirty_fields_new}')
                LOG.info(f'{self} was created:\n\nfields: {self.ftm_log_parse(fields=dirty_fields_new)}')
            elif dirty_fields_new == {}:  # Log save, notify no detection of new fields.
                LOG.info(f"{self} was saved.\nFieldTrackerMixin couldn't detect any changes to tracked fields.")
            else:  # Log changes.
                LOG.info(f'{self} has changed:\n\nold: {dirty_fields_old}\n\n new:{dirty_fields_new}')
                LOG.info(
                    f'{self} has changed:\n\n'
                    f'old: {self.ftm_log_parse(fields=dirty_fields_old)}\n\n'
                    f'new:{self.ftm_log_parse(fields=dirty_fields_new)}'
                )
        except Exception as e:  # pylint: disable=broad-except
            # Get all changes.
            dirty_fields_old, dirty_fields_new = self.ftm_get_dirty_fields()
            LOG.info(f'{self} failed attempting to save:\n\nold: {dirty_fields_old}\n\nnew: {dirty_fields_new}')
            LOG.info(
                f'{self} failed attempting to save:\n\n'
                f'old: {self.ftm_log_parse(fields=dirty_fields_old)}\n\n'
                f'new: {self.ftm_log_parse(fields=dirty_fields_new)}'
            )
            raise e

    @classmethod
    def from_db(cls, db, field_names, values):
        """Extends django 'from_db' to set 'loaded_fields'."""
        # pylint: disable=positional-arguments # builtin django.model method

        instance = super().from_db(db, field_names, values)

        track_fields: list[str] = instance.ftm_get_tracked_fields()

        loaded_fields = {field: value for field, value in zip(field_names, values) if field in track_fields and value is not DEFERRED}

        # Set loaded_fields on instance.
        setattr(instance, instance._FTM_LOADED_FIELDS_NAME, loaded_fields)

        return instance
