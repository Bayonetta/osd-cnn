#!/bin/bash

# Docker镜像清理脚本
# 清理重复和未使用的镜像

echo "🧹 Docker镜像清理脚本"
echo "====================="

# 显示当前镜像
echo "📋 当前镜像列表:"
docker images

echo ""
echo "🗑️ 开始清理..."

# 清理悬空镜像
echo "清理悬空镜像..."
docker image prune -f

# 清理未使用的镜像
echo "清理未使用的镜像..."
docker image prune -a -f

# 清理构建缓存
echo "清理构建缓存..."
docker buildx prune -f

# 显示清理后的镜像
echo ""
echo "✅ 清理完成！"
echo "📋 清理后的镜像列表:"
docker images

echo ""
echo "💡 建议:"
echo "1. 定期运行此脚本清理未使用的镜像"
echo "2. 使用多架构镜像避免重复"
echo "3. 使用 .dockerignore 减少构建上下文"
