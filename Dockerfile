FROM node:lts-alpine

COPY . /var/www/

WORKDIR /var/www

CMD node server.js

EXPOSE 3000