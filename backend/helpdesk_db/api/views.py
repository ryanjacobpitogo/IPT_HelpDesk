from django.shortcuts import render
from django.utils import timezone
import json
import statistics
from pstats import Stats
# Create your views here.
from rest_framework.decorators import api_view
# from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import viewsets
from api.models import User, Category, Topic, Comment, Reply
from api.serializers import UserSerializer, CategorySerializer, TopicSerializer, CommentSerializer, ReplySerializer
# @api_view(['GET'])
# def getRoutes(request):

# # class HelloView(APIView):
# #     def get(self, request):
# #         return Response({'message': 'Hello, world!'})

class UserView(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    @api_view(['POST'])
    def register(request):
        user_data = json.loads(request.body)
        user = User.objects.create(
            userId=user_data['userId'],
            username=user_data['username'],
            password=user_data['password'],
            firstName=user_data['firstName'],
            lastName=user_data['lastName'],
            role=user_data['role']
        )
        serializer = UserSerializer(user)
        return Response(serializer.data, status=201)

    @api_view(['GET'])
    def getUsers(request):
        queryset = User.objects.all()
        serializer = UserSerializer(queryset, many=True)
        return Response(serializer.data)
    
    @api_view(['POST'])
    def getLogIn(request):
        username = request.data.get('username')
        password = request.data.get('password')
    
        # validate username and password
        if not username or not password:
            return Response({'error': 'Invalid credentials'}, status=401)

        try:
            user = User.objects.get(username=username)
            passw = User.objects.get(password=password)
            if user and passw:
                user.last_login = timezone.now()
                user.save()
                serializer = UserSerializer(user)
                return Response(serializer.data)
            else:
                return Response({'error': 'Invalid credentials'}, status=401)
        except User.DoesNotExist:
            return Response({'error': 'Invalid credentials'}, status=401)
    
    @api_view(['POST'])
    def updateUser(request, userId):
        user = User.objects.get(pk = userId)
        user.username = request.POST.get('username', user.username)
        user.password = request.POST.get('password', user.password)
        user.firstName = request.POST.get('firstName', user.firstName)
        user.lastName =  request.POST.get('lastName', user.password)
        user.save()

class CategoryView(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

    @api_view(['GET'])
    def getCategories(request):
        queryset = Category.objects.all()
        serializer = CategorySerializer(queryset, many=True)
        return Response(serializer.data)
    
    @api_view(['POST'])
    def addCategory(request):
        category_data = json.loads(request.body)
        admin_id = category_data['adminId']
        admin = User.objects.get(pk=admin_id)
        category = Category.objects.create(
            categoryId=category_data['categoryId'],
            adminId=admin,
            categoryName=category_data['categoryName'],
        )
        serializer = CategorySerializer(category)
        return Response(serializer.data)
    
    # @api_view(['PUT'])
    # def updateCategory(request, pk):
    #     try:
    #         category = Category.objects.get(pk=pk)
    #     except Category.DoesNotExist:
    #         return Response(status=404)

    #     category_data = json.loads(request.body)
    #     is_clicked = category_data.get('isClicked')
    #     if is_clicked is not None:
    #         Category.objects.exclude(pk=pk).update(isClicked=False)  # set all other isClicked to false
    #         category.isClicked = is_clicked

    #     serializer = CategorySerializer(category, data=category_data)
    #     if serializer.is_valid():
    #         serializer.save()
    #         return Response(serializer.data)
    #     return Response(serializer.errors, status=400)

class TopicView(viewsets.ModelViewSet):
    queryset = Topic.objects.all()
    serializer_class = TopicSerializer

    @api_view(['GET'])
    def getTopics(request):
        queryset = Topic.objects.order_by('-dateCreated')
        serializer = TopicSerializer(queryset, many=True)
        return Response(serializer.data)
    
    @api_view(['GET'])
    def getCategoryTopics(request, categoryName):
        try:
            category = Category.objects.get(categoryName=categoryName)
            topics = Topic.objects.filter(categoryId=category.categoryId).order_by('-dateCreated')
            serializer = TopicSerializer(topics, many=True)
            return Response(serializer.data)
        except Topic.DoesNotExist:
            return Response({'error': 'Category not found'}, status=404)
    
    @api_view(['POST'])
    def addTopic(request):
        topic_data = json.loads(request.body)
        category_id = topic_data['categoryId']
        user_id = topic_data['userId']
        category = Category.objects.filter(pk=category_id).first();
        if category == None:
            category = 'temp'
        user = User.objects.get(pk=user_id)
        topic = Topic.objects.create(
            topicId=topic_data['topicId'],
            categoryId=category,
            userId=user,
            topicName=topic_data['topicName'],
            helpStatus=topic_data['helpStatus'],
            content=topic_data['content'],
            dateCreated=topic_data['dateCreated'],
            numberOfComments=topic_data['numberOfComments'],
        )
        serializer = TopicSerializer(topic)
        return Response(serializer.data)

    @api_view(['PUT'])
    def updateTopic(request, pk):
        try:
            topic = Topic.objects.get(pk=pk)
        except Topic.DoesNotExist:
            return Response(status=404)

        topic_data = json.loads(request.body)
        help_status = topic_data.get('helpStatus')
        if help_status is not None:
            topic.helpStatus = help_status

        serializer = TopicSerializer(topic, data=topic_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)

    @api_view(['DELETE'])
    def deleteTopic(request, pk):
        try:
            topic = Topic.objects.get(pk=pk)
        except Topic.DoesNotExist:
            return Response(status=404)

        topic.delete()
        return Response(status=204)

class CommentView(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer

    @api_view(['GET'])
    def getComments(request):
        queryset = Comment.objects.order_by('-dateCreated')
        serializer = CommentSerializer(queryset, many=True)
        return Response(serializer.data)  
    
    @api_view(['POST'])
    def addComment(request):
        comment_data = json.loads(request.body)
        topic_id = comment_data['topicId']
        user_id = comment_data['userId']
        topic = Topic.objects.get(pk=topic_id)
        user = User.objects.get(pk=user_id)
        comment = Comment.objects.create(
            commentId=comment_data['commentId'],
            topicId=topic,
            userId=user,
            username=comment_data['username'],
            isMostHelpful=comment_data['isMostHelpful'],
            showReply=comment_data['showReply'],
            content=comment_data['content'],
            dateCreated=comment_data['dateCreated'],
            replyCount=comment_data['replyCount'],
        )
        serializer = CommentSerializer(comment)
        return Response(serializer.data)

    @api_view(['PUT'])
    def updateMostHelpful(request, pk):
        try:
            comment = Comment.objects.get(pk=pk)
        except Comment.DoesNotExist:
            return Response(status=404)

        comment_data = json.loads(request.body)
        help_status = comment_data.get('isMostHelpful')
        if help_status is not None:
            comment.isMostHelpful = help_status

        serializer = CommentSerializer(comment, data=comment_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    
    @api_view(['PUT'])
    def updateShowReply(request, pk):
        try:
            comment = Comment.objects.get(pk=pk)
        except Comment.DoesNotExist:
            return Response(status=404)

        comment_data = json.loads(request.body)
        reply_status = comment_data.get('showReply')
        if reply_status is not None:
            comment.showReply = reply_status

        serializer = CommentSerializer(comment, data=comment_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)

    @api_view(['DELETE'])
    def deleteComment(request, pk):
        try:
            comment = Comment.objects.get(pk=pk)
        except Comment.DoesNotExist:
            return Response(status=404)

        comment.delete()
        return Response(status=204)
    
    @api_view(['DELETE'])
    def deleteAllComments(request, commentId):
        comments = Comment.objects.filter(commentId=commentId)
        if comments.exists():
            comments.delete()
            return Response(status=204)
        else:
            return Response(status=404)

class ReplyView(viewsets.ModelViewSet):
    queryset = Reply.objects.all()
    serializer_class = ReplySerializer

    @api_view(['GET'])
    def getReplies(request):
        queryset = Reply.objects.order_by('-dateCreated')
        serializer = ReplySerializer(queryset, many=True)
        return Response(serializer.data)  
    
    @api_view(['POST'])
    def addReply(request):
        reply_data = json.loads(request.body)
        comment_id = reply_data['commentId']
        user_id = reply_data['userId']
        comment = Comment.objects.get(pk=comment_id)
        user = User.objects.get(pk=user_id)
        reply = Reply.objects.create(
            replyId=reply_data['replyId'],
            commentId=comment,
            userId=user,
            username=reply_data['username'],
            content=reply_data['content'],
            dateCreated=reply_data['dateCreated'],
        )
        serializer = ReplySerializer(reply)
        return Response(serializer.data)

    @api_view(['DELETE'])
    def deleteReply(request, pk):
        try:
            reply = Reply.objects.get(pk=pk)
        except Reply.DoesNotExist:
            return Response(status=404)

        reply.delete()
        return Response(status=204)
    
    @api_view(['DELETE'])
    def deleteAllReplies(request, replyId):
        replies = Reply.objects.filter(replyId=replyId)
        if replies.exists():
            replies.delete()
            return Response(status=204)
        else:
            return Response(status=404)
