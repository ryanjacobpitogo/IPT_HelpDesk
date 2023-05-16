# Generated by Django 4.2 on 2023-05-07 13:59

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_reply_comment'),
    ]

    operations = [
        migrations.AlterField(
            model_name='comment',
            name='topicId',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='api.topic'),
        ),
        migrations.AlterField(
            model_name='reply',
            name='commentId',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='api.comment'),
        ),
    ]