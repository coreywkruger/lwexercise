FROM node:alpine

WORKDIR /usr/src/app

COPY package.json ./package.json
RUN yarn install

COPY . .

CMD ["yarn", "start"]