#!/bin/bash

# 多架构Docker镜像构建脚本
# 支持 ARM64 和 AMD64 架构

echo "🏗️ 构建多架构Docker镜像..."
echo "架构: linux/arm64, linux/amd64"

# 设置镜像名称
IMAGE_NAME="osd-cnn:universal"

# 清理旧镜像
echo "🧹 清理旧镜像..."
docker rmi ${IMAGE_NAME} 2>/dev/null || true

# 构建多架构镜像
echo "📦 构建镜像: ${IMAGE_NAME}"
docker buildx build \
  --platform linux/arm64,linux/amd64 \
  --tag ${IMAGE_NAME} \
  --load \
  .

echo "✅ 构建完成！"
echo "📋 镜像信息:"
docker images | grep osd-cnn

echo "🎯 使用方法:"
echo "  docker-compose up -d"