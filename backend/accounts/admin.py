# imports
import logging

from django.http import HttpRequest
from django.contrib import admin
from django.contrib.auth import admin as auth_admin
from django.contrib.admin import ModelAdmin
from django.db.models.query import QuerySet

from .models import User

logger = logging.getLogger(__name__)

# End: imports -----------------------------------------------------------------

# pylint: disable=unused-argument
# pylint: disable=positional-arguments


# Actions for Admin-site:
def make_normal_user(modeladmin: ModelAdmin, request: HttpRequest, queryset: QuerySet):
    queryset.update(is_staff=False)
    queryset.update(is_superuser=False)
    make_normal_user.short_description = 'Mark selected users as normal users without any permissions'


def make_staff(modeladmin: ModelAdmin, request: HttpRequest, queryset: QuerySet):
    queryset.update(is_staff=True)
    queryset.update(is_superuser=False)
    make_staff.short_description = 'Mark selected users as is_staff'


def make_superuser(modeladmin: ModelAdmin, request: HttpRequest, queryset: QuerySet):
    queryset.update(is_staff=True)
    queryset.update(is_superuser=True)
    make_superuser.short_description = 'Mark selected users as is_superuser'


def update_permission_code(modeladmin: ModelAdmin, request: HttpRequest, queryset: QuerySet):
    for code in queryset:
        code.save()
    update_permission_code.short_description = 'Update permission code(s)'


@admin.register(User)
class UserAdmin(auth_admin.UserAdmin):
    # Fields shown in user detail: admin/accounts//user/'id'/change
    fieldsets = [
        [None, {
            'fields': ['password']
        }],
        ['Personal info', {
            'fields': ['username', 'email', 'first_name', 'last_name', 'phone_number']
        }],
        ['Permissions', {
            'fields': ['is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions']
        }],
        ['Important dates', {
            'fields': ['last_login', 'date_joined']
        }],
    ]

    list_display = ['username', 'id', 'email', 'first_name', 'last_name', 'is_staff', 'is_superuser']
    list_filter = ['is_staff', 'is_superuser', 'is_active']
    search_fields = ['__str__']
    search_fields = ['first_name', 'last_name', 'email', 'phone_number', 'username']
    ordering = ['-is_superuser', 'email']
    readonly_fields = ['last_login', 'date_joined']
    filter_horizontal = ['groups', 'user_permissions']
    actions = [make_normal_user, make_staff, make_superuser]
