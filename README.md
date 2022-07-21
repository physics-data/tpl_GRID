# GRID: 伽马射线暴响应模拟

提示：如果你无法渲染其中的公式，请阅读 `README.pdf`，两者内容相同。

## 问题背景

本次大作业设计基于"天格计划"的相关内容，模拟伽马射线在探测器产生的能谱分布。

![GRID logo](figures/tglogo.jpg)

### 伽马射线暴

伽马射线暴（gamma-ray bursts，GRBs）指的是天空中某一方向的伽马射线强度在短时间内突然增强，随后又迅速减弱的现象，持续时间从十多微秒到几个小时不等。

大多数伽马射线暴被认为来自于大质量恒星坍缩为一个中子星或黑洞的过程。其中的一个子类短伽马射线暴（典型持续时间 0.3s）出现于两个致密天体（例如中子星或黑洞）合并事件中，被认为是引力波在伽马射线波段的电磁对应体。

### GRID (Gamma-Ray Integrated Detectors)

GRID 将地球低轨道（500-600 km）运行的若干个立方星（CubeSats）组成监测网络，使用搭载于其上的闪烁体探测器来监测能量为 10 keV 到 2 MeV 的短伽马射线暴。

闪烁探测器的结构如下图所示：

![detector](figures/detector2.png)

探测器使用晶体闪烁体（掺 $\mathrm{\small Ce\ Gd_3(Al,Ga)_5 O_{12}}$, GAGG）和 SiPMs 来探测$\gamma$射线。
其中 $\gamma$ 射线使闪烁体发出闪烁光子，SiPMs 利用光电效应将闪烁光子变为电子并进行倍增，经由前置放大器输出电子学信号。
ESR 为增强镜面反射镜（enhanced specular reflector），作为 $\gamma$ 射线入射到闪烁体的窗口和闪烁体的反射层。

### Gamma 在探测器中的信号生成过程

一般闪烁体的工作原理为：入射辐射在闪烁体内损耗并沉积能量，引起闪烁体中原子（或离子，分子的）电离激发，之后受激粒子退激放出波长接近于可见光的闪烁光子。Gamma 射线在闪烁体内有三种主要的能量沉积方式：光电吸收、康普顿散射和电子对效应。光子的能量在光电吸收和电子对效应中被完全吸收，而在康普顿散射中仅有部分光子能量发生沉积。如果闪烁光子击中了SiPMs，产生的光电子经过倍增后得到电信号，经由前放和模数转换，电子学信号分析处理等过程后可以得到探测器实际观测到的 $\gamma$ 能谱。

然而，探测器测得的能谱与入射粒子的真实能量分布并不同（与 $\gamma$ 光子能量，入射角度，能量分辨率等有关），两者可以通过一个与探测器相关的“响应矩阵”来联系：

$$
\begin{pmatrix}
E_{i1} & E_{i2} & \cdots E_{in}
\end{pmatrix}
\begin{pmatrix}
a_{11} & a_{12} & \cdots & a_{1m}\\
a_{21} & a_{22} & \cdots & a_{2m}\\
\vdots & \vdots & \ddots & \vdots\\
a_{n1} & a_{n2} & \cdots & a_{nm}
\end{pmatrix}
=\begin{pmatrix}
E_{o1} & E_{o2} & \cdots & E_{om}
\end{pmatrix}
$$

