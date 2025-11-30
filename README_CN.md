# OSD-CNN：CNN增强的 LDPC NMS/OSD 译码器  
OSD-CNN: CNN-Enhanced LDPC NMS/OSD Decoder

**[English Version](README.md)** | 中文版本 / Chinese Version

---

本仓库集中在一个 Jupyter Notebook（`osd_cnn.ipynb`）中，完成了 **NMS→OSD→CNN 混合译码** 的端到端实验：从CCSDS标准LDPC码加载、混合SNR数据生成、DIANet训练、NMS/OSD-1/OSD-2/CNN-OSD的对比仿真以及可视化。当前实现使用**统一的NMS归一化因子 `alpha=0.78`**，在训练和仿真阶段保持一致，确保数据分布对齐。  

---

## ✨ 特性 / Features
- 📦 **标准LDPC码支持 / Standard LDPC Code Support**：从Alist格式文件加载CCSDS (128, 64)码，自动通过高斯消元生成G矩阵。
- 🔁 **统一的NMS归一化策略 / Unified Alpha**：`decode_nms_trajectory` 和混合 OSD 都使用同一个 `alpha=0.78`，方便复现实验并避免数据分布漂移。
- 📚 **混合SNR训练数据 / Mixed-SNR Data**：训练集覆盖 2.0–4.0 dB，多 SNR 样本共享相同的 NMS 配置。
- 🧠 **DIANet 轨迹学习 / DIANet Trajectory Learner**：输入为 NMS LLR 轨迹 `(n, T)`，输出每个比特的软信息增益。
- 🎯 **OSD算法实现 / OSD Algorithm Implementation**：支持OSD-1和OSD-2，包含自适应高斯消元和Top-K加速优化。
- 🛟 **CNN-OSD 融合 / CNN-OSD Fusion**：`hybrid_soft = y + 0.78 * cnn_logits`，直接在 OSD-1/2 中使用增强的软信息。
- 📈 **全流程可视化 / End-to-end Visualization**：Notebook 内置 FER曲线、增益柱状图与性能对比表格，同时展示OSD-1和OSD-2的结果。

---

## 📁 仓库内容 / Repository Layout
```
osd-cnn/
├── osd_cnn.ipynb              # 主实验 Notebook（含代码+说明）
├── dia_model_best.pth         # 训练好的 DIANet 模型参数
├── CCSDS_ldpc_n128_k64.alist  # CCSDS标准LDPC码的Alist格式文件
├── README.md                   # 英文文档
└── README_CN.md                # 当前文档（中文）
```

---

## ⚡ 快速开始 / Quick Start

### 方式一：Google Colab
1. 直接打开 [Colab](https://colab.research.google.com/github/bayonetta/osd-cnn/blob/main/osd_cnn.ipynb)。
2. Runtime → Change runtime type → 选择 GPU。  
3. 逐个运行单元，Notebook 会自动安装依赖、生成数据、训练 DIANet 并执行仿真。

### 方式二：本地环境
1. 安装依赖（若 Notebook 中未自动安装，可参考需求列表自行 pip 安装）。  
2. 启动 Jupyter：`jupyter notebook`。  
3. 打开 `osd_cnn.ipynb` 并按顺序执行全部单元。

---

## 🧩 核心模块 / Core Components
| 模块 | 内容 | 亮点 |
|------|------|------|
| **LDPC码加载** | 从Alist文件加载CCSDS (128, 64)码，高斯消元生成G矩阵 | 支持标准格式，自动验证H@G.T=0 |
| **NMS译码 + 轨迹记录** | `decode_nms_trajectory`，固定 `alpha=0.78` | 记录迭代 LLR 轨迹，输出失败样本 |
| **混合SNR数据生成** | 只保留 NMS 失败帧，`TOTAL_SAMPLES = 60000` | SNR 随机采样但共享同一 alpha |
| **DIANet 训练** | `BCEWithLogitsLoss` + `Adam (1e-3)` + EarlyStopping | 以轨迹为输入，预测比特错误倾向 |
| **OSD算法** | OSD-1/OSD-2，自适应高斯消元，Top-K加速 | 支持标准OSD和CNN增强混合OSD |
| **CNN-OSD 融合** | `hybrid_soft = y + 0.78 * cnn_logits` | 与纯OSD比较 FER/BER/耗时 |
| **可视化** | FER曲线、增益柱状图、性能表格 | 展示 NMS / OSD-1/2 / CNN-OSD 的整体表现 |

---

## 🧮 关键超参 / Key Hyper-Parameters
- `MAX_ITER_NMS = 12`：NMS 迭代次数。  
- `alpha = 0.78`：NMS 归一化因子，训练和仿真阶段统一使用固定值，确保数据分布一致。  
- `MAX_FRAMES = 1,000,000`、`MIN_CNN_ERRORS = 50`：仿真终止条件。  
- `BATCH_SIZE = 512`：DIANet 训练批量。  
- `TOTAL_SAMPLES = 60,000`：混合SNR失败帧，用于训练。
- `R = 0.5`：码率（CCSDS (128, 64) 码）。

---

## 📊 最新仿真概览 / Latest Simulation Snapshot

![](output.png)

> 仿真使用CCSDS (128, 64)码，统一alpha=0.78，SNR范围2.0-4.0 dB（步长0.2 dB）。

---

## 📚 参考 / References
1. Gallager, R. G. *Low-density parity-check codes*, 1962.  
2. Fossorier, M. P. C., & Lin, S. *Soft-decision decoding of linear block codes*, 1995.  
3. Chen, J., & Fossorier, M. P. C. *Near optimum universal belief propagation based decoding of LDPC codes*, 2002.  
4. Jia, M. et al. *Ordered Statistics Decoding for Short Block Codes*, 2019.