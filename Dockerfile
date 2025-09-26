FROM node:16-alpine

# 安装系统依赖（包含 sharp 所需库及构建工具）
RUN apk add --no-cache \
    vips-dev \
    fftw-dev \
    libexif-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    tiff-dev \
    giflib-dev \
    make \
    python3 \
    g++ \
    && rm -rf /var/cache/apk/*

# 设置工作目录
WORKDIR /app

# 先复制整个 layers 目录结构（确保依赖描述文件存在）
COPY layers/ ./layers/

# 复制项目根目录依赖描述文件
COPY package.json yarn.lock ./

# 安装项目生产依赖
RUN yarn install --production

# 生成 mathjax-node-layer 依赖（遵循 Makefile 逻辑，使用 lambda 构建环境）
RUN if [ ! -d "layers/mathjax-node-layer/nodejs/node_modules" ]; then \
        echo "生成 mathjax-node-layer 依赖..."; \
        mkdir -p layers/mathjax-node-layer/nodejs; \
        docker run --rm \
            -v /app/layers/mathjax-node-layer/nodejs:/var/task \
            -e NODE_ENV=production \
            lambci/lambda:build-nodejs8.10 \
            npm install; \
    fi

# 复制项目其余代码（如果还有未被 layers 覆盖的文件）
COPY . .

# 暴露应用端口
EXPOSE 3000

# 启动命令
CMD ["yarn", "start"]
