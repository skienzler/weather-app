FROM node:lts-alpine

COPY src/ /var/www/

WORKDIR /var/www

RUN npm install --production

CMD node server.js

EXPOSE 3000