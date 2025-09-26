# 基于 Node.js 16 镜像（与 CI 测试的 Node 版本范围匹配，且兼容项目依赖）
FROM node:16-alpine

# 设置工作目录
WORKDIR /app

# 复制依赖描述文件（优先复制以利用 Docker 缓存）
COPY package.json yarn.lock ./

# 安装生产环境依赖（使用 yarn 与项目脚本保持一致）
RUN yarn install --production

# 复制项目所有代码
COPY . .

# 暴露应用端口（与 src/app.js 中 Express 服务端口一致）
EXPOSE 3000

# 启动命令（对应 package.json 中的 "start" 脚本）
CMD ["yarn", "start"]
