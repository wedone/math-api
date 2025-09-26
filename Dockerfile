FROM node:16-alpine
# 安装系统依赖（包含 sharp 所需库及构建工具）
RUN apk add --no-cache vips-dev fftw-dev libexif-dev libjpeg-turbo-dev libpng-dev libwebp-dev tiff-dev giflib-dev make python3 g++ && rm -rf /var/cache/apk/*
# 设置工作目录
WORKDIR /app
# 复制项目依赖描述文件
COPY package.json yarn.lock ./
# 安装项目生产依赖
RUN yarn install --production
# 复制 layers 目录结构（确保 package.json 存在）
COPY layers/mathjax-node-layer/nodejs/package.json layers/mathjax-node-layer/nodejs/package-lock.json ./layers/mathjax-node-layer/nodejs/
# 生成 mathjax-node-layer 依赖（遵循 Makefile 逻辑，使用 lambda 构建环境）
RUN if [ ! -d "layers/mathjax-node-layer/nodejs/node_modules" ]; thenecho "生成 mathjax-node-layer 依赖...";mkdir -p layers/mathjax-node-layer/nodejs;docker run --rm-v /app/layers/mathjax-node-layer/nodejs:/var/task-e NODE_ENV=productionlambci/lambda:build-nodejs8.10npm install;fi
# 复制项目其余代码
COPY . .
# 暴露应用端口（与文档一致）
EXPOSE 3000
# 启动命令（匹配 package.json 中的脚本）
CMD ["yarn", "start"]
