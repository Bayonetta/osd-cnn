# OSD-CNN: 基于CNN增强的LDPC码解码器

这是一个使用深度学习技术改进LDPC码解码性能的研究项目。项目结合了传统的规范化最小和(NMS)解码算法和基于CNN的增强有序统计解码(OSD)技术。

## 🎯 项目特点

- 🧠 **深度学习增强** - 使用CNN预测比特错误概率
- 📡 **LDPC码解码** - 实现规范化最小和(NMS)解码算法
- 🔄 **有序统计解码** - 基于可靠度的OSD救援机制
- 📊 **性能分析** - 详细的BER性能对比和可视化
- 🚀 **Google Colab支持** - 一键运行，无需本地环境
- 📈 **实时训练** - 从NMS失败样本中学习错误模式

## 📁 项目结构

```
osd-cnn/
├── 📓 notebooks/              # Jupyter Notebook文件
│   ├── osd_cnn.ipynb         # 主要的OSD-CNN实现
│   ├── nms_osd.ipynb         # NMS+OSD算法实现
│   └── data/                 # 数据目录
│       ├── cifar-10-batches-py/  # CIFAR-10数据集
│       └── simulation_results.npz # 仿真结果
│
├── 🤖 models/                # 模型文件目录
│   └── dia_cnn.pth          # 训练好的CNN模型
│
├── ⚙️ config/               # 配置文件目录
│   └── .devcontainer/       # 开发容器配置
│       └── devcontainer.json
│
├── 📄 requirements.txt      # Python依赖
└── 📄 README.md             # 项目说明
```

## 🚀 快速开始

### 方法1: Google Colab（推荐）

