# 基于 Node.js 16 镜像（与 CI 测试的 Node 版本范围匹配，且兼容项目依赖）
FROM node:16-alpine

# 安装 sharp 依赖的系统库（libvips 及相关依赖）
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

# 复制依赖描述文件（优先复制以利用 Docker 缓存）
COPY package.json yarn.lock ./
COPY layers/mathjax-node-layer/nodejs/package.json ./layers/mathjax-node-layer/nodejs/

# 安装生产环境依赖（使用 yarn 与项目脚本保持一致）
# 先安装层依赖，再安装项目依赖
RUN cd layers/mathjax-node-layer/nodejs && yarn install --production \
    && cd /app && yarn install --production

# 复制项目所有代码
COPY . .

# 暴露应用端口（与 src/app.js 中 Express 服务端口一致）
EXPOSE 3000

# 启动命令（对应 package.json 中的 "start" 脚本）
CMD ["yarn", "start"]
