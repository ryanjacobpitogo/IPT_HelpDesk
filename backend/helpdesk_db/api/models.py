from django.db import models
from django.contrib.auth.models import  AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db.models.signals import post_migrate
from django.dispatch import receiver


# Create your models here.
class UserManager(BaseUserManager):
    def create_user(self, username, password=None, **extra_fields):
        if not username:
            raise ValueError('The Username field must be set')
        user = self.model(username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(username, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    userId = models.CharField(max_length=100, primary_key=True)
    username = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=100,)
    firstName = models.CharField(max_length=100)
    lastName = models.CharField(max_length=100)
    role = models.CharField(max_length=100)
    is_active = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['roles']

    objects = UserManager()

    class Meta:
        db_table = "user"
    
    @property
    def is_anonymous(self):
        return False
    
    @property
    def is_authenticated(self):
        return True

class Category(models.Model):
    categoryId = models.CharField(max_length=100, primary_key=True);
    adminId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True);
    categoryName = models.CharField(max_length=100);

    def create_initial_category(sender, **kwargs):
        if sender.name == 'api':
            Category.objects.get_or_create(
                categoryId='your_category_id',
                categoryName='all'
            )

    class Meta:
        db_table = "category"

class Topic(models.Model):
    topicId = models.CharField(max_length=100, primary_key=True);
    categoryId = models.ForeignKey(Category, on_delete=models.CASCADE, null=True, blank=True);
    userId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True);
    topicName = models.CharField(max_length=100);
    helpStatus = models.BooleanField(default=False);
    content = models.CharField(max_length=1000);
    dateCreated = models.DateTimeField();
    numberOfComments = models.IntegerField(default=0);

    class Meta:
        db_table = "topic"

class Comment(models.Model):
    commentId = models.CharField(max_length=100, primary_key=True);
    topicId = models.ForeignKey(Topic, on_delete=models.CASCADE, null=True, blank=True);
    userId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True);
    username = models.CharField(max_length=100);
    isMostHelpful = models.BooleanField(default=False);
    showReply = models.BooleanField(default=False);
    content = models.CharField(max_length=1000);
    dateCreated = models.DateTimeField();
    replyCount = models.IntegerField(default=0);

    def save(self, *args, **kwargs):
        super(Comment, self).save(*args, **kwargs)
        self.topicId.numberOfComments = Comment.objects.filter(topicId=self.topicId).count() + Reply.objects.filter(commentId__topicId=self.topicId).count()
        self.topicId.save()

    class Meta:
        db_table = "comment"

class Reply(models.Model):
    replyId = models.CharField(max_length=100, primary_key=True);
    commentId = models.ForeignKey(Comment, on_delete=models.CASCADE, null=True, blank=True);
    userId = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True);
    username = models.CharField(max_length=100);
    content = models.CharField(max_length=1000);
    dateCreated = models.DateTimeField();

    def save(self, *args, **kwargs):
        super(Reply, self).save(*args, **kwargs)
        self.commentId.replyCount = Reply.objects.filter(commentId=self.commentId).count()
        self.commentId.save()
        self.commentId.topicId.numberOfComments = Comment.objects.filter(topicId=self.commentId.topicId).count() + Reply.objects.filter(commentId__topicId=self.commentId.topicId).count()
        self.commentId.topicId.save()

    class Meta:
        db_table = "reply"