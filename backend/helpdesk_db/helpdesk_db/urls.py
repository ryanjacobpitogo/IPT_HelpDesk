"""
URL configuration for helpdesk_db project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import include, path
from rest_framework import routers
from api.views import UserView, CategoryView, TopicView, CommentView, ReplyView

router = routers.DefaultRouter()
router.register(r'users', UserView)
router.register(r'categories', CategoryView)
router.register(r'topics', TopicView) 
router.register(r'comments', CommentView)  
router.register(r'replies', ReplyView)

urlpatterns = [
    path('', include(router.urls)),
    path('admin/', admin.site.urls),
    path('category/<str:categoryName>/topics', TopicView.getCategoryTopics),
    # path('users/', UserView.getUsers, name = 'All Users'),
    path('login/', UserView.getLogIn, name = 'Login'),
    path('register/', UserView.register, name = 'Registration'),
    path('category/add', CategoryView.addCategory, name = "Add Category"),
    path('topic/add', TopicView.addTopic, name = "Add Topic"),
    path('comment/add', CommentView.addComment, name = "Add Comment"),
    path('reply/add', ReplyView.addReply, name = "Add Reply"),
]   
