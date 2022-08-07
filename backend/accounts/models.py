# imports
from __future__ import annotations

from django.db import models
from django.utils import timezone
from django.contrib.auth import models as auth_models
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.models import PermissionsMixin

from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager

from backend.root.mixins import FieldTrackerMixin
# End: imports -----------------------------------------------------------------

# pylint: disable=positional-arguments


class UserManager(BaseUserManager):
    use_in_migrations = True

    def create_user(self, username, password=None, **kwargs) -> User:
        if not username:
            raise ValueError('Users must have an username')
        user: User = self.model(username=username, **kwargs)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, password, **kwargs):
        user = self.create_user(username=username, password=password, **kwargs)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user


class User(FieldTrackerMixin, PermissionsMixin, AbstractBaseUser):

    # Basic Information
    username = models.CharField(max_length=30, unique=True, null=False, verbose_name='brukernavn')
    email = models.EmailField(max_length=64, unique=True, null=True, blank=True)
    first_name = models.CharField(max_length=30, null=True, blank=False, verbose_name='Fornavn')
    last_name = models.CharField(max_length=30, null=True, blank=False, verbose_name='Etternavn')
    # Status
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_pang = models.BooleanField(default=False, verbose_name='Inaktiv Pang')
    is_superuser = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now, blank=True, editable=False, verbose_name='Opprettet')

    phone_number = models.CharField(max_length=13, default=None, null=True, blank=True, verbose_name='Mobilnummer')

    objects = auth_models.UserManager()

    # start3
    id_card = models.CharField(max_length=254, default=None, null=True, verbose_name='Internkortnummer')

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email']  # Fields populated automatically with env and createsuperuser.

    # FieldTrackerMixin:
    ftm_track_fields = '__all__'

    class Meta:
        verbose_name = 'user'
        verbose_name_plural = 'users'
        ordering = ['username']

    def __str__(self):
        return f'{self.get_full_name() or self.username or self.email or self.id}'

    def get_full_name(self):
        if self.first_name and self.last_name:
            return f'{self.first_name} {self.last_name}'
        return None

    def get_username(self):
        return self.username

    def get_user_display(self):
        return f'{self.first_name} {self.last_name}'

    def get_short_name(self):
        return self.first_name

    def get_name_with_first_initial_only(self):
        name = []
        if self.first_name:
            name.append(self.first_name[0])
        if self.last_name:
            name.append(self.last_name)
        return ' '.join(name) or None
