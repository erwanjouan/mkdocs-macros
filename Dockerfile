# Buid
FROM python:3.13.3 AS build
WORKDIR /app/
COPY . .
RUN pip install -r requirements.txt && \
     python3 -m mkdocs build
# Run
FROM nginx:1.27.5
COPY --from=build /app/site /usr/share/nginx/html
EXPOSE 80