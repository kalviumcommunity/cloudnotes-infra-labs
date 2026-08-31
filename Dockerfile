# Multi-stage build for the CloudNotes API.
# Stage 1: install dependencies. Stage 2: small runtime image that
# runs the app as a non-root user.

FROM python:3.12-slim AS builder

WORKDIR /build

# NOTE: only app/requirements.txt exists in this repository.
# Double-check the filename below against what is actually in app/.
COPY app/requirements-prod.txt ./requirements.txt
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim AS runtime

# Create a non-root user to run the service.
RUN addgroup --system app && adduser --system --ingroup app app

WORKDIR /app

COPY --from=builder /install /usr/local
COPY app/app.py ./app.py

USER app

EXPOSE 5000
ENV PORT=5000

CMD ["python", "app.py"]
