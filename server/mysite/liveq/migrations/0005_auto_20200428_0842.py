# Generated by Django 3.0.5 on 2020-04-28 08:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('liveq', '0004_auto_20200428_0838'),
    ]

    operations = [
        migrations.AlterField(
            model_name='room',
            name='room_key',
            field=models.CharField(default='ILcgIN9r', max_length=8, primary_key=True, serialize=False),
        ),
    ]
