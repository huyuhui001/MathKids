# MathKid - 数学小能手 🧮

<div align="center">

一个用于练习加减法的 iOS 应用

[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Open Source](https://img.shields.io/badge/Open%20Source-❤-red.svg)](https://github.com)

*完全免费开源*

</div>

---

## 📖 目录

- [概述](#-概述)
- [功能特色](#-功能特色)
- [使用指南](#-使用指南)
- [技术规格](#-技术规格)
- [项目结构](#-项目结构)
- [架构设计](#-架构设计)
- [游戏流程](#-游戏流程)
- [游戏逻辑](#-游戏逻辑)
- [本地化](#-本地化)
- [贡献指南](#-贡献指南)
- [路线图](#-路线图)
- [许可证](#-许可证)

---

## 🌟 概述

**MathKid（数学小能手）** 是一个用于**练习加减法**的 iOS 应用。它采用进阶式关卡体系（入门 → 基础 → 提升），配合 MathSuperKid 风格的活泼界面，让加减法练习变得更加有趣。用户可以自定义题型与题量，获得即时反馈，并通过积分与等级系统追踪学习进度。

### 核心亮点

- 🎨 **MathSuperKid 风格的渐变界面**
- 📈 **3 个渐进式关卡**（10以内 → 20以内 → 两位数）
- 🧩 **可自定义题型与题量**（每种题型 1–999 题）
- ✅ **即时逐题反馈**（✓/✗ 标记 + 正确答案提示）
- 🏆 **积分与等级系统**（每答对 +10 分，每 100 分升一级）
- 🔄 **"再练一次"自动生成新题**
- 🚀 **100% SwiftUI，无 UIKit**

---

## 🎯 功能特色

### 📚 三个学习阶段

| 阶段 | Emoji | 数字范围 | 说明 |
|------|-------|----------|------|
| **入门** | 🌱 | 10 以内 | 简单加减法 |
| **基础** | ☀️ | 20 以内 | 不进位 / 进位 / 不退位 / 退位 多种变体 |
| **提升** | 🌟 | 两位数 | 两位数加减法 |

### 🧩 题型配置

每个阶段都提供精心设计的题型。用户可勾选要练习的题型，并自定义每种题型的题量（1–999 题）。

#### 入门阶段

| 类型 ID | 名称 | 示例 |
|---------|------|------|
| `add_10` | 10 以内加法 | 3 + 5 = 8 |
| `sub_10` | 10 以内减法 | 8 − 3 = 5 |

#### 基础阶段

| 类型 ID | 名称 | 示例 |
|---------|------|------|
| `add_no_carry_20` | 20 以内不进位加法 | 12 + 5 = 17 |
| `sub_no_borrow_20` | 20 以内不退位减法 | 18 − 5 = 13 |
| `add_carry_20` | 20 以内进位加法 | 8 + 5 = 13 |
| `sub_borrow_20` | 20 以内退位减法 | 15 − 8 = 7 |

#### 提升阶段

| 类型 ID | 名称 | 示例 |
|---------|------|------|
| `add_2digit` | 两位数加法 | 23 + 45 = 68 |
| `sub_2digit` | 两位数减法 | 68 − 23 = 45 |

### 🎮 游戏化系统

- **答对得分**：每题答对 **+10 分**（固定）
- **升级规则**：`Level = (总积分 / 100) + 1` —— 每 **100 分**升一级
- **累积积分**：通过 `UserProgress` 跨会话追踪
- **重置进度**：调用 `UserProgress.reset()` 清空

### 📊 实时统计栏

练习过程中，顶部统计栏实时显示：

| 统计 | 图标 | 说明 |
|------|------|------|
| 正确 | ✅ | 答对题数 |
| 错误 | ❌ | 答错题数 |
| 得分 | ⭐ | 当前会话得分 |
| 用时 | ⏱️ | 已用时间（mm分ss秒） |

### 🎯 结果反馈

表现评语根据正确率自动调整：

| 正确率 | 图标 | 评语 |
|--------|------|------|
| ≥ 90% | 🏆 trophy.fill | "太棒了！🎉" / "完美表现！" |
| ≥ 70% | ⭐ star.fill | "做得不错！🌟" / "表现优秀！" |
| ≥ 50% | 🚩 flag.fill | "还需努力！" |
| < 50% | 🚩 flag.fill | "继续加油！💪" |

### ⚙️ 类别选择工具

- **全选 / 全不选**：一键勾选或取消所有题型
- **综合练习开关**：自动全选所有题型
- **每种题型独立设置题量**：1–999 题自由配置

---

## 📱 使用指南

### 游戏流程

```
1. MainMenuView         →  选择阶段（入门 / 基础 / 提升）
   主菜单

2. CategorySelectionView →  勾选题型并设置题量
   类别选择

3. GameView             →  答题并提交
   练习界面

4. ResultView           →  查看成绩、再练一次或返回主页
   结果界面
```

### 分步操作

#### 1. 启动并选择阶段

打开 MathKid。点击阶段卡片（🌱 入门 / ☀️ 基础 / 🌟 提升），再点击底部 **"开始练习"** 按钮进入下一步。

#### 2. 配置题型

- ✅ 点击圆形复选框选择/取消题型
- 🔢 点击数字框设置题目数量（1–999）
- 🌐 打开 **"综合练习"** 开关将自动全选所有题型
- 📊 总题数会动态显示
- ▶️ 点击 **"开始练习"** 开始答题

#### 3. 答题

- 在每道题的输入框中输入答案
- 状态图标含义：⭕（未答）、🟠 省略号（有答案未提交）、✅（正确）、❌（错误）
- 答完题后点击 **"提交答案"** 一次性提交所有答案
- 答错的题目会以红色显示正确答案
- 点击 **"完成练习"** 查看结果

#### 4. 查看结果

结果界面显示正确率、得分、用时、总分和当前等级。可选择 **"再练一次"** 重新生成同一阶段的题目，或 **"返回主页"** 回到主菜单。

### 导航提示

| 操作 | 说明 |
|------|------|
| **返回菜单** | 在任意界面使用"返回"按钮 |
| **再练一次** | 在结果界面重新生成新题 |
| **主页** | 返回主菜单 |

---

## 🔧 技术规格

### 系统要求

| 项目 | 要求 |
|------|------|
| **最低 iOS 版本** | iOS 15.0 |
| **支持设备** | iPhone, iPad |
| **屏幕方向** | 竖屏（推荐） |
| **显示** | 所有屏幕尺寸优化 |
| **Xcode 版本** | Xcode 15.0+ |

### 技术栈

- **语言**：Swift 5.0
- **UI 框架**：SwiftUI（100% SwiftUI，无 UIKit）
- **架构**：MVVM + ObservableObject
- **状态管理**：`@StateObject`、`@EnvironmentObject`、`@Published`、Combine
- **数据持久化**：UserDefaults（语言偏好）
- **本地化**：字符串目录（`.xcstrings`）
- **导航**：`NavigationStack` + 自定义 `NavigationManager`（共享状态）

---

## 📁 项目结构

```
MathKid/
├── MathKidApp.swift                  # 应用入口 (@main)
├── ContentView.swift                 # 根视图，注入环境对象
├── Info.plist                        # 应用配置
├── Localizable.xcstrings             # 字符串目录
│
├── Models/                           # 数据模型
│   ├── AppSettings.swift             # 语言与应用配置
│   ├── DifficultyLevel.swift         # 难度枚举 (easy/medium/hard/custom)
│   ├── MathQuestion.swift            # 运算类型 (addition/subtraction)
│   └── UserProgress.swift            # 积分、等级
│
├── Views/                            # SwiftUI 视图
│   ├── MainMenuView.swift            # 关卡选择 + 提示
│   │                                 # + LevelType 枚举 + Color(hex) 扩展
│   ├── CategorySelectionView.swift   # 题型与题量配置
│   │                                 # + LevelInfo / QuestionTypeConfig
│   ├── GameView.swift                # 答题界面 + GameSession
│   │                                 # + QuestionGenerator + MathQuestion
│   └── ResultView.swift              # 结果页
│
└── Helpers/                          # 辅助工具
    ├── LocalizedText.swift           # 本地化文本组件
    └── NavigationManager.swift       # 导航状态管理
```

---

## 🏗️ 架构设计

### MVVM 模式

```
┌──────────────────────────────────────────┐
│              Views (SwiftUI)             │
│              视图层 (SwiftUI)              │
│  - MainMenuView                          │
│  - CategorySelectionView                 │
│  - GameView                              │
│  - ResultView                            │
└─────────────────┬────────────────────────┘
                  │ @EnvironmentObject
                  ↓
┌──────────────────────────────────────────┐
│        ViewModels / ObservableObjects    │
│        视图模型 / 可观察对象                │
│  - AppSettings      (language, locale)   │
│  - UserProgress     (score, level)       │
│  - NavigationManager (nav state)         │
│  - GameSession      (quiz session)       │
└─────────────────┬────────────────────────┘
                  │
                  ↓
┌──────────────────────────────────────────┐
│              Data / Models               │
│              数据 / 模型                   │
│  - LevelType, DifficultyLevel            │
│  - MathQuestion, QuestionTypeConfig      │
│  - UserDefaults (language persistence)   │
└──────────────────────────────────────────┘
```

### 状态管理

| 包装器 | 用途 | 使用位置 |
|--------|------|----------|
| `@StateObject` | 视图私有状态 | `ContentView`, `GameView`, `MainMenuView` |
| `@EnvironmentObject` | 应用级共享状态 | `AppSettings`, `UserProgress`, `NavigationManager` |
| `@Published` | 响应式属性 | 所有 ObservableObject 模型 |
| `@State` | 局部视图状态 | 表单输入、导航标志 |
| `@Binding` | 双向绑定 | `QuestionTypeConfig` 编辑器 |

### 导航流程

`NavigationManager` 集中管理导航状态：

```
MainMenuView
   │  点击阶段卡片
   ↓
CategorySelectionView (selectedLevel)
   │  点击"开始练习"
   ↓
GameView (level, difficulty, questionCount)
   │  点击"完成练习"
   ↓
ResultView (gameSession)
   │  "再练一次" → gameResetTrigger++ → GameView 重新生成题目
   │  "返回主页" → shouldPopToRoot → 回到 MainMenuView
```

---

## 🎲 游戏逻辑

### 题目生成

在 `GameView.swift` 的 `QuestionGenerator` 中实现：

- **随机生成**：每次会话在 `onAppear` 时生成全新题目
- **0 也是有效答案**：只有非空答案才会被自动提交
- **减法约束**：`num2 ≤ num1`，避免出现负数结果
- **重练重新生成**：点击"再练一次"会递增 `gameResetTrigger`，触发 `GameView.onAppear` 重新生成题目

### 评分规则

```swift
// GameSession.submitAnswer
if answer == question.correctAnswer {
    correctAnswers += 1
    score += 10      // 固定 10 分
} else {
    wrongAnswers += 1
}
```

### 等级计算

```swift
// UserProgress.updateLevel
currentLevel = (totalScore / 100) + 1
```

| 总分 | 等级 |
|------|------|
| 0–99 | 1 |
| 100–199 | 2 |
| 200–299 | 3 |
| ... | ... |

---

## 🌐 本地化

### 支持的语言

| 语言 | 代码 | 状态 |
|------|------|------|
| English | `en` | ✅ 支持 |
| 简体中文 | `zh-Hans` | ✅ 支持 |

### 本地化文件

- `Localizable.xcstrings` —— 包含所有翻译的字符串目录
- `AppSettings` 提供 `localizedString(_:)` 和 `currentLocale`
- `LocalizedText` 是 SwiftUI 封装组件

> ⚠️ **提示**：虽然本地化基础设施已就位，但当前大部分 UI 文案仍为中文硬编码。后续工作应将硬编码字符串迁移至 `Localizable.xcstrings` 以实现完整的双语支持。

### 添加新语言

1. 在 Xcode 中打开 `Localizable.xcstrings`
2. 点击 "+" 添加新语言
3. 翻译所有键
4. 将硬编码字符串替换为 `appSettings.localizedString(_:)`
5. 全面测试新语言

---

## 🤝 贡献指南

我们欢迎贡献！这是一个开源项目，我们希望您的帮助使它变得更好。

### 如何贡献

1. **Fork 仓库**
2. **创建功能分支**

   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **提交更改**

   ```bash
   git commit -m 'Add some amazing feature'
   ```

4. **推送到分支**

   ```bash
   git push origin feature/amazing-feature
   ```

5. **开启 Pull Request**

### 贡献想法

| 想法 | 说明 |
|------|------|
| ➕➖✖️➗ 添加乘法与除法练习 | 扩展运算类型 |
| 🌐 完善双语字符串迁移 | 将硬编码字符串全部迁移到 `Localizable.xcstrings` |
| 🎨 设计应用图标和资源 | 优化视觉资源 |
| 📊 添加统计图表 | 可视化练习数据 |
| 🎵 实现音效 | 增强反馈体验 |
| ⏱️ 添加每题倒计时 | 增加挑战性 |
| 🏆 创建成就徽章 | 完善游戏化系统 |
| 📱 iPad 优化布局 | 适配大屏设备 |
| ♿ 无障碍改进 | 支持辅助功能 |
| 🐛 Bug 修复 | 提升稳定性 |

---

## 🗺️ 路线图

### 计划功能

| 功能 | 描述 |
|------|------|
| ➕➖✖️➗ 乘法与除法练习 | 扩展支持的运算类型 |
| 🎵 音效与动画 | 增强交互反馈 |
| ⏱️ 每题计时模式 | 增加挑战性 |
| 📊 统计仪表板 | 详细数据展示 |
| 🎯 自定义数字范围练习 | 灵活配置练习范围 |
| 👥 本地多人模式 | 支持多人对战 |
| 🏆 成就徽章 | 激励持续学习 |
| 🌙 深色模式支持 | 适配系统主题 |
| 📱 小组件支持 | 主屏快速入口 |
| 🌍 更多语言支持 | 国际化扩展 |
| ♿ 完整 VoiceOver 支持 | 提升无障碍体验 |

---

## 🐛 已知限制

- 应用内语言切换 UI 尚未接入；当前文案以中文硬编码为主
- `DifficultyLevel` 枚举定义了 easy/medium/hard/custom，但实际流程只使用 `custom`（由用户配置题量驱动）
- 乘法与除法计划中，尚未实现

---

## 📄 许可证

### MIT 许可证

```
MIT License

Copyright (c) 2025 MathKid

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

**本软件完全免费且开源！**

---

## 🙏 致谢

- 用 ❤️ 使用 SwiftUI 构建
- 图标来自 SF Symbols
- UI 风格参考 MathSuperKid

---

## 📞 联系与支持

- **问题**：请通过 GitHub Issues 报告 bug
- **疑问**：在 GitHub Discussions 开启讨论

---

<div align="center">

**为练习加减法用心打造**

⭐ **如果觉得有帮助，请给这个项目点个星！**

---

**🆓 100% Free | 完全免费**

**💝 Open Source | 开源**

</div>
