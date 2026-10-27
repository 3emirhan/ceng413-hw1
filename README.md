# CENG413 HW-1: Containerized Flask App
Build the image: `docker build -t ceng413-app:1.0 .`
Run the container: `docker run -d -p 8080:8080 -e APP_ENV=staging --name hw1-app ceng413-app:1.0`
Test endpoints: `curl http://localhost:8080/` and `curl http://localhost:8080/health`
