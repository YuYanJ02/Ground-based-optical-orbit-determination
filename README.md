# Ground-based Optical Observation OD

地基光学观测下的 **DRO 卫星轨道确定（Orbit Determination, OD）与光度特性分析** 工具集。本项目面向地月空间 DRO-A/B 卫星的地基光学实测数据，涵盖 MPC80 观测解析、CCSDS TDM 转换、ODTK 自动化定轨、STK 轨道对比与误差评估，以及漫反射-镜面反射光度模型验证等完整分析流程。

## 研究背景

本项目支撑论文 *《基于地基光学观测的 DRO 卫星光度与定轨特性分析》* 中的数据处理与数值实验，主要研究内容包括：

- **光度分析**：采用漫反射-镜面反射球体模型预测理论星等，与实测数据对比，评估姿态变化对亮度波动的影响。
- **轨道确定**：基于 Gooding 初定轨（IOD）与批处理最小二乘（BLS），系统评估观测弧段长度、测站数量、标量三重积（STP）/视线条件数（LOS Cond）等因素对定轨精度的影响。
- **误差评估**：在 STK 中将 ODTK 定轨结果与参考轨道对比，量化径向、切向等误差分量。

## 功能概览

| 模块 | 功能 |
|------|------|
| **数据预处理** | MPC80 原始观测解析与标准化，转换为 CCSDS 503.0-B-2 TDM 格式 |
| **ODTK 定轨** | 通过 MATLAB API 自动配置场景、测站、测量噪声与力学模型，运行 IOD / BLS / 滤波 |
| **IOD 扫描** | 遍历 C(n,3) 三点组合，记录 STP、时间跨度与定轨收敛性 |
| **STK 评估** | 导入 ODTK 星历，与参考轨道对比，输出位置误差及日月位置 |
| **光度分析** | 理论星等模型与实测对比，分析相位角、距离与姿态对亮度的影响 |
| **可视化** | 全球测站分布图、时间-几何条件数-定轨精度散点图等 |

## 目录结构

```text
code/
├── [20260107]ODTK_code_yyj/          # 核心定轨与数据分析模块
│   ├── main_odtk.m                   # ODTK 长弧定轨 + IOD 三点组合扫描
│   ├── main_STP.m                    # 基于 STP 的 IOD 选点与短弧定轨
│   ├── main_stk.m                    # STK 读取 ODTK 星历并提取目标/月球状态
│   ├── main_stk_dis.m                # 定轨轨道 vs 参考轨道距离评估
│   ├── main_mag.m                    # 光度模型与实测星等对比
│   ├── main_TimeGeometryCompr.m      # 时间跨度 × LOS 条件数 × 定轨精度可视化
│   ├── main_station_map.m            # 全球观测测站分布图
│   ├── main_StationNoise.m           # 测站测量噪声蒙特卡洛分析
│   ├── main_WhiteNoise.m             # 白噪声敏感性分析
│   ├── READ_MPC80.m                  # MPC80 原始数据解析
│   ├── MPC2TDM.m                     # MPC80 → TDM 转换
│   ├── GetStationCoordinates.m       # 测站代码查经纬度
│   ├── MPC_Codes.txt                 # MPC 测站代码与坐标表
│   ├── ground_station.txt            # 测站经纬度备用表
│   ├── obs/、obs2/                   # 不同任务 MPC80 观测样例
│   ├── ephemeris/                    # 参考星历（OEM 等）
│   └── STK/                          # STK 场景配置文件
│
├── toYYJ/                            # STK 光学观测仿真与光度对比
│   ├── main_optical_cmpar.m          # 光学观测与 STK 仿真对比（含光行时、姿态）
│   ├── main_Astrometry.m             # 天体测量误差分析
│   ├── ReadEph.m                     # 读取星历初值
│   ├── ReadAtt.m                     # 读取姿态数据
│   └── EphAll/                       # 星历 XML 文件
│
├── toYYJ_groundOptical/              # STK 地基光学观测场景
│   ├── toYYJ_Ground_Optical.sc       # STK 场景主文件
│   └── ...                           # 卫星、测站、传感器等 STK 对象
│
└── EphAll/                           # 共享星历数据
```

