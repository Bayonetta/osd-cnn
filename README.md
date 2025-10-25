# OSD-CNN: CNN-Enhanced LDPC Code Decoder

This is a research project that uses deep learning techniques to improve LDPC code decoding performance. The project combines traditional Normalized Min-Sum (NMS) decoding algorithms with CNN-enhanced Ordered Statistical Decoding (OSD) techniques.

## 🎯 Project Features

- 🧠 **Deep Learning Enhancement** - Uses CNN to predict bit error probabilities
- 📡 **LDPC Code Decoding** - Implements Normalized Min-Sum (NMS) decoding algorithm
- 🔄 **Ordered Statistical Decoding** - OSD rescue mechanism based on reliability
- 📊 **Performance Analysis** - Detailed BER performance comparison and visualization
- 🚀 **Google Colab Support** - One-click execution, no local environment required
- 📈 **Real-time Training** - Learns error patterns from NMS failure samples

## 📁 Project Structure

```
osd-cnn/
├── 📓 notebooks/              # Jupyter Notebook files
│   ├── osd_cnn.ipynb         # Main OSD-CNN implementation
│   ├── nms_osd.ipynb         # NMS+OSD algorithm implementation
│   └── data/                 # Data directory
│       ├── cifar-10-batches-py/  # CIFAR-10 dataset
│       └── simulation_results.npz # Simulation results
│
├── 🤖 models/                # Model files directory
│   └── dia_cnn.pth          # Trained CNN model
│
├── ⚙️ config/               # Configuration files directory
│   └── .devcontainer/       # Development container configuration
│       └── devcontainer.json
│
├── 📄 requirements.txt      # Python dependencies
└── 📄 README.md             # Project documentation
```

## 🚀 Quick Start

### Method 1: Google Colab (Recommended)

