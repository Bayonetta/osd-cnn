# 使用官方Python镜像作为基础镜像
FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 升级pip并设置镜像源
RUN pip install --upgrade pip
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 复制requirements文件
COPY requirements.txt .

# 安装Python依赖（分步安装，更好的错误处理）
RUN pip install --no-cache-dir torch torchvision
RUN pip install --no-cache-dir numpy matplotlib seaborn scikit-learn pandas
RUN pip install --no-cache-dir jupyter jupyterlab ipywidgets
RUN pip install --no-cache-dir tqdm Pillow

# 复制项目文件
COPY . .

# 创建数据目录
RUN mkdir -p /app/data

# 暴露Jupyter端口
EXPOSE 8888

# 设置Jupyter配置
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8888" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py

# 启动命令
CMD ["jupyter", "notebook", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--no-browser"]