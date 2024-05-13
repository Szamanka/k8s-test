# Dockerfile
FROM python:3.9-slim

#Sets the working directory inside the container to /app.
WORKDIR /app

COPY . /app
RUN pip install -r requirements.txt

ENTRYPOINT [ "python" ]
CMD ["app.py"]
