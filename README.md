# PyTorch CNN 测试项目

这是一个使用PyTorch构建的简易卷积神经网络项目，用于CIFAR-10图像分类任务。支持多架构部署和跨平台开发。

## 🎯 项目特点

- 🚀 **PyTorch深度学习框架** - 使用最新的PyTorch
- 📊 **CIFAR-10数据集** - 图像分类任务
- 🐳 **Docker容器化** - 环境隔离，部署简单
- 💻 **跨平台兼容** - Windows/Mac/Linux都能运行
- 🏗️ **多架构支持** - ARM64和AMD64架构
- 📈 **完整流程** - 数据加载、训练、评估、可视化
- 🔄 **实时同步** - 代码修改立即生效
- 📊 **可视化** - 训练过程和结果可视化

## 📁 项目结构

```
Project/
├── 📓 notebooks/              # Jupyter Notebook文件
│   ├── cnn_test.ipynb        # 主要的CNN测试notebook
│   └── nms+osd.ipynb         # 其他notebook文件
│
├── 🛠️ scripts/               # 脚本文件
│   ├── deploy.sh             # Linux/Mac部署脚本
│   ├── deploy.bat            # Windows部署脚本
│   ├── build-multiarch.sh    # 多架构构建脚本 (Mac/Linux)
│   ├── build-multiarch.bat   # 多架构构建脚本 (Windows)
│   └── test_sync.py          # 同步测试脚本
│
├── 📚 docs/                  # 文档文件
│   └── 多架构部署指南.md      # 多架构构建文档
│
├── ⚙️ config/                # 配置文件目录
│   └── .devcontainer/        # 开发容器配置
│       └── devcontainer.json # VS Code/Cursor远程开发配置
│
├── 💾 data/                  # 数据目录（自动创建）
│   └── (CIFAR-10数据集等)
│
├── 🤖 models/                # 模型文件目录
│   └── (训练好的模型文件)
│
├── 🐳 Docker相关文件
│   ├── Dockerfile            # Docker镜像构建文件
│   ├── docker-compose.yml    # Docker Compose配置
│   ├── requirements.txt      # Python依赖
│   └── .dockerignore         # Docker忽略文件
│
└── 📄 项目文档
    └── README.md             # 项目说明（本文件）
```

## 🚀 快速开始

### 方法1: 使用部署脚本（推荐）

#### Mac/Linux用户
```bash
./scripts/deploy.sh
```

#### Windows用户
```cmd
scripts\deploy.bat
```

### 方法2: 使用Docker Compose

1. **构建并启动容器**
   ```bash
   docker-compose up --build
   ```

2. **访问Jupyter Notebook**
   - 打开浏览器访问: http://localhost:8888
   - 使用token登录（token会在终端输出中显示）

3. **停止容器**
   ```bash
   docker-compose down
   ```

### 方法3: 直接使用Docker

1. **构建镜像**
   ```bash
   docker build -t cnn-pytorch-jupyter .
   ```

2. **运行容器**
   ```bash
   docker run -p 8888:8888 -v $(pwd):/app cnn-pytorch-jupyter
   ```

### 方法4: 本地运行

1. **安装依赖**
   ```bash
   pip install -r requirements.txt
   ```

2. **启动Jupyter**
   ```bash
   jupyter notebook
   ```

## 🏗️ 多架构支持

### 支持的架构
- **ARM64** (Apple Silicon Mac, ARM服务器)
- **AMD64** (Intel/AMD x64处理器)

### 构建多架构镜像

#### 使用构建脚本（推荐）
```bash
# Mac/Linux
./scripts/build-multiarch.sh

# Windows
scripts\build-multiarch.bat
```

#### 手动构建
```bash
# 创建多架构构建器
docker buildx create --name multiarch --driver docker-container --use

# 启动构建器
docker buildx inspect --bootstrap

# 构建多架构镜像
docker buildx build \
  --platform linux/arm64,linux/amd64 \
  --tag cnn-pytorch-jupyter:latest \
  --load \
  .
```