1. **Open Google Colab**
   - Visit [Google Colab](https://colab.research.google.com/)
   - Upload the `notebooks/osd_cnn.ipynb` file

2. **Enable GPU**
   - In Colab: Runtime → Change runtime type → GPU
   - Select T4 GPU (free) or V100/A100 (paid)

3. **Run Notebook**
   - Run the first cell to install dependencies
   - Run all cells in sequence

### Method 2: Local Execution

1. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

2. **Start Jupyter**
   ```bash
   jupyter notebook
   ```

3. **Open Notebook**
   - Open `notebooks/osd_cnn.ipynb`
   - Run all cells

## 🧠 Algorithm Principles

### 1. LDPC Code Basics
- **Code Length**: n=128, **Information Bits**: k=67
- **Code Rate**: R=0.52
- **Parity Check Matrix**: H (61×128)
- **Generator Matrix**: G (67×128)

### 2. Normalized Min-Sum (NMS) Decoding
- **Iterations**: 12 iterations
- **Normalization Factor**: α=0.8
- **Early Stopping**: Stops when parity equations are satisfied

### 3. CNN-Enhanced OSD
- **Input**: LLR trajectory (n×T, T=13)
- **Network Architecture**: 3-layer 1D convolution + fully connected layer
- **Output**: Bit error probabilities
- **Rescue Strategy**: Reliability ordering based on error probabilities

## 📊 Model Architecture

### CNN Network Structure
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

### Training Strategy
- **Data Source**: Only samples from NMS failure frames
- **Sample Count**: 4000 failure frames
- **Training SNR**: 2.7 dB
- **Loss Function**: BCEWithLogitsLoss
- **Optimizer**: Adam (lr=1e-3)

## 🎯 Performance Results

### BER Performance Comparison
| SNR (dB) | Baseline NMS | Standard OSD | CNN-OSD | CNN Improvement |
|----------|--------------|---------------|---------|-----------------|
| 2.0      | 5.34e-02     | 5.33e-02      | 5.32e-02| 1.00×           |
| 2.5      | 2.78e-02     | 2.77e-02      | 2.76e-02| 1.00×           |
| 3.0      | 1.11e-02     | 1.11e-02      | 1.10e-02| 1.01×           |
| 3.5      | 3.53e-03     | 3.52e-03      | 3.49e-03| 1.01×           |
| 4.0      | 7.89e-04     | 7.88e-04      | 7.80e-04| 1.01×           |

### Key Features
- ✅ **Intelligent Rescue**: CNN predicts error bit locations
- ✅ **Efficient Training**: Learns only from failure samples
- ✅ **Real-time Inference**: Batch processing improves efficiency
- ✅ **Performance Enhancement**: Shows improvements in high SNR regions

## 🔧 Usage Instructions

### 1. Data Generation
```python
# Generate training data (only from NMS failure frames)
X_train, y_train = generate_training_data_from_failures(
    n_failures_target=4000, 
    snr_db=2.7, 
    max_iter_nms=12
)
```

### 2. Model Training
```python
# Train CNN model
model = DIA_CNN_Model(trajectory_length=13)
# Training process runs automatically, model saved to models/dia_cnn.pth
```

### 3. Performance Evaluation
```python
# Run simulation comparison
snrs_db = np.arange(2.0, 4.5, 0.5)
# Automatically generates BER comparison plots and numerical results
```

## 📈 Visualization Results

The project provides rich visualization capabilities:
- **BER Performance Curves**: Comparison of three algorithms
- **High SNR Region Zoom**: Highlights performance differences
- **Improvement Factor Plot**: Quantifies performance gains
- **Numerical Comparison Table**: Detailed BER data

## 🛠️ Technical Details

### Dependencies
- **PyTorch**: Deep learning framework
- **NumPy**: Numerical computing
- **Matplotlib**: Data visualization
- **pyldpc**: LDPC code implementation
- **scikit-learn**: Machine learning tools

### Hardware Requirements
- **GPU**: Recommended for GPU-accelerated training
- **Memory**: At least 4GB RAM
- **Storage**: Approximately 500MB for data and models

## 🔬 Research Background

### Problem Description
Traditional LDPC decoding algorithms (such as NMS) may fail under certain SNR conditions, leading to decoding errors. This project explores using deep learning techniques to improve decoding performance.

### Innovation Points
1. **Trajectory Learning**: Utilizes temporal information from LLR trajectories
2. **Failure-Oriented**: Learns only from decoding failure samples
3. **End-to-End**: Direct mapping from trajectories to error probabilities
4. **Efficient Inference**: Batch processing improves computational efficiency

### Application Scenarios
- **Communication Systems**: 5G/6G channel coding
- **Storage Systems**: Flash memory error correction codes
- **Satellite Communications**: Deep space communication links
- **IoT**: Low-power device communications

## 📚 References

1. **LDPC Code Fundamentals**: Gallager, R. G. (1962). Low-density parity-check codes.
2. **OSD Algorithm**: Fossorier, M. P. C., & Lin, S. (1995). Soft-decision decoding of linear block codes.
3. **Deep Learning**: LeCun, Y., Bengio, Y., & Hinton, G. (2015). Deep learning.

## 🤝 Contributing

Welcome to submit Issues and Pull Requests to improve this project!

### Contribution Areas
- Algorithm optimization
- Performance improvements
- Code refactoring
- Documentation enhancement
- New feature additions

## 📄 License

MIT License

## 📞 Contact

For questions or suggestions, please contact us through:
- Submit GitHub Issues
- Send emails to project maintainers

---

## 🎉 Acknowledgments

Thanks to all developers and researchers who contributed to this project!

## 📚 Related Resources

- [PyTorch Official Documentation](https://pytorch.org/docs/)
- [LDPC Code Theory](https://en.wikipedia.org/wiki/Low-density_parity-check_code)
- [Google Colab](https://colab.research.google.com/)
- [Jupyter Notebook](https://jupyter.org/)