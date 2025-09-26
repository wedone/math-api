FROM node:16-alpine
RUN apk add --no-cachevips-devfftw-devlibexif-devlibjpeg-turbo-devlibpng-devlibwebp-devtiff-devgiflib-dev&& rm -rf /var/cache/apk/*
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . .
RUN cd layers/mathjax-node-layer/nodejs && yarn install --production
EXPOSE 3000
CMD ["yarn", "start"]
