# imports
import logging

from django.http import HttpResponseBadRequest
from django.views import View
from django.contrib.auth import get_user_model
from django.http.response import JsonResponse

User = get_user_model()
logger = logging.getLogger(__name__)
# End: imports -----------------------------------------------------------------

# TODO: fix later
# pylint: disable=redefined-builtin


class ExtendedAPI(View):
    """
    Generic API for any model.
    Required: insert url path and prove model class

    Optional url parameters:
        - filter
        - order_by
        - fields

    Example query:
    Retrieve email and department of all teenagers ordered by last name then firstname

    /users/?filter=age__gte:13,age__lte:19&order_by=last_name,first_name&fields=email,department.title
    """

    related_delimiter = '.'  # traverse deeper into related objects
    delimiter = ','  # separate [key:]value within a url parameter (between = and &)
    k_v_delimiter = ':'  # separate key from value
    model = None

    # e.g. /transactions/?filter=user__gt:1,cost__lt:0
    def filter(self, request, queryset):
        if not request.GET.get('filter'):
            return queryset

        raw_filters = request.GET.get('filter').split(self.delimiter)
        filters = []

        for raw_f in raw_filters:
            k, v = raw_f.split(self.k_v_delimiter)[0], raw_f.split(self.k_v_delimiter)[1]
            filters.append({k: v})

        for filter in filters:
            queryset = queryset.filter(**filter)

        return queryset

    # e.g. /transactions/?order_by=user__id,cost
    def order_by(self, request, queryset):
        if not request.GET.get('order_by'):
            return queryset
        ordering = request.GET.get('order_by').split(self.delimiter)
        return queryset.order_by(*ordering)

    # e.g. /transactions/?order_by=user__id|cost
    def fields(self, request, queryset):
        if not request.GET.get('fields'):
            return [{k: v for (k, v) in t.__dict__.items() if not k.startswith('_')} for t in queryset]

        fields = request.GET.get('fields').split(self.delimiter)
        return [{k: v for (k, v) in t.__dict__.items() if k in fields} for t in queryset]

    # Risky. Calling methods is not good
    def special_fields(self, request, queryset):
        if not request.GET.get('fields'):
            return [{k: v for (k, v) in t.__dict__.items() if not k.startswith('_')} for t in queryset]

        fields = request.GET.get('fields').split(self.delimiter)

        data = []
        for t in queryset:
            r = {}
            for f in fields:
                current = t
                for related in f.split(self.related_delimiter):  # self.account.user. etc
                    current = getattr(current, related)

                # WARNING INSECURE
                # if inspect.ismethod(current):
                #     current = current()

                r[f] = current

            data.append(r)
        return data

    def parsed(self, request):
        try:
            queryset = self.model.objects.all()
            queryset = self.filter(request, queryset)
            queryset = self.order_by(request, queryset)
            queryset = self.limit(request, queryset)
            return queryset
        except Exception as e:  # pylint: disable=broad-except
            print(e)
            return HttpResponseBadRequest()

    def limit(self, request, queryset):
        n = request.GET.get('from')
        m = request.GET.get('to')
        if n:
            n = int(n)
        if m:
            m = int(m)
        return queryset[n:m]

    def get(self, request):
        queryset = self.parsed(request)
        data = self.special_fields(request, queryset)
        return JsonResponse(data, safe=False, json_dumps_params={'indent': 3})  # safe=False allows other types than dict

    # TODO: Implement
    def delete(self, request):
        pass
