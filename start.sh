#!/bin/bash

# 快速启动PyTorch CNN项目

echo "🚀 启动PyTorch CNN项目..."

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker Desktop"
    exit 1
fi

# 启动项目
docker-compose up -d

# 等待启动
sleep 5

# 显示访问信息
echo "✅ 项目已启动！"
echo "🌐 访问地址: http://localhost:8888"
echo "🔑 获取Token: docker-compose logs cnn-jupyter | grep token"
