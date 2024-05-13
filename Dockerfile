# Dockerfile
FROM python:3.9-slim

#Sets the working directory inside the container to /app.
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy everything from the current directory to the PWD (Present Working Directory) inside the container
COPY . .

CMD ["python", "app.py"]