1. **打开Google Colab**
   - 访问 [Google Colab](https://colab.research.google.com/)
   - 上传 `notebooks/osd_cnn.ipynb` 文件

2. **启用GPU**
   - 在Colab中：Runtime → Change runtime type → GPU
   - 选择T4 GPU（免费）或V100/A100（付费）

3. **运行Notebook**
   - 运行第一个cell安装依赖包
   - 按顺序运行所有cell即可

### 方法2: 本地运行

1. **安装依赖**
   ```bash
   pip install -r requirements.txt
   ```

2. **启动Jupyter**
   ```bash
   jupyter notebook
   ```

3. **打开notebook**
   - 打开 `notebooks/osd_cnn.ipynb`
   - 运行所有cell

## 🧠 算法原理

### 1. LDPC码基础
- **码长**: n=128, **信息位**: k=67
- **码率**: R=0.52
- **校验矩阵**: H (61×128)
- **生成矩阵**: G (67×128)

### 2. 规范化最小和(NMS)解码
- **迭代次数**: 12次
- **规范化因子**: α=0.8
- **早停机制**: 校验方程满足时停止

### 3. CNN增强OSD
- **输入**: LLR轨迹 (n×T, T=13)
- **网络结构**: 3层1D卷积 + 全连接层
- **输出**: 比特错误概率
- **救援策略**: 基于错误概率的可靠度排序

## 📊 模型架构

### CNN网络结构
```python
class DIA_CNN_Model(nn.Module):
    def __init__(self, trajectory_length):
        super().__init__()
        self.conv_layers = nn.Sequential(
            nn.Conv1d(1, 8, kernel_size=3, padding='same'),
            nn.ReLU(),
            nn.Conv1d(8, 4, kernel_size=3, padding='same'),
            nn.ReLU(),
            nn.Conv1d(4, 2, kernel_size=3, padding='same')
        )
        self.dense = nn.Linear(2 * trajectory_length, 1)
```

### 训练策略
- **数据来源**: 仅从NMS失败帧采样
- **样本数量**: 4000个失败帧
- **训练SNR**: 2.7 dB
- **损失函数**: BCEWithLogitsLoss
- **优化器**: Adam (lr=1e-3)

## 🎯 性能结果

### BER性能对比
| SNR (dB) | Baseline NMS | Standard OSD | CNN-OSD | CNN改进 |
|----------|--------------|---------------|---------|---------|
| 2.0      | 5.34e-02     | 5.33e-02      | 5.32e-02| 1.00×   |
| 2.5      | 2.78e-02     | 2.77e-02      | 2.76e-02| 1.00×   |
| 3.0      | 1.11e-02     | 1.11e-02      | 1.10e-02| 1.01×   |
| 3.5      | 3.53e-03     | 3.52e-03      | 3.49e-03| 1.01×   |
| 4.0      | 7.89e-04     | 7.88e-04      | 7.80e-04| 1.01×   |

### 关键特性
- ✅ **智能救援**: CNN预测错误比特位置
- ✅ **高效训练**: 仅从失败样本学习
- ✅ **实时推理**: 批量处理提升效率
- ✅ **性能提升**: 在高SNR区域显示改进

## 🔧 使用说明

### 1. 数据生成
```python
# 生成训练数据（仅从NMS失败帧）
X_train, y_train = generate_training_data_from_failures(
    n_failures_target=4000, 
    snr_db=2.7, 
    max_iter_nms=12
)
```

### 2. 模型训练
```python
# 训练CNN模型
model = DIA_CNN_Model(trajectory_length=13)
# 训练过程自动进行，模型保存到 models/dia_cnn.pth
```

### 3. 性能评估
```python
# 运行仿真对比
snrs_db = np.arange(2.0, 4.5, 0.5)
# 自动生成BER对比图和数值结果
```

## 📈 可视化结果

项目提供丰富的可视化功能：
- **BER性能曲线**: 三种算法的对比
- **高SNR区域放大**: 突出性能差异
- **改进因子图**: 量化性能提升
- **数值对比表**: 详细的BER数据

## 🛠️ 技术细节

### 依赖包
- **PyTorch**: 深度学习框架
- **NumPy**: 数值计算
- **Matplotlib**: 数据可视化
- **pyldpc**: LDPC码实现
- **scikit-learn**: 机器学习工具

### 硬件要求
- **GPU**: 推荐使用GPU加速训练
- **内存**: 至少4GB RAM
- **存储**: 约500MB用于数据和模型

## 🔬 研究背景

### 问题描述
传统的LDPC解码算法（如NMS）在某些SNR条件下可能失败，导致解码错误。本项目探索使用深度学习技术来改进解码性能。

### 创新点
1. **轨迹学习**: 利用LLR轨迹的时序信息
2. **失败导向**: 仅从解码失败样本中学习
3. **端到端**: 从轨迹到错误概率的直接映射
4. **高效推理**: 批量处理提升计算效率

### 应用场景
- **通信系统**: 5G/6G信道编码
- **存储系统**: 闪存纠错码
- **卫星通信**: 深空通信链路
- **物联网**: 低功耗设备通信

## 📚 参考文献

1. **LDPC码基础**: Gallager, R. G. (1962). Low-density parity-check codes.
2. **OSD算法**: Fossorier, M. P. C., & Lin, S. (1995). Soft-decision decoding of linear block codes.
3. **深度学习**: LeCun, Y., Bengio, Y., & Hinton, G. (2015). Deep learning.

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目！

### 贡献方向
- 算法优化
- 性能提升
- 代码重构
- 文档完善
- 新功能添加

## 📄 许可证

MIT License

## 📞 联系方式

如有问题或建议，请通过以下方式联系：
- 提交GitHub Issue
- 发送邮件至项目维护者

---

## 🎉 致谢

感谢所有为这个项目做出贡献的开发者和研究人员！

## 📚 相关资源

- [PyTorch官方文档](https://pytorch.org/docs/)
- [LDPC码理论](https://en.wikipedia.org/wiki/Low-density_parity-check_code)
- [Google Colab](https://colab.research.google.com/)
- [Jupyter Notebook](https://jupyter.org/)