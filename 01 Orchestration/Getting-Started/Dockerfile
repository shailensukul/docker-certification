FROM python:3.6.1-alpine
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
RUN chmod 644 app.py
CMD ["python", "app.py"]