我们已经通过蒙特卡罗模拟得到了若干不同方位的探测器晶体响应矩阵，详见[数据说明](#数据说明)。

## 作业要求（功能部分）

本次作业尝试模拟伽马射线暴在三个立方星探测器产生的信号.

### Makefile

本次作业提供了 `Makefile`，最终助教也将使用 `Makefile` 进行测试。需要注意，你在编写所有程序文件时，都应该使用 `make` 给程序传入的参数（来自 `sys.argv`），而非硬编码下面提到的文件名；否则，你可能无法通过测试。

在本目录中运行 `make -n` 即可看到实际运行的命令，这或许能帮助你开发。

### 数据说明

所有的输入数据存放在 `data` 文件夹下，请不要轻易改动这个文件夹下的内容。

注意助教在评分时可能会替换这些常数，因此你**不能直接硬编码**常数.

#### `constant.json`

包含 Gamma 射线源和三个立方星的天球坐标和轨道高度（假设三颗卫星位置固定），地球半径。

| 名称         | 说明                  |
| ------------ | --------------------- |
| `gamma_RA`     | Gamma 源赤经 (h.m.s)   |
| `gamma_Dec`    | Gamma 源赤纬 (deg)     |
| `CubeSat1_RA`  | 1号立方星赤经 (h.m.s)  |
| `CubeSat1_Dec` | 1号立方星赤纬 (deg)    |
| `CubeSat2_RA`  | 2号立方星赤经 (h.m.s)  |
| `CubeSat2_Dec` | 2号立方星赤纬 (deg)    |
| `CubeSat3_RA`  | 3号立方星赤经 (h.m.s)  |
| `CubeSat3_Dec` | 3号立方星赤纬 (deg)    |
| `altitude_1`   | 1号立方星轨道高度 (km) |
| `altitude_2`   | 2号立方星轨道高度 (km) |
| `altitude_3`   | 3号立方星轨道高度 (km) |
| `radius_earth` | 地球半径 (km)          |
| `mu` | 本底期望值 (count/s)|
| `sigma` | 本底标准差 (count/s)|

此外，假设三个立方星的探测器晶体朝向为**球面外法线方向**。

#### `source.h5`

该文件中有3个表格:

- `Energy`：100 个能道的上下边界值（长度为101），单位为 keV。

    |     | Energy  |
    | -   | ------- |
    | 0   | 4.52515 |
    | 1   | 4.80936 |
    | 2   | 5.11141 |
    | $\vdots$ | $\vdots$ |
    | 19  | 14.3966 |
    | 20  | 15.3007 |
    | $\vdots$ | $\vdots$ |
    | 99 | 1881.81 |
    | 100 | 2000.00 |

- `Time`: 光变曲线（Gamma 光子计数率 vs 时间）的时间轴（长度为625），单位为 s。本文件中所有光变曲线的时间轴相同。

    |     | Time  |
    | -   | ------- |
    | 0   | 10.0324 |
    | 1   | 10.0964 |
    | 2   | 10.1604 |
    | $\vdots$ | $\vdots$ |
    | 623 | 49.9044 |
    | 624 | 49.9684 |

- `Rate`：光变曲线的计数率（size: 100x625），单位为 count/s. 每一行代表一个能道的光变曲线，能道编号 `i` 与 `Energy` 中的能量边界值编号 `i` 和 `i+1` 对应。

    |          |   $t_1$  |   $t_2$  | $\cdots$ |$t_{624}$ | $t_{625}$  |
    | -        | -------  | -------  | -------  |- | -------  |
    | 0        | 0  | 0  | $\cdots$ | 15.71  | 0 | 
    | $\vdots$ | $\vdots$ | $\vdots$ | $\ddots$ | $\vdots$ | $\vdots$ |
    | 19       | 47.10  | 47.09  | $\cdots$ |31.42 | 62.75  |
    | $\vdots$ | $\vdots$ | $\vdots$ | $\ddots$ |$\vdots$ | $\vdots$ |
    | 99       | 172.71  | 125.58  | $\cdots$ | 157.11 | 94.13  |

    例如，能道 14.4\~15.3 keV 的光变曲线在 `Energy` 中的编号为19 和 20，对应在 `Rate` 中的行号为 19，其曲线如下图所示：

    ![example curve](figures/example_curve.png)

#### `matrix.h5`

探测器晶体响应矩阵，数据大小为 $3360\times4\times100$。

- “$3360$” 对应 ATTRIBUTE 中的 Index，即40（个输入能量）x 7（个$\theta$）x 12（个$\phi$）= 3360；
- “$4$” 对应 $4$ 个闪烁晶体；
- “$100$” 对应输出的 100 个能道，与 ATTRIBUTE 中的 `Edges` 对应。

### 基本要求

作业功能部分（占80分）的基础要求为模拟高能 $\gamma$ 光子在探测器中的响应，分成以下几部分，完成各个任务即可拿到相应分数：

| 任务（程序名）             | 分数 |
| ----------------------- | ---- |
| `energy_spectrum.py`    | 20   |
| `source_generate.py`    | 15   |
| `calculate_response.py` | 30   |
| `plot_signal.py`        | 15   |

#### `energy_spectrum.py`

根据 `source.h5` 中的数据，作出 $\gamma$ 光子的能谱，横轴为能量（keV），纵轴为单位能量的计数率（count/s-keV）。将结果保存为`sepctrum.png`。

#### `source_generate.py`

将$\gamma$光子和本底计数率相加，得到进入探测器的伽马射线的光变曲线（计数率 versus 时间）。假设每个能道的X射线本底均匀，对任意时刻的计数率服从分布$N(\mu，\sigma^2)$。

输出结果为光变曲线 `light_curve.png` 和数据文件 `light_curve.h5`（格式与 `source.h5` 相同）。
其中 `light_curve.png` 中需要绘制出能量范围 0\~100 keV，100\~200 keV 和 200\~300 keV 内的光变曲线，并在图例中标注能量范围。

#### `calculate_response.py`

伽马暴源的位置距离地球很远，因此可将 $\gamma$ 射线视为从源方向平行到达地球。
根据 `constant.json` 中的位置信息和探测器响应 `matrix.h5`，
以及上一步得到的 `light_curve.h5`，求出在三个立方星上晶体的响应能谱（每个探测晶体相对源方向的响应矩阵可由最近方位的若干个响应矩阵插值得到）。

注意需要根据 Gamma 源和卫星位置判断是否能够接收到信号（仅考虑地球的遮挡），以及信号的时序关系（说明即可）。
将该段时间内的总响应能谱保存到 `energy_response.h5` 中，并在报告中详细说明该H5文件中的数据组织结构。

#### `plot_signal.py`

根据上一步的响应计算结果，在同一张图中绘制出探测器响应能谱随时间的变化，使用 GIF 动画展示，输出文件保存为 `energy_response.gif`。注意在图中注明必要的信息。

### 提高要求

提高要求为加分项，至多可加 10 分。你可以自由发挥，例如：

1. 给出具有某一姿态（四元数）的立方星对某一天球方位 Gamma 源的响应矩阵；
2. 从探测器基本原理出发，提出计算探测器响应的其他模型，并予以必要推导和代码实现。

提高部分的内容不仅仅局限于以上内容，你可以对某个具体的物理过程自由发挥。如果你实现了任何提高要求，请在实验报告中详细说明你的工作，这将作为评分的依据。

## 作业要求（非功能部分）

非功能部分的要求详见大作业公告，此部分占 20 分。

## 参考文献

1. Wikipedia contributors. "Gamma-ray burst." Wikipedia，The Free Encyclopedia. Wikipedia，The Free Encyclopedia，5 Jul. 2021. Web. 31 Jul. 2021. 
2. Jiaxing Wen，Xiangyun Long，Xutao Zheng，Yu An，Zhengyang Cai，Jirong Cang，Yuepeng Che,Changyu Chen，Liangjun Chen，Qianjun Chen，and et al. Grid: a student project to monitor the transient gamma-ray sky in the multimessenger astronomy era. *Experimental Astronomy*，48(1):77–95，Aug 2019.
3. 陈伯显. 核辐射物理及探测学[M]. 哈尔滨: 哈尔滨工程大学，2011.
