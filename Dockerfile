# 基于 Node.js 16 镜像
FROM node:16-alpine

# 安装 sharp 依赖的系统库（修复命令格式，添加必要空格）
RUN apk add --no-cache \
    vips-dev \
    fftw-dev \
    libexif-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    tiff-dev \
    giflib-dev \
    && rm -rf /var/cache/apk/*

# 设置工作目录
WORKDIR /app

# 复制项目根目录的依赖描述文件
COPY package.json yarn.lock ./

# 安装项目根目录的生产依赖
RUN yarn install --production

# 复制整个项目代码（包括 layers 目录）
COPY . .

# 安装 layers 目录下的依赖
RUN cd layers/mathjax-node-layer/nodejs && yarn install --production

# 暴露应用端口
EXPOSE 3000

# 启动命令
CMD ["yarn", "start"]
