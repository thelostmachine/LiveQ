# Generated by Django 3.0.5 on 2020-04-28 08:17

from django.db import migrations, models
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('liveq', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='room',
            name='room_key',
            field=models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False),
        ),
    ]
