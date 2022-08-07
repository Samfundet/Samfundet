# imports
from django import forms
from django.db import models
from django.conf import settings
from django.http import HttpRequest
from django.utils import timezone
from django.contrib import admin
from django.db.models import FileField, IntegerField
from django.utils.translation import gettext_lazy as _
from django.template.defaultfilters import filesizeformat

from backend.root import utils as root_utils
from backend.root.mixins import FieldTrackerMixin

# End: imports -----------------------------------------------------------------

# pylint: disable=positional-arguments


# https://github.com/django/django/blob/master/django/forms/models.py
class CustomModelForm(forms.ModelForm):

    def save(self, commit: bool = True, *args, **kwargs):
        # pylint: disable=keyword-arg-before-vararg
        # pylint: disable=protected-access
        """
        Override django ModelForm.save() to implement kwargs. Do not use super() in this class!
        Changes: user arg is added

        Source __doc__:
        Save this form's self.instance object if commit=True. Otherwise, add
        a save_m2m() method to the form which can be called after the instance
        is saved manually at a later time. Return the model instance.
        """
        # pylint: disable=consider-using-f-string
        if self.errors:
            raise ValueError(
                "The %s could not be %s because the data didn't validate." % (
                    self.instance._meta.object_name,
                    'created' if self.instance._state.adding else 'changed',
                )
            )
        if commit:
            # If committing, save the instance and the m2m data immediately.
            self.instance.save(*args, **kwargs)  # <--- This is the only difference
            self._save_m2m()
        else:
            # If not committing, add a method to the form to allow deferred
            # saving of m2m data.

            self.save_m2m = self._save_m2m  # pylint: disable=attribute-defined-outside-init
        return self.instance


class CustomBaseAdmin(admin.ModelAdmin):
    readonly_fields = ['creator', 'created', 'last_edited', 'last_editor']

    # list_display = []
    # ordering = []
    # list_filter = []
    # filter_horizontal = []
    # search_fields = []

    def save_model(self, request: HttpRequest, obj, form, change):
        try:
            if not change:
                obj.creator = request.user
                obj.created = timezone.now()
            obj.last_editor = request.user
            obj.last_edited = timezone.now()
        except Exception as _e:  # pylint: disable=broad-except
            pass

        return super().save_model(request, obj, form, change)


class CustomBaseModel(FieldTrackerMixin, models.Model):
    last_editor = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        editable=False,
        related_name='editor_%(class)s_set',
        verbose_name='Sist redigert av'
    )
    last_edited = models.DateTimeField(null=True, blank=True, editable=False, verbose_name='Sist redigert')
    creator = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        editable=False,
        related_name='creator_%(class)s_set',
        verbose_name='Opprettet av'
    )
    created = models.DateTimeField(null=True, blank=True, editable=False, verbose_name='Opprettet')

    # FieldTrackerMixin:
    ftm_track_fields = '__all__'

    class Meta:
        abstract = True

    def is_edited(self):
        return self.created != self.last_edited

    def clean(self, *args, **kwargs):
        pass

    def save(self, *args, **kwargs):
        self.clean()
        user = kwargs.pop('user', None)  # Must pop because super().save() doesn't accept user
        if not self.id:
            self.created = timezone.now()
            if user:
                self.creator = user
        self.last_edited = timezone.now()
        if user:
            self.last_editor = user

        super().save(*args, **kwargs)


class ContentTypeRestrictedFileField(FileField):
    """
    Same as FileField, but you can specify:
        * content_types - list containing allowed content_types. Example: ['application/pdf', 'image/jpeg']
        * max_upload_size - a number indicating the maximum file size allowed for upload.
            2.5MB - 2621440
            5MB - 5242880
            10MB - 10485760
            20MB - 20971520
            50MB - 5242880
            100MB 104857600
            250MB - 214958080
            500MB - 429916160
    """

    def __init__(self, content_types=None, max_upload_size: int = 5242880, *args, **kwargs):
        # pylint: disable=keyword-arg-before-vararg

        super().__init__(*args, **kwargs)
        self.content_types = content_types
        self.max_upload_size = max_upload_size

    def clean(self, *args, **kwargs):
        data = super().clean(*args, **kwargs)

        file_ = data.file
        try:
            content_type = file_.content_type
            if content_type in self.content_types:
                # pylint: disable=protected-access
                if file_._size > self.max_upload_size:
                    raise forms.ValidationError(
                        _('Hold filestørrelsen under %s. Nåværende filstørrelse %s') % (filesizeformat(self.max_upload_size), filesizeformat(file_._size))
                    )
            else:
                raise forms.ValidationError(_('Filetype ikke støttet.'))
        except AttributeError:
            pass

        return data


class WeekDayField(IntegerField):

    class Day(models.IntegerChoices):
        MON = 0, 'Mandag'
        TUE = 1, 'Tirsdag'
        WED = 2, 'Onsdag'
        THU = 3, 'Torsdag'
        FRI = 4, 'Fredag'
        SAT = 5, 'Lørdag'
        SUN = 6, 'Søndag'

    def __init__(self, *args, **kwargs):
        kwargs['choices'] = WeekDayField.Day.choices
        super().__init__(*args, **kwargs)

    def clean(self, *args, **kwargs):
        data = super().clean(*args, **kwargs)
        try:
            if data and (WeekDayField.Day.MON.value > data > WeekDayField.Day.SUN.value):
                raise forms.ValidationError(_('Ikke eksisterende '))
        except AttributeError:
            pass
        return data


class TermField(IntegerField):
    terms = [(1, 'V'), (2, 'H')]

    def __init__(self, *args, **kwargs):
        kwargs['choices'] = self.possible_choices()
        kwargs['default'] = root_utils.get_current_term()[0]
        super().__init__(*args, **kwargs)

    def possible_choices(self):
        choices = []
        for year in reversed(range(2010, timezone.now().year + 5)):
            for t in self.terms:
                choices.append((year * 10 + t[0], t[1] + str(year)))
        return choices
