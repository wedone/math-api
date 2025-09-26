基于 Node.js 16 镜像（与 CI 测试的 Node 版本范围匹配，且兼容项目依赖）
FROM node:16-alpine
安装 sharp 依赖的系统库（libvips 及相关依赖）
RUN apk add --no-cachevips-devfftw-devlibexif-devlibjpeg-turbo-devlibpng-devlibwebp-devtiff-devgiflib-dev&& rm -rf /var/cache/apk/*
设置工作目录
WORKDIR /app
复制项目根目录的依赖描述文件（优先利用缓存）
COPY package.json yarn.lock ./
先安装项目根目录的生产依赖（利用缓存）
RUN yarn install --production
复制整个项目代码（包括 layers 目录下的文件）
COPY . .
安装 layers 目录下的依赖（此时 layers 目录已通过 COPY . . 复制到容器中）
RUN cd layers/mathjax-node-layer/nodejs && yarn install --production
暴露应用端口
EXPOSE 3000
启动命令
CMD ["yarn", "start"]
