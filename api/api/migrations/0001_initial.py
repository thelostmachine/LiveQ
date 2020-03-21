# Generated by Django 3.0.3 on 2020-03-04 00:48

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Room',
            fields=[
                ('room_key', models.CharField(max_length=30, primary_key=True, serialize=False)),
                ('room_name', models.CharField(max_length=30)),
                ('host', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Service',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('api_key', models.CharField(max_length=30)),
                ('service_type', models.IntegerField(choices=[(0, 'Spotify'), (1, 'Soundcloud')])),
                ('room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.Room')),
            ],
        ),
        migrations.CreateModel(
            name='Song',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('time', models.DateTimeField(auto_now_add=True)),
                ('song_id', models.CharField(max_length=30)),
                ('room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.Room')),
                ('service', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.Service')),
            ],
        ),
        migrations.CreateModel(
            name='Guest',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=30)),
                ('room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.Room')),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
