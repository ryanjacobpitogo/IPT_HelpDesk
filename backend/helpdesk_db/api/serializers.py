from rest_framework import serializers
from .models import User, Category, Topic, Comment, Reply


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['userId', 'username', 'password',
                  'firstName', 'lastName', 'role',
                  'is_active', 'is_staff', 'is_superuser']

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['categoryId', 'adminId', 'categoryName']

        
class TopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Topic
        fields = ['topicId', 'categoryId', 'userId',
                  'topicName', 'helpStatus', 'content',
                  'dateCreated', 'numberOfComments']

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['commentId', 'topicId', 'userId',
                  'username', 'isMostHelpful', 'showReply',
                  'content', 'dateCreated', 'replyCount']

class ReplySerializer(serializers.ModelSerializer):
    class Meta:
        model = Reply
        fields = ['replyId', 'commentId', 'userId',
                  'username', 'content',
                  'dateCreated']