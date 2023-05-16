# Generated by Django 4.2 on 2023-05-05 13:24

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Category',
            fields=[
                ('categoryId', models.CharField(max_length=100, primary_key=True, serialize=False)),
                ('categoryName', models.CharField(max_length=100)),
                ('adminId', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'category',
            },
        ),
        migrations.CreateModel(
            name='Topic',
            fields=[
                ('topicId', models.CharField(max_length=100, primary_key=True, serialize=False)),
                ('topicName', models.CharField(max_length=100)),
                ('helpStatus', models.BooleanField(default=False)),
                ('content', models.CharField(max_length=1000)),
                ('dateCreated', models.DateTimeField()),
                ('numberOfComments', models.IntegerField()),
                ('categoryId', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='api.category')),
                ('userId', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'topic',
            },
        ),
    ]
