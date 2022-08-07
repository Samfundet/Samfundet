# imports
from django.db import models
from django.contrib.auth import get_user_model

from backend.root.mixins import FieldTrackerMixin

User = get_user_model()
# End: imports ---------------------------------------------------

# pylint: disable=positional-arguments


class Interactable(FieldTrackerMixin, models.Model):
    reacts = models.ManyToManyField(User, blank=True, related_name='reacts')
    # Marks will work as follow, heart and favorite
    marks = models.ManyToManyField(User, blank=True, related_name='marks')

    # FieldTrackerMixin:
    ftm_track_fields = '__all__'

    def total_comments(self):
        comment_count = self.comments.count()
        for c in self.comments.all():
            comment_count += c.total_comments()
        return comment_count

    def is_reacted_by(self, user: User) -> bool:
        if not user or not isinstance(user, User):
            raise Exception('user is required')
        return self.reacts.filter(id=user.id).exists()

    def is_marked_by(self, user: User) -> bool:
        if not user or not isinstance(user, User):
            raise Exception('user is required')
        return self.marks.filter(id=user.id).exists()

    @staticmethod
    def get_all_user_marked(*, interactable_model, user: User):
        if not user or not isinstance(user, User):
            raise Exception('user is required')
        if not interactable_model:
            raise Exception('An interactable object is required')
        return interactable_model.objects.filter(marks=user)

    def get_correct_model(self):
        """Returns the extended model if any"""
        for sub in Interactable.__subclasses__():
            field = sub.__name__.lower()
            if hasattr(self, field):
                return getattr(self, field)
        return self

    def reacts_count(self):
        return self.reacts.all().count()

    def marks_count(self):
        return self.marks.all().count()
