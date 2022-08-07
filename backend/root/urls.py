# imports
import debug_toolbar

from django.conf import settings
from django.urls import path, include
from django.contrib import admin
from django.views.i18n import JavaScriptCatalog
from django.views.generic import TemplateView
from django.conf.urls.static import static

# End: imports -----------------------------------------------------------------
urlpatterns = [
    path('', TemplateView.as_view(template_name='backend.root/index.html'), name='home'),  # Default redirect when wrong permissions
    # path('', RedirectView.as_view(pattern_name='rekenett:index'), name='home'),  # Default redirect when wrong permissions
    path('admin/', admin.site.urls),
    path('brukere/', include('backend.accounts.urls')),
    path('forbudt/', TemplateView.as_view(template_name='backend.root/forbidden.html'), name='forbidden'),  # Default redirect when wrong permissions
    path('admin/jsi18n/', JavaScriptCatalog.as_view(), name='javascript-catalog'),
]

# Setup static access and media upload
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

if settings.DEBUG:
    urlpatterns += [
        path('__debug__/', include(debug_toolbar.urls)),
    ]