## 环境要求

| 软件 | 版本 | 用途 |
|------|------|------|
| **MATLAB** | R2019a 及以上 | 主开发环境 |
| **AGI ODTK** | 7.x | 轨道确定（需开启 HTTP 服务，默认端口 9494） |
| **AGI STK** | 12 | 场景仿真、星历读取、Astrogator 传播 |
| **Mapping Toolbox** | 可选 | `main_station_map.m` 卫星底图（无则自动降级） |

### ODTK MATLAB API 配置

```matlab
addpath('C:\Program Files\AGI\ODTK 7\CodeSamples\CrossPlatform\ODTK\matlab\lib');
client = Client('localhost', 9494);
```

### STK COM 接口

```matlab
uiApplication = actxserver('STK12.application');  % 新建实例
% 或
uiApplication = actxGetRunningServer('STK12.application');  % 连接已有实例
```

## 快速开始

### 1. 克隆仓库并进入工作目录

```bash
git clone <your-repo-url>
cd code/[20260107]ODTK_code_yyj
```

> **注意**：部分脚本内含硬编码的绝对路径（如 `D:\documents\keyan\...`），运行前请根据本机环境修改 `file_trace`、星历路径、STK 场景路径等变量。

### 2. MPC80 → TDM 转换

```matlab
% 解析原始 MPC80 观测并标准化
READ_MPC80('DROB_20251026_27.txt', 'MPC80_DROB_20251026_27.txt');

% 转换为 CCSDS TDM
[targets, stations, mag, time] = MPC2TDM( ...
    'MPC80_DROB_20251026_27.txt', 'TDM_DROB_20251026_27.tdm');
```

### 3. ODTK 光学定轨

1. 启动 ODTK 并开启 HTTP 服务（端口与脚本一致，如 9494）。
2. 在 MATLAB 中运行：

```matlab
main_odtk      % 长弧定轨 + 全部 C(n,3) IOD 组合扫描
% 或
main_STP       % 基于 STP 的 IOD 选点与短弧定轨
```

脚本将自动：创建 Scenario → 加载 TDM → 配置卫星力学模型 → 创建 TrackingSystem 与光学测站 → 设置 RA/Dec 测量噪声 → 运行 IOD / BLS。

### 4. STK 轨道误差评估

```matlab
% 仅读取定轨星历
[Target, Moon] = main_stk('path\to\odtk_ephemeris.e');

% 对比定轨结果与参考轨道
[dis, t, Sun, Moon, Target, Target_real] = main_stk_dis('path\to\odtk_ephemeris.e');
```

### 5. 光度与可视化分析

```matlab
main_mag                    % 光度模型 vs 实测散点对比
main_TimeGeometryCompr      % 时间-几何-精度关系图（需先运行 main_odtk 生成 TPAll.mat）
main_station_map            % 全球测站分布
plot_od_error_compare       % 定轨误差对比图
```

## 主要脚本说明

### 定轨流程

| 脚本 | 说明 |
|------|------|
| `main_odtk.m` | 长弧定轨主流程；遍历所有三点 IOD 组合，记录 STP、平均定轨误差 |
| `main_STP.m` | 基于标量三重积筛选 IOD 观测值，结合距离约束的短弧定轨 |
| `main_odtk1.m` | 定轨流程变体（简化配置） |
| `recompute_TPAll_STP.m` | 重算 TPAll 中的 STP / LOS 条件数 |

### 误差与敏感性分析

| 脚本 | 说明 |
|------|------|
| `main_stk_dis.m` | ODTK 定轨 vs 参考轨道位置误差（km） |
| `main_StationNoise.m` | 测站 RA/Dec 噪声蒙特卡洛 |
| `main_WhiteNoise.m` | 白噪声 sigma 扫描 |
| `range_residual_search.m` | 短弧距离约束搜索 |

