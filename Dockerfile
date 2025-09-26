FROM node:16-alpine

# 安装系统依赖（包含 sharp、svg2png 所需库及构建工具）
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
    # 新增 svg2png 依赖的图形库
    cairo-dev \
    pango-dev \
    libpng-dev \
    giflib-dev \
    && rm -rf /var/cache/apk/*

# 设置工作目录
WORKDIR /app

# 复制整个项目文件（包括 layers 目录）
COPY . .

# 安装项目根目录生产依赖
RUN yarn install --production

# 安装 mathjax-node-layer 依赖（直接在当前容器环境中安装，无需嵌套 docker）
RUN if [ ! -d "layers/mathjax-node-layer/nodejs/node_modules" ]; then \
        echo "安装 mathjax-node-layer 依赖..."; \
        mkdir -p layers/mathjax-node-layer/nodejs; \
        cd layers/mathjax-node-layer/nodejs; \
        npm install --production; \
    fi

# 暴露应用端口
EXPOSE 3000

# 启动命令
CMD ["yarn", "start"]
