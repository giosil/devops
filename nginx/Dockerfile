FROM nginx:1.21.6-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY /public/ /usr/share/nginx/html/

COPY /dist/ /usr/share/nginx/html/dist