### 光度与光学仿真

| 脚本 | 说明 |
|------|------|
| `main_mag.m` | 漫反射-镜面反射模型星等预测与实测对比 |
| `Calculate_Mag.m` / `Calculate_LimitingMagnitude_BZ.m` | 星等计算工具函数 |
| `main_optical_cmpar.m` | STK 中光学观测仿真（光行时、恒星像差、姿态） |
| `main_Astrometry.m` | 天体测量残差分析 |

### 工具函数

| 函数 | 说明 |
|------|------|
| `READ_MPC80.m` | MPC80 格式解析与清洗 |
| `MPC2TDM.m` | 生成 CCSDS TDM，含观测时间线可视化 |
| `GetStationCoordinates.m` | 由 MPC 代码查测站经纬度 |
| `geodetic_to_eci_km.m` | 大地坐标 → ECI |
| `topo_j2000_radec_to_geocentric_unit.m` | 站心 RA/Dec → 地心 J2000 单位视线矢量 |
| `plotOdPositionError.m` | 定轨位置误差曲线绘制 |

## 观测测站

本项目使用的地基光学测站（MPC 代码）包括：

| 代码 | 站点 |
|------|------|
| K19 | PASTIS, Banon |
| N56 | 阿里 JIST |
| O17 | 冷湖-1 |
| O46 | 稻城 |
| P13 | 百花山 |
| D29 | 盱眙 |
| U74 | JPL Auberry |
| I52 | Mt. Lemmon |
| 703 | Catalina |

坐标信息见 `MPC_Codes.txt` 与 `ground_station.txt`。

## 示例数据

仓库中包含部分公开或脱敏的观测与中间结果样例：

- `obs/`、`obs2/`：MPC80 格式原始光学观测
- `MPC80_*.txt` / `TDM_*.tdm`：已处理的观测与 TDM 文件
- `ephemeris/`：参考轨道 OEM 星历
- `TP_IOD_scan_detail*.csv`：IOD 组合扫描结果
- `MonteCarlo_*.csv`：蒙特卡洛分析输出

## 典型工作流

```text
MPC80 原始观测
    │
    ▼
READ_MPC80 ──► MPC2TDM ──► TDM 文件
    │
    ▼
main_odtk / main_STP ──► ODTK IOD + BLS 定轨 ──► 星历 (.e)
    │
    ├──► main_stk_dis ──► 与参考轨道对比误差
    │
    ├──► main_TimeGeometryCompr ──► 时间/几何 vs 精度分析
    │
    └──► main_mag / main_optical_cmpar ──► 光度特性分析
```

## 注意事项

1. **路径配置**：脚本中多处使用 Windows 绝对路径，上传至 GitHub 后请根据本机环境修改。
2. **商业软件许可**：ODTK 与 STK 为 AGI/Ansys 商业软件，使用前请确保已获合法授权。
3. **ODTK 服务**：运行定轨脚本前须先启动 ODTK 并开启 HTTP 服务；端口需与脚本中 `Client('localhost', 9494)` 一致。
4. **STK 场景**：`toYYJ_groundOptical/` 与 `[20260107]ODTK_code_yyj/STK/` 中的场景文件体积较大，可按需选择性上传；建议配合 `.gitignore` 排除日志与临时文件。
5. **`.asv` 文件**：MATLAB 自动备份文件，建议不要纳入版本控制。

## 建议的 .gitignore

```gitignore
# MATLAB
*.asv
*.m~

# IDE
.idea/

# STK / ODTK 日志
**/LogFiles/

# 大型二进制（按需保留）
# *.sa3
# *.sc3
```

## 引用

若在论文或项目中使用本仓库，请引用：

> 俞言骏, 孙洋, 张皓. 基于地基光学观测的 DRO 卫星光度与定轨特性分析. 中国科学院空间应用工程与技术中心, 2026.

## 许可

本仓库代码仅供科研与教学参考。ODTK 与 STK 的使用须遵守 AGI/Ansys 相应许可协议。
