# Generated by Django 3.0.5 on 2020-04-28 10:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('liveq', '0011_auto_20200428_1022'),
    ]

    operations = [
        migrations.AlterField(
            model_name='room',
            name='room_key',
            field=models.CharField(blank=True, db_index=True, max_length=8, unique=True),
        ),
    ]
