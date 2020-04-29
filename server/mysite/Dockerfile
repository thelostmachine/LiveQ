FROM python:3.6
COPY . /
RUN pip install -r requirements.txt
#RUN ls -la 
#RUN python manage.py makemigrations && python manage.py migrate && python manage.py runserver 0.0.0.0:8080
#CMD ["ls"]
#CMD [ "python", "manage.py", "makemigrations
CMD [ "sh", "-c", "python manage.py makemigrations && python manage.py migrate && python manage.py runserver 0.0.0.0:8080" ]
