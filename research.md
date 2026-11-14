# prompt-translate 调研报告

日期：2026-11-14 ｜ 调研方式：4 路并行（GitHub / arXiv / 权威文章 / HuggingFace）｜ 结论已吸收进 skill（v1.2.0+）

## 结论摘要

1. **GitHub**：无完全匹配的现成 skill；两个中文 repo（universal-prompt-optimizer、intent-to-prompt）此前已吸收。本轮深挖 8 个 repo，最有价值的是 `dsh-prompt-rewriter`（逐字事实锁、显式委托代替反问）与 `claude-code-prompt-improver`（门禁直通，1969★）。
2. **论文**：12 条有实验证据的结论，一致指向"**精确化 + 可验证验收**"路线，反对咒语、人设、默认 CoT、超多约束。
3. **文章**：Anthropic/OpenAI/Google/Lilian Weng/Brex 五方共识：具体到可判定、说做什么而非不做什么、分隔符分节、结尾复述关键约束。
4. **HuggingFace**：8 个 prompt 改写小模型全是玩具级（最高 334 downloads），HF 无托管、需自建 GPU；**维持 harness 自带大模型方案**，不引入专用小模型后端。

## 一、GitHub 现成方案与采纳情况

| Repo | Stars | License | 技术要点 | 采纳 |
|---|---|---|---|---|
| [severity1/claude-code-prompt-improver](https://github.com/severity1/claude-code-prompt-improver) | 1969 | MIT | ~189 token 分级门禁：清晰 prompt 零开销直通；Research 先行；问题分级 1-6 个且选项必须来自实际检索 | ✅ 门禁/UNCHANGED；❌ 多轮 AskUserQuestion（依赖交互 UI，单轮场景会打断用户） |
| [huaguoxingkong/dsh-prompt-rewriter](https://github.com/huaguoxingkong/dsh-prompt-rewriter) | 274 | MIT | 六维 GOAL/INPUTS/SCOPE(non-goals)/METHOD/OUTPUT/QUALITY BAR；逐字事实锁（"8-10"不能变"8 到 10"）；禁反问、缺信息"显式委托"；扩写 2-5 倍硬上限；5 问自检 | ✅ 几乎全部吸收 |
| [Jakeschincariol/promptmaster-skill](https://github.com/Jakeschincariol/promptmaster-skill) | 82 | MIT | 35 条浪费模式分 6 族；一轮批量澄清且每项带默认值；重写长度 ≤ 原文+缺失事实 | ✅ 反模式压缩为 8 条中文；长度上限 |
| [geq1fan/prompt-optimizer-skill](https://github.com/geq1fan/prompt-optimizer-skill) | 16 | MIT | 对抗评审（歧义/边界压力/自洽）作为独立角色；中文防跑偏三句；占位符保护 | ✅ 三轮对抗自检；输出契约措辞 |
| [linshenkx/prompt-optimizer](https://github.com/linshenkx/prompt-optimizer) | 41458 | AGPL-3.0 | LangGPT 结构模板库；评估与改写分离；中英成对模板 | ⚠️ 仅借鉴"按场景拆模板"思路；AGPL 且模板过度包装，不整段复制 |
| [langgptai/LangGPT](https://github.com/langgptai/LangGPT) | 12695 | Apache-2.0 | Role→Profile→Rules→Workflow 骨架；Attention 情绪槽位 | ❌ 适合造系统提示词/人设，不适合任务 brief；情绪槽位被论文证伪 |
| [ndpvt-web/prompt-improver](https://github.com/ndpvt-web/prompt-improver) | 87 | MIT | 模糊信号词清单；句式级转换；AXIOMS/TASK/METHOD/VERIFICATION 五段式 | ✅ 模糊词量化表 |
| [microsoft/PromptWizard](https://github.com/microsoft/PromptWizard) | 4033 | MIT | 生成→critique→refine 自进化；正负例混用；合成 CoT 嵌入 | ⚠️ 只借"生成-批评-精修"循环思路（离线流水线，在线场景不可用） |

## 二、arXiv 论文证据（12 条）

| # | 结论 | 证据 | 采纳 |
|---|---|---|---|
| 1 | 把模糊需求改写成精确指令是提升表现最可靠的一类改动（平均 +15.3%，最高 +31%）；RAG 查询改写稳定有效 | [APO/ProTeGi 2305.03495](https://arxiv.org/abs/2305.03495)、[PromptAgent 2310.16427](https://arxiv.org/abs/2310.16427)、[Query Rewriting 2305.14283](https://arxiv.org/abs/2305.14283) | ✅ 核心路线 |
| 2 | 不存在通用神奇句式；语义相近的指令准确率可天差地别，最优措辞随模型/任务漂移 | [OPRO 2309.03409](https://arxiv.org/abs/2309.03409)、[FormatSpread 2310.11324](https://arxiv.org/abs/2310.11324)（格式极差最高 76 分） | ✅ 不写固定咒语、不承诺提升数字 |
| 3 | 复杂需求按模块拆分（明确每步输入/输出）比雕琢一段话有效 | [DSPy 2310.03714](https://arxiv.org/abs/2310.03714) | ✅ 多步骤任务分步 |
| 4 | CoT 只在符号/数学/逻辑类任务有益；其余接近零甚至有害（最高 -36.3 分） | [Meta-analysis 2409.12183](https://arxiv.org/abs/2409.12183)、[2410.21333](https://arxiv.org/abs/2410.21333)、[2506.07142](https://arxiv.org/abs/2506.07142) | ✅ 默认不写"一步步思考" |
| 5 | 硬输出格式挤压推理；约束越多越难全部遵守；模型偏向靠前约束（500 条约束时最强模型仅 68%） | [2408.02442](https://arxiv.org/abs/2408.02442)、[IFEval 2311.07911](https://arxiv.org/abs/2311.07911)、[IFScale 2507.11538](https://arxiv.org/abs/2507.11538) | ✅ 约束 ≤5-7 条、按重要性排序、结尾复述；推理任务"先分析后按格式输出" |
| 6 | 带具体反馈的自精修有效（+20%）；无外部判据的"再检查"无效甚至改坏 | [Self-Refine 2303.17651](https://arxiv.org/abs/2303.17651)、[2310.01798](https://arxiv.org/abs/2310.01798) | ✅ 验收写成可验证判据+逐条对照自检 |
| 7 | 澄清收益大成本低；模型天然提问率 <20%；歧义题面让 Pass@1 降 35-52% | [HumanEvalComm 2406.00215](https://arxiv.org/abs/2406.00215)、[AwN 2409.00557](https://arxiv.org/abs/2409.00557)、[2502.13069](https://arxiv.org/abs/2502.13069) | ✅ 1 轮 1-3 问 + 产物内授权执行者"关键缺失先问" |
| 8 | 人设/情绪勒索/小费/威胁对客观任务无效，个别有负作用 | [2311.10054](https://arxiv.org/abs/2311.10054)、[2508.00614](https://arxiv.org/abs/2508.00614)、[2402.10949](https://arxiv.org/abs/2402.10949) | ✅ 去咒语、去人设 |
| 9 | 无关背景显著拉低准确率；关键信息放开头/结尾（U 形）最可靠 | [2302.00093](https://arxiv.org/abs/2302.00093)、[2307.03172](https://arxiv.org/abs/2307.03172) | ✅ 瘦背景+结尾复述关键约束 |
| 10 | 示例价值取决于贴近当前输入而非数量；数量增加成本线性上升 | [2101.06804](https://arxiv.org/abs/2101.06804)、[2404.11018](https://arxiv.org/abs/2404.11018) | ✅ 格式难描述时才给 1-3 个贴切示例 |
| 11 | 反例（错误示范+为什么错）比只给正面要求更约束行为 | [Contrastive CoT 2311.09277](https://arxiv.org/abs/2311.09277) | ✅ 常见错误表即反例清单 |
| 12 | 结构化分节整体正向但效应量被高估；作用在降歧义与防遗漏，不是"提升模型能力" | [26 Principles 2312.16171](https://arxiv.org/abs/2312.16171)、[Prompt Report 2406.06608](https://arxiv.org/abs/2406.06608) | ✅ 六维按需覆盖、不输出空模块 |

诚实边界：上述证据多来自英文基准与特定模型，效应量随模型/任务大幅波动。本 skill 的卖点是"把需求说清楚、把验收定清楚"，不是"找到神奇 prompt"；遇到不确定就显式写假设。

## 三、权威文章共识（15 条，按主题）

**结构**
1. 短/中 prompt 指令前置，分隔符把指令与材料隔开（也降低注入风险）— [OpenAI 官方指南](https://help.openai.com/en/articles/6654000-how-to-prompt-chatgpt)
2. 复杂 prompt 固定分节+一致标签，标签名与正文名词一致 — [Anthropic 最佳实践](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
3. 长材料放前面、任务要求放最后，用过渡句衔接 — [Google Gemini 指南](https://ai.google.dev/gemini-api/docs/prompting-strategies)
4. 格式难说清时给 1-3 个格式一致的示例 — [Lilian Weng](https://lilianweng.github.io/posts/2023-03-15-prompt-engineering/)

**清晰度**
5. 程度词全部量化："简短"→句数、"详细"→条数+数据、"专业"→术语密度与读者 — [OpenAI](https://help.openai.com/en/articles/6654000-how-to-prompt-chatgpt)
6. 写清结果用途与受众（CO-STAR 的 Objective/Audience 槽位）— [Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

**约束与边界**
7. 正向表述+替代动作代替否定清单；去"严禁/绝对"式恐吓 — [Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
8. 范围钉死："只实现用户要求的，不加功能；指令含糊时取最简单的合理解释" — [OpenAI GPT-5.2 指南](https://developers.openai.com/cookbook/examples/gpt-5/gpt-5-2_prompting_guide)
9. 缺信息不许猜：字段置空、事实不明标"待确认"、允许答"不知道" — [OpenAI GPT-5.2 指南](https://developers.openai.com/cookbook/examples/gpt-5/gpt-5-2_prompting_guide)

**验收与输出**
10. 写死输出契约：结构/字段/必填/是否允许额外字段与解释 — [OpenAI GPT-5.2 指南](https://developers.openai.com/cookbook/examples/gpt-5/gpt-5-2_prompting_guide)
11. 给出可验证的完成标准+交付前按标准自检（"Before you finish, verify against..."）— [Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
12. 结尾复述最关键、最易被忽略的约束（长 prompt 中段最易稀释）— [Brex 内部指南](https://github.com/brexhq/prompt-engineering)

**澄清策略**
13. 最多 1-3 个精确澄清问题，或带显式假设继续；产物内禁止反问 — [OpenAI GPT-5.2 指南](https://developers.openai.com/cookbook/examples/gpt-5/gpt-5-2_prompting_guide)

**反模式**
14. prompt 风格传染输出：要中文、少 Markdown 的交付物，prompt 就用纯中文克制格式写 — [Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
15. 冲突/含糊约束会被模型"调和"烧推理导致偏题——生成后做冲突扫描 — [OpenAI GPT-5.2 指南](https://developers.openai.com/cookbook/examples/gpt-5/gpt-5-2_prompting_guide)

## 四、HuggingFace 小模型评估

| 模型 | 基座/参数 | Downloads | 定位 | 可调用性 |
|---|---|---|---|---|
| [Yusiko/qwen3.5-prompter](https://huggingface.co/Yusiko/qwen3.5-prompter) | Qwen3.5-4B (QLoRA, GGUF) | 334 | 多语言（含中文）prompt engineer，按 Google 白皮书格式 | HF 无托管；Vast 自建可行 |
| [Wasteland0103/qwen2.5-3b-prompt-optimizer-v4-lora](https://huggingface.co/Wasteland0103/qwen2.5-3b-prompt-optimizer-v4-lora) | Qwen2.5-3B | 59 | 韩语改写，带 gate()+faithful() 护栏 | 需合并权重自托管 |
| [EphemeralYou/Prompt-Refine-MiniCPM5-1B](https://huggingface.co/EphemeralYou/Prompt-Refine-MiniCPM5-1B) | MiniCPM5-1B | 42 | 图像生成提示词扩写（领域跑偏） | — |
| [MainzelMennchen/prompt-tuner-8b](https://huggingface.co/MainzelMennchen/prompt-tuner-8b) | Qwen3.5-9B (MLX) | 29 | 德/英口述转写→结构化 prompt | MLX 仅 Apple Silicon |
| [ArjunShukla/PromptForge-Optimizer](https://huggingface.co/ArjunShukla/PromptForge-Optimizer) | Qwen2.5-1.5B | 18 | 英文改写（自承会编造受众/技术栈） | — |
| [aiml8726737/personal-prompt-engineer-qwen1.5b](https://huggingface.co/aiml8726737/personal-prompt-engineer-qwen1.5b) | Qwen2.5-1.5B | 12 | 英文改写，3k 配对 | — |
| [silas114514/PMTX1-2B-adapter](https://huggingface.co/silas114514/PMTX1-2B-adapter) | Qwen3.5-2B | 11 | 中文"提示词纠偏教练"（只优化不代做，最贴定位） | 无评测、0 likes |
| [redstone-ui/qwen2.5-1.5b-prompt-optimizer-lora](https://huggingface.co/redstone-ui/qwen2.5-1.5b-prompt-optimizer-lora) | Qwen2.5-1.5B | 7 | 中文改写，仅 100 条训练对，作者自标"教学演示" | — |

**结论**：不引入专用小模型后端。理由：①全部玩具级（最高 334 downloads），无中文大样本基准；②8 个模型 HF Serverless 均无托管，调用需 Vast 常驻 GPU 或付费 Endpoints，成本高于直接调 DeepSeek；③小模型典型失败模式（过度扩写、编造受众/技术栈）正撞本 skill 红线（PromptForge 卡片自承）。

反方证据成立但暂不适用：BPO（[zai-org/BPO](https://huggingface.co/zai-org/BPO)）证明窄任务+固定格式+自有数据时专用小模型可超过 PPO/DPO 对齐。**重新评估的触发条件**：真实"模糊需求→成品 prompt"配对数据 ≥1-2k 条 + 调用量能摊平 GPU 常驻成本 + 可跑盲测。届时用自己的数据微调 Qwen3.5-2B/4B。

## 五、最终采纳清单（已写入 skill）

- **输出契约前置**：只产出文本 / 只输出一个代码块 / 不添加用户未提及的需求（移到 skill 最顶部）
- **门禁判定 + UNCHANGED**：清晰 prompt 原样返回，把"不改"当一等公民
- **逐字事实锁**：数字/区间/路径/URL/代码/命令/版本号逐字保留
- **1 轮 1-3 问 + 显式假设**：问不到就写"暂定假设/待确认（默认 X）"；产物内授权执行者"关键缺失先问不猜"
- **六维按需覆盖**：目标/背景/材料/约束/执行要求/输出格式+验收，不输出空模块
- **约束预算**：硬约束 ≤5-7 条、按重要性排序、正向表述+替代动作、结尾复述最易被忽略的一条
- **程度词量化表**：简短/详细/专业/好用/尽快 → 可判定表述
- **对抗自检（静默）**：歧义/边界/自洽三轮 + 冲突扫描
- **验收判据 + 逐条自检**：可验证条件，禁"请仔细检查"
- **去咒语**：无人设、无情绪勒索、无默认 CoT（仅计算/逻辑/多约束规划分步）
- **中文风格传染**：中文 prompt 用克制中文写
- **目标客户端适配**（v1.1 已有，保留）

**明确不采纳**：多轮追问 UI、LangGPT Role/Profile 骨架、评分展示与版本对比、固定"神奇句式"、全程 JSON、PromptWizard 离线流水线、专用小模型后端。

## 六、第二轮调研（2026-11-14）与 skill v1.4.0

三路并行：新论文（2025-09 后，arXiv API 按提交时间倒序）/ GitHub 补漏 + skill 工程实践 / 官方 skill 编写指南（agentskills.io、Anthropic、vercel-labs、Codex）。

### 采纳进 v1.4.0 的关键改动（含证据）

1. **输出契约 → 输出配方**：禁令清单会被模型"谈判"，正向配方（恰好一个代码块+固定小节顺序）直接对准"块外夹带说明"这一最主要失败模式（obra/superpowers writing-skills）
2. **约束极性修正**：行为边界用负面护栏「不得 X」+替代动作，输出形态才用正向「只输出 X」；条件句改陈述祈使句（Guardrails Beat Guidance 2604.11088：679 个规则文件/2.5 万条规则/5000+ 次运行，每条单独有益的规则都是负面约束、每条有害的都是正面指令；2611.04367：条件句式遵守率低于陈述式）
3. **关键约束放第一段 + 结尾逐字复述**（2610.33201：消息内首条冲突指令胜率 72.42-94.66%，已核实存在）
4. **事实来源优先级一句话**（2610.30571：加一句"现有代码优先"后跟随代码比例 4.2%→91.4%、测试通过率 89.4%→100%，已核实存在）
5. **澄清策略反转：清单化+默认值优先，只问目标级缺口**（2605.20149 清单式 7.50/8 vs 追问式 6.67；2611.01087 追问降低用户审查时间、更易接受错误输出；2610.18090 目标缺口>约束缺口>上下文缺口，澄清预算只留给目标）
6. **中文歧义专项清单**（2605.15635 歧义盲视/错误归因/过早消解三类失败；2605.25284 模型识别歧义但几乎从不追问——不指望执行者自己发现，生成阶段消歧）
7. **验收升级：「给定…当…则…」+ 逐条举证**（github/spec-kit 模板；2611.16289 规格满意化：报告取舍可 +5.09 pass@1；2607.25398 长流程 agent 会声称遵守了没做到的规则）
8. **不可压缩清单 + 指代完整性**（2606.09421：删命令/路径/阈值让 agent 更贵更不稳；2608.04569：压缩制造指代悬空 34-60%）
9. **门禁收紧：缺陷清单四问，无缺陷原样返回**（2611.01135：强推理模型上结构化改写无统计显著增益，headroom 只在协议/格式错误）
10. **frontmatter 合规化（version/author 移入 metadata）、description 触发词化、常见错误改「失效→防御」、示例改完整输入输出对**（agentskills.io 规范 + skill 工程实践）

### 未采纳（及原因）

- description 扩到 300 字——与 Hermes 60 字索引冲突，触发词已压进前 60 字，完整触发列表在正文
- 拆分 references/——正文 137 行未超 500 行上限，超限再拆
- evals 全量跑触发率——已建 `evals/trigger-queries.md`（10 正例 + 10 近义负例 + 输出断言），待跑回归
