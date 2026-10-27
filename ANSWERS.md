# Homework 1 - Written Answers

### 1. Order of instructions in the Dockerfile
In my Dockerfile, `COPY requirements.txt .` and `RUN pip install` are placed before copying the application source code (`COPY . .`). Docker caches each layer, and if a file changes, all subsequent layers are invalidated and rebuilt. By isolating dependency installation before copying the source code, Docker reuses the cached dependency layer whenever I only modify `app.py`. If I swapped these two instructions and copied the source code first, every tiny code edit would invalidate the cache and force Docker to download and reinstall all Python packages from scratch, significantly increasing the build time.

### 2. Data persistence in containers
When a container is removed, any data written inside its writable layer is permanently deleted because containers are ephemeral by design. To keep files on the host machine across container restarts or removals, we should mount Docker Volumes (`-v`) or bind mounts into the container. However, in production environments, an application should keep important state in external managed services such as a dedicated database (e.g., PostgreSQL, Redis) or cloud object storage (e.g., AWS S3) rather than inside the container filesystem.

### 3. Risk of the `latest` tag
Using the `latest` tag is a major risk for reproducibility because it is a moving target that points to the newest build pushed to the registry. If the upstream image maintainer releases a breaking update tomorrow, running `docker build` on another machine or in a CI/CD pipeline could pull a different version and break the application unexpectedly. Instead of `latest`, I pinned my base image to a specific version tag (`python:3.12-slim`) so that everyone building the image gets the exact same Python runtime and OS environment.

### Image Size Comparison Note
By using a multi-stage build with `python:3.12-slim` and leaving test files (test_app.py) and pytest caches behind in the builder stage, the final `ceng413-app:1.0` image size stays compact at around ~193 MB (compared to ~1 GB with the default full `python:3.12` image).

### AI Assistant Usage Disclosure
I used an AI assistant to help structure the multi-stage Python Dockerfile and verify the inline Python `urllib` command for the `HEALTHCHECK` instruction. I reviewed all instructions and wrote the explanations in my own words.
