# OSD-CNN：CNN增强的 LDPC NMS/OSD 译码器  
OSD-CNN: CNN-Enhanced LDPC NMS/OSD Decoder

本仓库集中在一个 Jupyter Notebook（`osd_cnn.ipynb`）中，完成了 **NMS→OSD→CNN 混合译码** 的端到端实验：混合 SNR 数据生成、DIANet 训练、NMS/OSD/CNN-OSD 的对比仿真以及可视化。当前实现已经切换为**统一的 NMS 归一化因子 `alpha=0.78`**，并在仿真与数据生成阶段保持一致。  
This repository contains a single all-in-one notebook (`osd_cnn.ipynb`) that builds the complete pipeline: mixed-SNR data generation, DIANet training, and a full comparison between NMS, standard OSD, and CNN-boosted hybrid OSD. The current implementation uses a **single normalization factor `alpha = 0.78` for every SNR**, keeping both training and simulation fully aligned.

---

## ✨ 特性 / Features
- 🔁 **统一的NMS归一化策略 / Unified Alpha**：`decode_nms_trajectory` 和混合 OSD 都使用同一个 `alpha=0.78`，方便复现实验并避免数据分布漂移。
- 📚 **混合SNR训练数据 / Mixed-SNR Data**：训练集覆盖 2.0–4.0 dB，多 SNR 样本共享相同的 NMS 配置。
- 🧠 **DIANet 轨迹学习 / DIANet Trajectory Learner**：输入为 NMS LLR 轨迹 `(n, T)`，输出每个比特的软信息增益。
- 🛟 **CNN-OSD 融合 / CNN-OSD Fusion**：`hybrid_soft = y + 0.78 * cnn_logits`，直接在 OSD-1/2 中使用增强的软信息。
- 📈 **全流程可视化 / End-to-end Visualization**：Notebook 内置 FER/BER/耗时曲线与增益对比表。

---

## 📁 仓库内容 / Repository Layout
```
osd-cnn/
├── osd_cnn.ipynb       # 主实验 Notebook（含代码+说明）
├── dia_model_best.pth  # 训练好的 DIANet 模型参数
└── README.md           # 当前文档
```

---

## ⚡ 快速开始 / Quick Start

### 方式一：Google Colab
1. 打开 [Colab](https://colab.research.google.com/)，上传 `osd_cnn.ipynb`。  
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
| **NMS译码 + 轨迹记录** | `decode_nms_trajectory`，固定 `alpha=0.78` | 记录迭代 LLR 轨迹，输出失败样本 |
| **混合SNR数据生成** | 只保留 NMS 失败帧，`TOTAL_SAMPLES = 60000` | SNR 随机采样但共享同一 alpha |
| **DIANet 训练** | `BCEWithLogitsLoss` + `Adam (1e-3)` + EarlyStopping | 以轨迹为输入，预测比特错误倾向 |
| **CNN-OSD 融合** | `hybrid_soft = y + 0.78 * cnn_logits` | 与纯OSD比较 FER/BER/耗时 |
| **可视化** | FER/BER 曲线、增益条形、性能表格 | 展示 NMS / OSD / CNN-OSD 的整体表现 |

---

## 🧮 关键超参 / Key Hyper-Parameters
- `MAX_ITER_NMS = 12`：NMS 迭代次数。  
- `alpha = 0.78`：NMS 与 CNN 融合共享的固定归一化因子。  
- `MAX_FRAMES = 1,000,000`、`MIN_CNN_ERRORS = 50`：仿真终止条件。  
- `BATCH_SIZE = 512`：DIANet 训练批量。  
- `TOTAL_SAMPLES = 60,000`：混合SNR失败帧，用于训练。

---

## 📊 最新仿真概览 / Latest Simulation Snapshot

| SNR (dB) | Std OSD-1 FER | Hyb OSD-1 FER | Gain | Std OSD-2 FER | Hyb OSD-2 FER | Gain |
|----------|---------------|---------------|------|---------------|---------------|------|
| 1.5 | 2.77e-01 | 1.75e-01 | 36.8% | 2.34e-01 | 1.60e-01 | 31.6% |
| 2.0 | 1.66e-01 | 9.00e-02 | 45.8% | 1.36e-01 | 7.90e-02 | 41.9% |
| 2.5 | 5.97e-02 | 2.27e-02 | 62.0% | 4.57e-02 | 2.00e-02 | 56.2% |
| 3.0 | 2.08e-02 | 6.00e-03 | 71.2% | 1.66e-02 | 5.10e-03 | 69.3% |
| 3.5 | 4.52e-03 | 9.52e-04 | 78.9% | 3.62e-03 | 8.10e-04 | 77.6% |
| 4.0 | 8.41e-04 | 1.32e-04 | 84.3% | 6.75e-04 | 1.10e-04 | 83.7% |

> 所有数据来自 `osd_cnn.ipynb` 中“Comprehensive Simulation Summary”输出，可通过重新运行 Notebook 刷新。

---

## 📚 参考 / References
1. Gallager, R. G. *Low-density parity-check codes*, 1962.  
2. Fossorier, M. P. C., & Lin, S. *Soft-decision decoding of linear block codes*, 1995.  
3. Chen, J., & Fossorier, M. P. C. *Near optimum universal belief propagation based decoding of LDPC codes*, 2002.  
4. Jia, M. et al. *Ordered Statistics Decoding for Short Block Codes*, 2019.