### 各平台使用方法

#### Apple Silicon Mac (ARM64)
```bash
# 自动使用ARM64架构
docker-compose up -d
```

#### Intel Mac (AMD64)
```bash
# 自动使用AMD64架构
docker-compose up -d
```

#### Windows (AMD64)
```cmd
# 自动使用AMD64架构
docker-compose up -d
```

#### Linux (AMD64/ARM64)
```bash
# 根据系统架构自动选择
docker-compose up -d
```

## 🎯 模型架构

- **卷积层**: 3层卷积，通道数分别为32、64、128
- **池化层**: 最大池化，2x2窗口
- **全连接层**: 512个隐藏单元 + 10个输出单元
- **正则化**: Dropout (0.5)
- **激活函数**: ReLU

## ⚙️ 训练配置

- **优化器**: Adam (lr=0.001)
- **损失函数**: CrossEntropyLoss
- **学习率调度**: StepLR (每10个epoch降低0.1倍)
- **训练轮数**: 20 epochs
- **批次大小**: 128

## 📊 数据增强

- 随机裁剪 (RandomCrop)
- 随机水平翻转 (RandomHorizontalFlip)
- 数据归一化 (Normalize)

## 🔄 代码同步机制

### 实时同步
- **本地修改** → 立即同步到容器
- **容器内修改** → 立即同步到本地
- **支持跨平台开发**

### 开发工作流
1. **在Cursor中编辑** - 利用IDE的智能提示
2. **在Jupyter中运行** - 利用交互式环境
3. **实时同步** - 修改立即生效
4. **版本控制** - 使用Git管理代码

## 📋 使用说明

1. 运行notebook中的所有cell
2. 模型会自动下载CIFAR-10数据集
3. 训练过程会显示损失和准确率
4. 训练完成后会显示详细评估结果
5. 模型会自动保存为 `cnn_model.pth`

## 🛠️ 管理命令

### 基本操作
```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs cnn-jupyter

# 获取访问token
docker-compose logs cnn-jupyter | grep token
```

### 高级操作
```bash
# 重新构建镜像
docker-compose up --build -d

# 清理未使用的镜像
docker image prune

# 查看资源使用情况
docker stats

# 进入容器
docker-compose exec cnn-jupyter bash
```

## 🌐 访问项目

### 获取访问信息
```bash
# 获取token
docker-compose logs cnn-jupyter | grep token

# 输出示例:
# http://127.0.0.1:8888/tree?token=YOUR_TOKEN_HERE
```

### 浏览器访问
1. 打开浏览器
2. 访问: http://localhost:8888
3. 输入token
4. 打开 `notebooks/cnn_test.ipynb` 开始使用

## 🔧 故障排除

### 常见问题

#### 1. 端口冲突
如果8888端口被占用，修改 `docker-compose.yml`：
```yaml
ports:
  - "8889:8888"  # 改为其他端口
```

#### 2. 内存不足
调整 `docker-compose.yml` 中的内存限制：
```yaml
deploy:
  resources:
    limits:
      memory: 8G  # 增加内存限制
```

#### 3. 权限问题
在某些系统上可能需要使用sudo：
```bash
sudo docker-compose up --build
```

#### 4. 架构不匹配
```bash
# 强制使用特定架构
docker run --platform linux/amd64 cnn-pytorch-jupyter:latest
```

#### 5. 构建失败
```bash
# 清理构建缓存
docker buildx prune

# 重新创建构建器
docker buildx rm multiarch
docker buildx create --name multiarch --driver docker-container --use
```

## 🛠️ 脚本使用

### 📋 脚本列表

#### 🚀 启动脚本
- **start.sh** - 快速启动项目

**功能**: 检查Docker环境，启动项目

