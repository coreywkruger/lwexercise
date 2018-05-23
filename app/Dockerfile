FROM node:10.1.0-alpine

WORKDIR /usr/src/app

COPY package.json ./package.json
RUN yarn install

COPY . .

CMD ["yarn", "start"]