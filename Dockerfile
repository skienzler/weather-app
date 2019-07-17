FROM node:lts-alpine

COPY src/ /var/www/

WORKDIR /var/www

RUN npm install

CMD node server.js

EXPOSE 3000