**使用方法**:
```bash
./scripts/start.sh
```

#### 🏗️ 构建脚本
- **build-multiarch.sh** - Linux/Mac多架构构建脚本
- **build-multiarch.bat** - Windows多架构构建脚本

**功能**: 构建支持ARM64和AMD64架构的Docker镜像

**使用方法**:
```bash
# Mac/Linux
./scripts/build-multiarch.sh

# Windows
scripts\build-multiarch.bat
```

#### 🧹 清理脚本
- **cleanup-images.sh** - Docker镜像清理脚本

**功能**: 清理未使用的Docker镜像和构建缓存

**使用方法**:
```bash
./scripts/cleanup-images.sh
```

### 🎯 使用流程

#### 1️⃣ 首次使用
```bash
# 1. 启动项目
./scripts/start.sh

# 2. 访问Jupyter
# 浏览器打开: http://localhost:8888
```

#### 2️⃣ 开发过程中
```bash
# 修改代码后重新构建
./scripts/build-multiarch.sh

# 重启服务
docker-compose restart
```

#### 3️⃣ 定期维护
```bash
# 清理未使用的镜像
./scripts/cleanup-images.sh
```

## 📋 最佳实践

### 开发环境
- **ARM Mac**: 使用ARM64架构
- **Intel Mac**: 使用AMD64架构
- **Windows**: 使用AMD64架构

### 生产环境
- **云服务器**: 根据服务器架构选择
- **容器编排**: 使用多架构镜像
- **CI/CD**: 构建多架构镜像

### 团队协作
1. **代码同步** - 通过Git共享代码
2. **环境统一** - Docker提供统一环境
3. **跨平台** - 不同架构的机器都能使用
4. **文档共享** - 统一的项目文档

## 🎯 项目优势

- ✅ **结构清晰** - 文件分类明确，便于管理
- ✅ **跨平台** - Windows/Mac/Linux都能运行
- ✅ **多架构** - 支持ARM64和AMD64架构
- ✅ **实时同步** - 代码修改立即生效
- ✅ **数据持久化** - 数据和模型文件持久保存
- ✅ **易于部署** - 一键部署脚本
- ✅ **完整文档** - 详细的使用说明
- ✅ **开发友好** - 支持远程开发和调试
- ✅ **团队协作** - 统一开发环境
- ✅ **版本控制** - Git集成

## 📊 性能对比

### ARM64架构 (Apple Silicon)
- ✅ **原生性能** - 最佳性能
- ✅ **低功耗** - 电池续航更长
- ✅ **快速启动** - 容器启动更快

### AMD64架构 (Intel/AMD)
- ✅ **兼容性** - 广泛支持
- ✅ **稳定性** - 成熟稳定
- ⚠️ **性能** - 在ARM Mac上可能较慢

## 🔍 验证架构支持

### 检查镜像架构
```bash
# 查看镜像支持的架构
docker buildx imagetools inspect cnn-pytorch-jupyter:latest

# 查看本地镜像架构
docker image inspect cnn-pytorch-jupyter:latest | grep Architecture
```

### 检查容器架构
```bash
# 运行容器并检查架构
docker run --rm cnn-pytorch-jupyter:latest uname -m
```

## 📝 注意事项

- 首次运行会下载CIFAR-10数据集（约170MB）
- 训练过程可能需要几分钟到几十分钟，取决于硬件配置
- 建议使用GPU加速训练（如果可用）
- 数据会保存在 `./data` 目录中
- 模型会保存在 `./models` 目录中
- 容器删除后，数据仍然保存在本地

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 📄 许可证

MIT License

---

## 📚 相关文档

- [Docker官方文档](https://docs.docker.com/)
- [PyTorch官方文档](https://pytorch.org/docs/)
- [Jupyter官方文档](https://jupyter.org/documentation)
- [CIFAR-10数据集](https://www.cs.toronto.edu/~kriz/cifar.html)