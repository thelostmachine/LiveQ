# Generated by Django 3.0.5 on 2020-04-28 10:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('liveq', '0010_auto_20200428_1007'),
    ]

    operations = [
        migrations.AlterField(
            model_name='room',
            name='room_name',
            field=models.CharField(default='', max_length=30),
        ),
    ]
