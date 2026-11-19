# Intern-Decision 双过程决策实证项目

研究问题：Intern-Decision 能否作为快速决策层，其置信度能否帮助决定何时升级生成式推理，以及小域微调后能否保持迁移能力。

工作标题：**On the Generalization of Fast Open-Domain Decision Models: Evidence from Intern-Decision as a System-1 Decision Layer**。

## 2026-11-02：真实 0.8B IID/OOD 结果与公开任务基线

真实 Intern-Decision 0.8B CPU 补充实验已完成 **12/12 个测试条件、3/3 个数据种子**。全部 **6,240 条预测、18 个运行回执**及整批完成标记已核验，其中留出测试为 **4,800 条请求、2,400 个场景组**，另有独立校准和路由验证各 720 条。推理会话 15174 以退出码 0 正常结束。三个数据种子使用同一发布权重，未做任务微调；17 / 43 / 97 的温度提前冻结为 `T=4.8141 / 4.5182 / 4.7328`。同一种子的全部测试条件共享该工件，OOD 不重新拟合，校准不改变选择。每行均为完整 400 条请求、200 个场景组，区间按场景组 bootstrap；未作多重比较校正。**这只完成 CPU 补充 S1，GPU E1–E4、公开任务 LLM、真实 GPU/API 交接与完整项目报告仍待完成。**

| 数据种子 | 完整条件 | 准确率 % | 95% CI % | ECE 原始 → 校准 | 校准后错误 AUROC | 独立审计 |
|---|---|---:|---:|---:|---:|---|
| 17 | [IID](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_iid.json) | 36.00 | [30.75, 42.00] | 0.2857 → 0.0558 | 0.633 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_iid.audit.v2.json) |
| 17 | [规模 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_scale.json) | 39.25 | [33.25, 45.00] | 0.2590 → 0.0393 | 0.654 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_scale.audit.v2.json) |
| 17 | [表示 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_representation.json) | 33.75 | [27.50, 39.75] | 0.3645 → 0.0466 | 0.578 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_representation.audit.v2.json) |
| 17 | [组合 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood.json) | 35.75 | [30.25, 41.25] | 0.3618 → 0.0355 | 0.533 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood.audit.v2.json) |
| 43 | [IID](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_iid.json) | 39.25 | [34.00, 45.00] | 0.2462 → 0.0507 | 0.662 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_iid.audit.v2.json) |
| 43 | [规模 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_scale.json) | 37.00 | [31.25, 42.50] | 0.2755 → 0.0555 | 0.599 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_scale.audit.v2.json) |
| 43 | [表示 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_representation.json) | 33.00 | [27.25, 38.75] | 0.3662 → 0.0551 | 0.527 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_representation.audit.v2.json) |
| 43 | [组合 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood.json) | 37.50 | [31.75, 43.75] | 0.3466 → 0.0178 | 0.585 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood.audit.v2.json) |
| 97 | [IID](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_iid.json) | 38.50 | [32.25, 44.25] | 0.2711 → 0.0336 | 0.597 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_iid.audit.v2.json) |
| 97 | [规模 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_scale.json) | 40.25 | [34.25, 46.00] | 0.2520 → 0.0586 | 0.586 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_scale.audit.v2.json) |
| 97 | [表示 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_representation.json) | 40.50 | [34.00, 46.25] | 0.2831 → 0.0331 | 0.587 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_representation.audit.v2.json) |
| 97 | [组合 OOD](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood.json) | 36.00 | [30.00, 42.25] | 0.3768 → 0.0398 | 0.564 | [通过](results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood.audit.v2.json) |

- [最新中文报告 PDF](reports/empirical_progress_20261102_v12/report.pdf) 与 [HTML](reports/empirical_progress_20261102_v12/report.html) 共 **45 页、34 组 PNG/PDF/SVG 图**，覆盖全部十二个 CPU 条件、三个冻结温度、36 个配对错误 AUROC 区间、固定均匀参照及选项顺序诊断；102 个图形导出、两个十二行总表、完整采集凭据与新增页面检查通过。[结果总表](reports/empirical_progress_20261102_v12/cpu_results_table.json)、[区间总表](reports/empirical_progress_20261102_v12/cpu_error_uncertainty_table.json) 和 [报告核验](reports/empirical_progress_20261102_v12/artifact_verification.json) 均绑定原始证据。同题训练多数类为 25%；种子 17 / 43 / 97 六种传统监督模型的 IID 准确率范围分别为 46.0%–86.5%、42.0%–90.0%、42.0%–87.5%。它们使用 1200 条训练标签，与 0.8B 零样本选择及带标签温度校准分别标示。尚无配对 S2 净修正收益。[前一版 38 页报告](reports/empirical_progress_20261102_v11/report.pdf) 保留为历史快照。
- 种子 43 组合 OOD 的概率质量改善，但错误检测 AUROC 点估计为 **0.595 → 0.585**；准确率保持 37.50%，NLL 2.1989 → 1.3610、Brier 0.9080 → 0.7299。[十二条件错误排序不确定性附页](results/cpu_error_uncertainty_20261102_v5/report.html) 对同一批预测补充事后场景组配对 bootstrap：该条件校准减原始 AUROC 的差值为 **−0.0100，95% CI [−0.0331, 0.0139]**，包含零，不能据点估计断言排序损害。全部九个 OOD 差值区间均包含零；三个 IID 区间为正，但区间未经多重比较校正，不证明跨域或 S2 净修复收益。区间只重抽留出场景组，权重和温度固定，不增加模型样本，现已纳入主报告。
- [独立不确定性复核](results/cpu_error_uncertainty_20261102_v5/verification.json) 核对全部 12,000 条重采样统计、36 个区间，并用 SciPy 平均秩／Mann–Whitney 公式复算 624 个 AUROC，包括各条件完整点估计及重生成的 300 次组抽样；[图 PDF](results/cpu_error_uncertainty_20261102_v5/error_auroc_intervals.pdf)、PNG、SVG 与 HTML 哈希均通过。3 项合成数学检查通过，见 `results/tests_cpu_error_uncertainty_20261102_v2.log`。原始预测、选择、温度与实验协议均未修改。
- [整批 CPU 来源与覆盖核验](results/cpu_secondary_analysis_v1/verification.json) 检查全部 6,240 行、18 个完整回执及初始／r001／r002／r003 执行来源；[三种子汇总](results/cpu_secondary_analysis_v1/summary.json) 与提前冻结的温度逐一一致。三数据种子的描述性平均准确率依次为 IID 37.92%、规模 OOD 38.83%、表示 OOD 35.75%、组合 OOD 36.42%；各数据种子表现有波动，不是三次独立训练模型的统计结论。
- [固定均匀参照](results/cpu_uniform_reference_20261102/summary.json) 逐一核对十二个集合均为四类各100条。固定输出四个0.25的解析结果为：准确率25%、ECE 0、Brier 0.75、NLL ln(4)=1.3863、错误 AUROC 0.5。它没有模型调用或参数拟合，仅说明低 ECE 应与正确选择、proper score 和错误排序一并判断；不是新增模型实验，也不替代原定对照。

- [选项顺序稳定性诊断](reports/cpu_option_order_20261102_seed17_iid/report.html) 复用同一批 IID 预测：反转四个选项后，86/200 个场景改变语义选择，一致率 57.0%；两种顺序都正确的有 41/200 个场景。它是明确标记的事后分析，没有增加独立测试样本，也不用于改变冻结协议；完整配对证据及独立复算见 [诊断目录](results/cpu_option_order_20261102/labqueue_v1_seed17/test_iid/summary.json) 和 [导出核验](reports/cpu_option_order_20261102_seed17_iid/verification.json)。传统模型按构造只读取 state，顺序一致率 100% 不构成匹配输入或训练预算的优越性证据。
- [新一轮传统模型独立复算](results/empirical_audit_20261102_v2.json) 再次通过 18 个持久化模型、37,440 行预测、72 组测试指标、324 次重新推理及 12 个分类器路由条件，并补齐 359 个实际证据文件和三种子摘要的哈希绑定。旧审计与报告保留为历史快照。

- SST-2、RTE、BoolQ 的 TF-IDF + NB/LR/SVM × 三种子已真实训练并完成 27 组完整公开 dev 评估。三种子平均准确率分别为 81.61%–82.11%、49.34%–51.74%、62.25%–64.33%；对应训练多数类基线为 50.92%、52.71%、62.17%。RTE 的均值低于多数类基线，BoolQ 的增益有限。这些是任务专用监督模型结果，不是 Intern-Decision 结果。
- E3 的完整 GPU 准备现已覆盖 **三套 LabQueue + 九套公开任务数据**，4B 与 0.8B 各自有固定资产清单及只生成计划的输出，见 [范围与参数核验](results/e3_full_scope_preparation_20261102/verification.json)。保留全部 calibration/router_validation 和完整公开 dev，没有新增模型预测或 GPU 提交。每型号计划 89,862 次 S1 与 54,022 次 S2 请求，另有 135/99 次不计入质量样本的预热；S2 预算为 512 token。公开 dev 的 13,257 次跨数据种子评估对应 4,419 个唯一可见请求，不能解释为三个独立留出样本群。完整命令见 [执行说明](AFTER_DOWNLOAD.md)。
- E2 与 E4 训练阶段新增 [离线 GPU 队列入口](scripts/submit_aux_gpu.py)，四份 [参数、数据与源码核验](results/aux_gpu_preparation_20261102/verification.json) 通过。E2 保留原先固定的 632 行／1,032 个决策及 128/512/2048 三预算；E4 按种子 17/43/97 分别使用 1,200 条训练数据、两轮、学习率 `2e-6` 和共享 XTuner Python。4 项新增合成保护检查通过，未启动这些 GPU 作业；E4 训练结束后仍必须核验最终权重、独立校准、四项新域测试和原七套件保持情况。
- [独立公开任务复算](results/public_baselines_audit_20261102.json) 检查了 27 个模型、250,866 行预测、27 组指标、243 个重新推理请求和 27 个组隔离 SVM 校准折。原始发布的 Google BoolQ 地址返回计费账户关闭；改用 SuperGLUE v2 官方分发，完整保留 9,427 / 3,270 行 train/dev，未导入隐藏测试集；来源与文件哈希见 [获取凭据](data/public_raw_v1/acquisition.json)。
- [前一版中文报告 PDF](reports/empirical_progress_20261102_v2/report.pdf) 与 [HTML](reports/empirical_progress_20261102_v2/report.html) 合并 LabQueue、公开任务和 CPU 交接证据，共 15 页、9 组 PNG/PDF/SVG 图，保留为历史快照。
- [字体修正后的 33 页 Madrid PDF](slides_revision_20261102/intern_decision_research_plan_zh_en.pdf)、[含 5 组原始动画的 PPTX](slides_revision_20261102/intern_decision_research_plan_zh_en.pptx) 和 [Overleaf 源码包](slides_revision_20261102/intern_decision_beamer_source.zip) 已生成。原生 Beamer 编译、页数、内部引用及 GIF 发布哈希检查通过；源码包附开源中文字体与许可证。这仍是研究方案，未加入尚不存在的模型结果。
- 本次执行环境已能通过此前授权的显式平台代理联网；完整官方源码及七套件、96 题 pilot 已下载并通过原发布清单核验。共享 Python 3.12 HF 环境已准备并封存，14 项官方接口检查通过；此前 73 项项目回归检查通过；本次报告变更通过实际数据及导出核验，未重跑整个项目测试集。E2 的 [固定样本及清单](data/e2_fixed_sample_20261101.jsonl.manifest.json) 已从真实官方数据导出。
- XTuner 独立环境也已准备并封存为 `.runtime/offline-xtuner.json`，保持 Torch 2.6.0 / Transformers 4.57.0 / 固定 XTuner commit / FlashAttention 2.8.3。13 项共用接口检查和 8 项官方 CPU 训练运行时检查通过；只属于 HF 原生类的导入检查在前述 HF 环境中通过。新增 Ray 依赖用于满足固定 XTuner 源码的间接导入。上述 CPU 检查未加载主模型权重，不证明 GPU 推理或训练已完成。
- 后续已用实际 0.8B 发布权重完成首次 **CPU BF16 HF 前向**，三字段概率与权重身份核验通过，见 [smoke 凭据](results/cpu_secondary_20261102/smoke_verification.json)。它是无标签的接口请求，不提供任务准确率。按事先保存的 [CPU 执行补充协议](configs/cpu_secondary_protocol_20261102.json)，已完成三种子全部 6,240 条校准、路由验证和留出请求，并通过整批来源核验。CPU 数据单独保存，不假定与 GPU 数值等价；4B GPU 主实验及微调、真实 GPU/API 交接仍为必需项。尚未完成的 CPU 文件不能评分，`scripts/analyze_cpu_secondary.py` 会拒绝不完整收集。
- E3 的模型资产、S2 tokenizer/模板和运行凭据检查均通过，但服务器明确拒绝提交：当前身份 `group-ailab-chemagent-chemagent-cpu` 无权使用 `chemagent_gpu_pool`。[提交与核对凭据](.runtime/submissions/intern-decision-e3-hf-20261101-145326-100043/reconciliation.json) 记录了拒绝及按原名称/规范化名称查询未找到作业；没有自动重提。后续需要有该 GPU 池权限的身份。Intern-Decision E1–E4、公开任务 LLM 结果、跨节点 GPU/API 实测和最终报告仍未完成。
- 最新 [只读 GPU 预测核查](results/gpu_permission_recheck_20261102_final_113947/receipt.json) 仍返回 HTTP 403，确认走预测分支，未创建作业。已找到平台配额管理查询入口；[当前项目可见配额列表](results/quota_management_discovery_20261102_0341.json) 完整返回 1 个组，仅为 `chemagent_cpu`。这没有提供新的 GPU 授权，也不证明其他身份或项目不存在可用资源；CPU 补充采集已完成，主 GPU/API 实验仍需授权和配置。
- CPU 原执行会话 5769 后续以退出码 143 终止，[终止核对记录](results/cpu_secondary_20261102/terminal_reconciliation_20261102_0415.json) 确认 6 个完整划分与种子 43 的 39 条校准前缀完整，未评分该部分文件。此前通过 [恢复入口](scripts/resume_cpu_secondary.py) 在会话 **90734** 继续缺失请求，恢复计划与源码快照见 [执行来源记录](results/cpu_secondary_20261102/labqueue_s1/recovery/r001/plan.json)。[重新加载检查](results/cpu_secondary_20261102/labqueue_s1/recovery/r001/reload_verification.json) 的三条确定性选例均保持选择与概率；它们不算新增独立测试样本。恢复保留原计划、权重、协议及全部完整文件，续写行另绑定实际恢复代码和计划哈希。17 项相关合成数学／来源检查通过，见 `results/tests_cpu_recovery_20261102_v1.log`；这些检查本身不产生模型成绩。
- 会话 90734 随后也以退出码 143 终止，原因未报告。[第二次终止核对](results/cpu_secondary_20261102/terminal_reconciliation_20261102_0650.json) 验证了 3,574 条已有记录、10 个完整划分及 214 条表示 OOD 前缀。随后由会话 **95248** 按 [r002 计划](results/cpu_secondary_20261102/labqueue_s1/recovery/r002/plan.json) 继续缺失请求，恢复代码与前次完全相同；[三个重新加载复核](results/cpu_secondary_20261102/labqueue_s1/recovery/r002/reload_verification.json) 的概率差均为 0。[字节前缀与完整文件核验](results/cpu_secondary_20261102/labqueue_s1/recovery/r002/prefix_verification.json) 确认保留 214 条旧行及全部完成输出，新增行标记 r002；部分文件仍不评分。
- 会话 95248 也已以退出码 143 终止，日志未给出原因。[第三次终止核对](results/cpu_secondary_20261102/terminal_reconciliation_20261102_0809.json) 验证 4,280 条记录、12 个完整划分及种子 97 的 120 条校准前缀。随后由会话 **15174** 按 [r003 计划](results/cpu_secondary_20261102/labqueue_s1/recovery/r003/plan.json) 继续，恢复代码保持不变；[三个重新加载请求](results/cpu_secondary_20261102/labqueue_s1/recovery/r003/reload_verification.json) 的概率差均为 0、选择相同。[恢复前缀核验](results/cpu_secondary_20261102/labqueue_s1/recovery/r003/prefix_verification.json) 确认全部完整输出与 120 条旧前缀未改变，观察到的新行均绑定 r003。未使用部分校准数据拟合温度。
- 数据种子 43 的 **240 条独立校准请求**已完整收集，含保留的 39 条前缀和 201 条续写记录。温度已冻结为 **4.518173154580739**，[独立数值与来源审计](results/cpu_secondary_20261102/early_calibration/seed43.calibration-audit.json) 通过；该种子冻结时没有已完成的测试预测。NLL **1.7746 → 1.3253** 只描述拟合集，不计为新增留出成绩。其 **240 条路由验证请求**也已通过 [来源与覆盖核验](results/cpu_secondary_20261102/router_validation_seed43_verification.json)，校准与验证的 ID、场景组及场景哈希无交叉。该种子四项留出条件均通过评分与独立审计，使用同一温度工件。尚无配对 S2，不选择求助阈值。当前合计完成 12/12 个测试条件、三个完整数据种子。
- 数据种子 97 的 240 条校准请求现已完整收齐，含 120 条 r002 前缀及 120 条 r003 续写。温度冻结为 **4.732768495589506**，[冻结证明](results/cpu_secondary_20261102/early_calibration/seed97.calibration-proof.json) 与 [独立数值、来源审计](results/cpu_secondary_20261102/early_calibration/seed97.calibration-audit.json) 均通过；SciPy 独立拟合为 4.732768589627568，冻结时测试回执与评分均为 0。NLL **1.8085 → 1.3277** 仅描述校准拟合集，不计为新留出结果。三个数据种子的温度均已冻结。种子 97 的 240 条路由验证请求已通过 [来源、覆盖及七划分隔离核验](results/cpu_secondary_20261102/router_validation_seed97_verification.json)，均为 r003 的新行；尚无配对 S2，不选择阈值。该种子的四项测试随后均已完成；模型会话正常结束，完整条件数为 12/12。
- 种子 97 IID 的 400 条请求、200 个场景组已完整评分与独立复算：154 个选择正确，准确率 **38.50% [32.25%,44.25%]**，ECE **0.2711 → 0.0336**、NLL **1.7749 → 1.3218**、Brier **0.8404 → 0.7147**。错误 AUROC **0.5600 → 0.5974**，校准减原始差值的事后 95% 配对组区间为 **[0.0182,0.0613]**；未作多重比较校正，不外推为跨域或 S2 净收益。全部 400 行来自 r003，沿用 08:24 UTC 提前冻结的温度。


复算公开任务与报告（使用新输出名）：

```bash
OPENBLAS_NUM_THREADS=1 .venv-analysis/bin/python scripts/audit_public_baselines.py --output results/new_public_audit.json
OPENBLAS_NUM_THREADS=1 .venv-analysis/bin/python scripts/audit_empirical_results.py --output results/new_empirical_audit.json
MPLCONFIGDIR=/tmp/decision-mpl .venv-analysis/bin/python scripts/build_empirical_report.py \
  --baseline-audit results/new_empirical_audit.json \
  --public-baselines results/public_baselines_v1 --public-audit results/new_public_audit.json \
  --cpu-conditions results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_iid.json results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_scale.json results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_representation.json results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_iid.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_scale.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_representation.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_iid.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_scale.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_representation.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood.json \
  --cpu-condition-audits results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_iid.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_scale.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood_representation.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed17/test_ood.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_iid.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_scale.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood_representation.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed43/test_ood.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_iid.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_scale.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood_representation.audit.v2.json results/cpu_secondary_conditions_v1/labqueue_v1_seed97/test_ood.audit.v2.json \
  --cpu-order-diagnostic results/cpu_option_order_20261102/labqueue_v1_seed17/test_iid/summary.json \
  --cpu-order-verification reports/cpu_option_order_20261102_seed17_iid/verification.json \
  --cpu-error-uncertainty results/cpu_error_uncertainty_20261102_v5/summary.json \
  --cpu-error-verification results/cpu_error_uncertainty_20261102_v5/verification.json \
  --cpu-uniform-reference results/cpu_uniform_reference_20261102/summary.json \
  --cpu-complete-analysis results/cpu_secondary_analysis_v1/summary.json \
  --cpu-collection results/cpu_secondary_20261102/labqueue_s1 \
  --output reports/new_progress_report
```

以下 2026-11-01 记录保留当时的环境限制和准备过程；当前入口与 GPU 权限问题以本节及 [AFTER_DOWNLOAD.md](AFTER_DOWNLOAD.md) 为准。

## 2026-11-01：已补充真实传统分类实验

- 已完成 6 类传统模型 × 3 种子的真实 CPU 训练与预测：TF-IDF + 朴素贝叶斯 / 逻辑回归 / SVM，以及结构化逻辑回归 / 随机森林 / 梯度提升。共有 72 组留出测试评估。
- 已完成结构化 LR → 梯度提升的探索性 E3 冻结路由诊断，覆盖全部 3 种子 × 4 测试条件。IID 平均准确率由 84.83% 提至 87.00%；同预算随机比较尚不稳定，OOD 也出现净损害。这不是 Intern-Decision 的实测结论。
- [新版中文阶段报告 PDF](reports/empirical_progress_20261101_v2/report.pdf) 与 [完整 HTML 报告](reports/empirical_progress_20261101_v2/report.html) 包含结果表、8 组图、调度场景、成功/失败案例及实际交接开销。图可单独导出 PNG/PDF/SVG；第一版报告保留为历史快照。
- [独立结果复算](results/empirical_audit_20261101.json) 核对了 18 个持久化模型、37,440 行预测、72 组指标、324 个重新推理请求、9 个 SVM 场景组隔离折及 12 个 E3 条件。共享交接新增独立进程测试，完整检查结果见 `results/tests_20261101_v2.log`。
- E3 分析入口现在核对逐条预测、运行凭据、模型身份和生成预算；温度与分析产物写入独立输出目录。测试集报告补齐校准前后的 NLL/Brier/ECE、错误检测 AUROC 与风险覆盖曲线。[12 条件复算](results/e3_cpu_20261101_v3/verification.json) 与原 CPU 路由结果、独立保存的指标完全一致；这是已有预测的再分析，没有新增 LLM 推理。
- 共享目录交接已完成真实两进程验证：4,800 个原留出请求触发 510 次 S2 分类器调用，三个服务进程均正常退出；12 个条件的路由数、修正、损害和准确率与原冻结策略一致。[独立交接复算](results/shared_handoff_audit_20261101.json) 已核对完整调用账本。这是同一主机的 CPU 工程验证，不是新增独立质量样本或 GPU/API 实测。
- 新增 SST-2、RTE、BoolQ 的公开数据导入、按证据组隔离、传统基线运行入口；原始数据尚未下载，没有公开任务分数。公开 dev 被当作留出评估，不标成隐藏 test 结果。
- [E3 主实验协议](configs/e3_main_protocol_20261101.json) 已在任何 LLM 推理前保存。GPU 收集器为每个模型只加载一次权重，S2 只跑路由验证和测试；CPU 分析器支持域内校准和冻结阈值跨域迁移。
- 项目仍未完成：Intern-Decision E1–E4、公开任务实测、GPU/API 跨节点 handoff 实测与最终报告仍待完成。当前执行沙箱无 CUDA、无所需模型运行环境且禁止 TCP；尚未启动 GPU 作业。`configs/gpu_queue.json` 已填入同一资源组相邻项目脚本中的[候选镜像](reference/gpu_image_candidate_20261101.json)，实际拉取与驱动兼容性尚未核实。
- 已对照三个相邻项目的 rjob 脚本及真实历史 CUDA 日志，修正 E1/E3 实际作业名回执，以及当前 CLI 不接受的 `private-machine=yes`、`restart-policy=Never` 两处参数。[本机完整 CLI 解析](results/rjob_cli_parser_check_20261101.json) 通过；这不是服务器提交。已完成 [E3 离线资产清单](.runtime/e3-assets-labqueue-20261101-v2.json)：约 17.17 GB 现有 S1/S2 文件、完整 tokenizer、三套数据的哈希与分片边界检查通过；不等于 HF 环境或 GPU 已就绪。排队前验证 S2 tokenizer/模板，worker 重新核验固定清单。准备及认证说明见 [AFTER_DOWNLOAD.md](AFTER_DOWNLOAD.md)。
- 后续通过官方文本读取结果恢复了 [25 个发布哈希一致的文件](reference/upstream_text_acquisition_20261101.json)，暂存在 `upstream/Intern-Decision-release-staging`；另有 21 个必需文件未匹配，官方评测数据也未补齐，实际源码核验拒绝了这个部分目录。准备脚本现接受提前解压的完整源码包，不要求 `.git`，哈希要求保持一致。缓存核查未找到可用的 Python 3.12/HF 依赖组合，安装和公开数据获取仍被当前 TCP 限制阻止。

复算已完成结果（输出须使用新文件名）：

```bash
python -m unittest discover -s tests -v
python scripts/audit_empirical_results.py --output results/new_empirical_audit.json
python scripts/audit_shared_handoff.py --output results/new_shared_audit.json
MPLCONFIGDIR=/tmp/decision-mpl python scripts/build_empirical_report.py --output reports/new_empirical_report
```

在可联网的普通 CPU 终端准备公开数据与传统基线；网络只走已配置的显式出口，不自动采用环境代理：

```bash
bash scripts/setup_analysis.sh
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 .venv-analysis/bin/python scripts/run_public_baselines.py --download
```

分析环境位于 `.venv-analysis`，与已封存的 HF/XTuner 环境分开；不要为分析安装而改变已封存环境的依赖。当前沙箱仍禁止 TCP，准备脚本会在任何下载或安装前停止。

在已有 HF 离线环境的 GPU worker 上运行优先 E3 主实验。公开数据准备好后可将其目录追加到 `--data-dirs`；先使用 `--plan` 检查声明的样本数和文件哈希。当前三种子 LabQueue 的计划见 [收集计划](results/e3_gpu_collection_plan_20261101.json)。

```bash
# 可联网普通 CPU 端：准备完整共享 HF 环境后排队。
python scripts/submit_e3.py --plan
python scripts/submit_e3.py
# 已在 GPU worker 中时，可直接运行收集器：
.venv-hf/bin/python scripts/collect_e3_gpu.py \
  --data-dirs data/labqueue_v1_seed17 data/labqueue_v1_seed43 data/labqueue_v1_seed97 \
  --output runs/e3_llm_v1 --max-new-tokens 512
# 收集完成后在 CPU 分析；模型预测与运行凭据须完整且哈希一致。
OPENBLAS_NUM_THREADS=1 python scripts/analyze_e3_collection.py \
  --collection runs/e3_llm_v1 --output results/e3_llm_v1 \
  --transfer-router-dataset labqueue_v1_seed17
```

分析前完整核验数据与预测覆盖、请求内容哈希、逐行模型身份、HF 原始温度以及 S2 的固定生成设置，核验通过才拟合温度。`collection_verification.json` 记录已检查的凭据；`calibration/` 保存本次新拟合的温度，不复用原始预测目录中的同名文件。各测试 JSON 的 `s1_diagnostics` 包含校准与选择性预测指标，`s2_standalone` 保留失败在内的独立 S2 评估。

E3 排队命令见 [已通过本机 CLI 解析的提交计划](results/e3_queue_plan_validated_20261101.json)。`--plan` 不验证镜像可用、不创建作业；实际提交先核验共享运行凭据及数据，worker 再核验 CUDA/BF16。E1 与 E3 均禁止自动重启和自动重提，已有输出须先核对原作业状态。

## E3：GPU 离线、CPU 联网的实际交接

`decision_lab/shared_handoff.py` 让 GPU 仅通过共享文件读写求助。CPU 独立运行官方 `ThinkingModel` 接口；请求只包含可见证据和问题，标准答案、划分、原始 ID 不进入 S2。完整写入后原子发布，响应绑定 session、请求哈希、字段和同一 S2 身份。超时/无效响应保留 S1；取消后尚未开始的请求不调用 S2，已经发出的调用不自动重试。CPU 响应账本保留迟到调用及实际用量，缺失用量保持未知。

先使用同一 API 模型、端点、max_tokens、超时和 usage 设置采集路由验证预测，再用 `select-router` 选择 API 专属阈值。不能将本地 Qwen 或 CPU 分类器的阈值作为该 API 的已验证策略。模型身份现在也绑定适配器代码哈希，改动代码后需重做对应的校准和路由工件。

以下示例要求已有 `runs/api-router.json`、真实 API 验证预测及同源 S1。API 凭据仅在联网 CPU 进程的环境变量中配置，不写入文件或 GPU 环境：

```bash
# 联网 CPU：先启动服务，使用新的共享目录。
.venv-hf/bin/python scripts/run_shared_handoff.py serve \
  --spool-dir runs/api-spool-v1 --model YOUR_REASONING_MODEL \
  --max-tokens 2048 --timeout-seconds 300
# 离线 GPU：CPU 服务已启动后，测量完整请求。
.venv-hf/bin/python scripts/run_shared_handoff.py route \
  --spool-dir runs/api-spool-v1 --router runs/api-router.json \
  --data data/labqueue_v1_seed17/test_iid.jsonl \
  --checkpoint checkpoints/Intern-Decision-4B --output runs/api-online.jsonl
# CPU：完成所有 GPU 请求后请求服务正常退出，再核对所有调用。
.venv-hf/bin/python scripts/run_shared_handoff.py stop --spool-dir runs/api-spool-v1
python scripts/run_shared_handoff.py reconcile --spool-dir runs/api-spool-v1 \
  --client-outputs runs/api-online.jsonl --output results/api-call-accounting.json
```

工程验证可用 `python scripts/check_shared_handoff.py --output results/new_shared_integration` 重新执行；该入口只使用已训练 CPU 分类器，明确不产生 GPU/API 结果。服务凭据文件仅表明配置和会话身份；判断服务是否仍运行要核对真实进程或作业句柄。若进程中断留下已领取请求，先核对提供方与账本，再决定恢复方式。

以下为原实验方案及 2026-10-14 准备情况；其中合成流程验证与本日真实 CPU 模型实验分别保存。

## 原框架与模型准备状态

- 四模块的运行入口、指标分析、阈值路由、官方 handoff 适配和出图代码已建立。
- LabQueue-v1 已生成三套独立随机种子数据；每套 3,280 行、1,640 个场景组，共 9,840 行。标签由调度规则求解器确定。
- 29 项 CPU 检查及 7 个 CLI 流程检查通过。流程检查使用明确标记的合成预测；图上也有标记。
- 尚未运行 Intern-Decision 推理或微调，尚无本项目 Intern-Decision 准确率、校准或延迟结果；本日传统分类器结果见上方。
- 两个 Intern-Decision checkpoint 均已完整下载，并重新核对了全部发布文件的 SHA-256；marker、62 个单 token 候选符号和 embedding 范围的 CPU 检查也通过。现有 `Qwen3-4B-Thinking-2507` 可用于生成式基线。本会话没有 CUDA GPU，执行沙箱禁止 TCP/UDP。
- 所有模型推理使用本地文件，并设置 Hugging Face 离线环境变量。显式模型获取工具与推理分开，要求确认符合流量约束的出口；不自动采用环境代理，也不自动切换出口。

环境记录见 [results/environment_20261014.json](results/environment_20261014.json)，流程验证见 [results/framework_smoke/verification.json](results/framework_smoke/verification.json)。

沙箱网络诊断见 [results/network_diagnostic_sandbox_20261014.json](results/network_diagnostic_sandbox_20261014.json)：TCP/UDP 创建返回 `EPERM`，只读 `rjob list` 的沙箱外执行也被工具审批策略拒绝；该报告本身无法说明宿主机连通性。
用户随后在普通终端生成了 [results/network_diagnostic_host.json](results/network_diagnostic_host.json)：宿主机 DNS 正常，四个测试站点直连均超时，环境代理均成功。用户已完成代理下载；本地两个模型的哈希核验通过。下一步运行入口见 [AFTER_DOWNLOAD.md](AFTER_DOWNLOAD.md)。

GPU 节点不能联网。所有下载和安装在可联网 CPU 端完成，环境与 Python 本体放在共享目录；`scripts/setup_intern_decision.sh` 生成离线准备凭据后，`scripts/submit_e1.py` 使用 rjob 排队，GPU worker 只进行本地核验和实验。提交镜像配置在 `configs/gpu_queue.json`；当前尚未提交 GPU 作业。

33 页中英双语方案已切换为 **Madrid Beamer** 主题，源码显式使用 `\usetheme{Madrid}`。文件为 [PDF](slides/intern_decision_research_plan_zh_en.pdf)、[PPTX](slides/intern_decision_research_plan_zh_en.pptx)、[Overleaf 源码包](slides/intern_decision_beamer_source.zip) 与 [官方动态图画廊](slides/official_demos.html)。增加了 8 张官方参考结果图或研究示意图，保留原有 image generation 流程图，并安排了五组官方动态演示。原始 GIF 未下载时显示明确的待补齐面板，画廊链接原始 GitHub GIF；不伪造画面。当前执行沙箱不能下载，普通 CPU 终端运行 `bash slides/rebuild_madrid.sh` 可核验并嵌入原始 GIF，同时准备 TeX 包并重建。实际编译状态和嵌入 GIF 数量见 `slides/build_manifest.json`；当前 PDF 仍是 Madrid 版式预览，原生编译缺少 `beamer.cls`。原卡片版已归档到 `slides/archive/custom_cards_20261014/`。

## 实验协议

| 模块 | 主要测量 | 实验控制 | 可以回答的问题 |
|---|---|---|---|
| E1 复现 | 七套件准确率、Hard Brier/ECE、96 题期望指标、独立延迟测量 | 原始数据哈希、权重哈希、后端及温度绑定 | 官方能力基线在指定条件下是否可复现 |
| E2 双过程比较 | 相同题目的准确率、请求延迟、生成 token、成本 | 固定题目与种子、128/512/2048 token 预算 | 生成式推理的额外资源何时换来收益 |
| E3 校准与路由 | 可靠性图、错误检测 AUROC、风险覆盖曲线、路由比例与质量/成本 | 独立校准和选阈值数据；同预算随机/熵/间隔对照；真实在线 handoff | 置信度能否挑出值得升级的决策 |
| E4 迁移 | 0.8B 微调前后新域 IID/OOD，以及原七套件的能力保持 | 三个种子；资源规模、状态表示、组合变化分别测试 | 域适配的收益、泛化范围及遗忘代价 |

LabQueue 的 [标签规则](decision_lab/domain.py) 有固定优先级：先检查未完成依赖，有依赖则 `queue`；随后按总容量判整体任务是否可行，整体超限但可分片且每片能容纳时返回 `split`，否则 `reject`。整体可行但当前可用量不足时 `queue`，其余情况 `dispatch`。因此无未完成依赖时，案例中的 `split` 表示先分割任务，即便当前可用量不足以立刻运行分片；它不宣称已完成真实 GPU 调度。

官方七套件是 10,751 行、12,351 个决策，90.02% 是七项准确率的算术平均。准确率和校准 pilot 使用 XTuner；44.16 ms 使用 HF、RTX 4090、289 输入 token 和三个字段，二者是不同协议。HF 路径需要独立拟合温度。[官方评测协议](https://github.com/InternLM/Intern-Decision/blob/main/docs/EVALUATION.md)、[官方延迟与依赖说明](https://github.com/InternLM/Intern-Decision#rtx-4090-inference-latency)。

0.089 是随机结果 pilot 的**期望 ECE**；Hard 上的 ECE 是 0.065267。前者不能直接替代真实错误检测；随机性带来的低置信度也未必能由更大模型消除。96 题由 48 个成对设置组成，不用于拟合温度或选择阈值。[官方校准指标定义](https://github.com/InternLM/Intern-Decision/blob/main/docs/CALIBRATION_BENCHMARK.md)。

E3 主实验使用 LabQueue 的独立校准和路由验证划分，再测试冻结的阈值。若将这个阈值迁移到官方套件，要标为**跨域阈值迁移**。官方套件上的曲线用于描述，不用于挑选最终阈值。

“元认知”在本项目中操作化为错误检测和求助策略的有效性。单个 ECE 数值、已有 handoff 接口或一个新域的成功，都不足以证明通用元认知、开放域通用性或首次贡献。单一温度通常改变阈值含义；在二分类等条件下不改变置信度排序。因此对照要匹配升级预算。

## 文件与数据

- `decision_lab/core.py`：严格 JSON、证据/标签隔离、温度拟合、ECE/Brier。
- `decision_lab/backends.py`：官方单前向模型、本地生成式推理、官方 API handoff。
- `decision_lab/routing.py`：冻结阈值、同预算对照、失败回退、场景组 bootstrap。
- `decision_lab/workflows.py`：官方 E1 运行顺序、E4 训练配置与实际训练种子。
- `decision_lab/plots.py`：PNG/PDF/SVG 图；缺少价格或 usage 时不补造成本。
- `configs/experiment.json`：协议记录，供审查；CLI 参数是实际运行配置。
- `reference/upstream_release_manifest_20261014.json`：通过官方公开源核查的文件哈希。正式运行前核验源码；它不是完整源码副本。

LabQueue 每个种子的划分如下；同一场景的两个选项顺序变体始终在同一划分内。记录的 `state` 只含可见证据，监督放在 `targets`。所有划分检测 ID、场景组、请求内容和原始场景重叠。

| 划分 | 行数 | 用途 |
|---|---:|---|
| train | 1,200 | 仅微调 |
| calibration | 240 | 最小化硬标签 NLL 拟合温度 |
| router_validation | 240 | 在预设 25% 升级预算内选阈值 |
| test_iid | 400 | 同分布评估 |
| test_ood_scale | 400 | 增大资源规模 |
| test_ood_representation | 400 | 从占用和预留推导可用资源 |
| test_ood | 400 | 两种变化同时出现 |

这是有精确标签的程序化调度诊断，后续应补充人工审核的真实新域证据，才能扩大外推范围。

当前主实验是文本决策，没有测量图像迁移或完整智能体轨迹回报。候选动作由接口提供；结果的外推范围应与这个条件一致。

## 环境准备

CPU 分析支持 Python 3.10+；模型实验按官方使用 Linux、Python 3.12 和 CUDA。HF 与 XTuner 必须分开环境。当前环境没有这些模型运行条件。

先将完整官方源码和完整本地权重目录放到可访问的位置。默认源码位置为 `upstream/Intern-Decision`，权重位置为 `checkpoints/Intern-Decision-{0.8B,4B}`，也可通过 CLI 参数指定共享目录。源码/小文件与权重获取分开处理；没有明确的不计流量渠道时不下载权重。

HF 的官方固定依赖为 Torch 2.9.1、Transformers 5.14.1；报告的延迟还使用 flash-linear-attention 0.4.2。XTuner 用 Torch 2.6.0、Transformers 4.57.0、固定 XTuner commit `fb51baebdf91b03bd39255c4427edac9aca82865`，并在进程启动时启用 `runtime/xtuner/sitecustomize.py`。安装步骤以核查过的官方 requirements 为准。离线安装需先准备 wheel 和源码缓存；本项目没有自动安装或联网回退。[官方安装说明](https://github.com/InternLM/Intern-Decision#installation)。

```bash
python -m decision_lab doctor
python -m unittest discover -s tests -v
# 使用新的输出目录；以下命令产生合成流程验证图，不加载模型。
python scripts/check_pipeline.py results/framework_smoke_new
```

## E1：运行官方复现

在准备好的 XTuner 环境中设置 `XTUNER_PATH`。下面的 launcher 自动为子进程设置正确的 runtime 和离线环境，校验源码，绑定官方权重温度，运行七套件与 pilot，并核查验证文件。`--python` 可指定相应环境的解释器。

```bash
python -m decision_lab.workflows e1 \
  --checkpoint /shared/path/Intern-Decision-4B \
  --size 4B --backend xtuner --output runs/e1-4b
```

只查看命令可加 `--plan`；已生成的示例为 [results/e1_4b_commands.json](results/e1_4b_commands.json)。0.8B/2B 要同时修改权重路径、`--size` 和输出目录。HF 变体要求用 `--calibration` 提供该后端独立拟合的**原生官方格式** artifact；不套用 XTuner 预设。

延迟在 HF 环境单独测量：

```bash
python -m decision_lab latency \
  --checkpoint /shared/path/Intern-Decision-4B \
  --data data/latency_requests.jsonl --backend hf \
  --warmup 10 --repetitions 100 --output runs/latency.json
```

`latency_requests.jsonl` 已提供一个合成三字段微基准请求，也可准备其他同接口请求。报告同时保存前向时间、完整请求时间、真实输入 token 和字段数。只有实际匹配 GPU、后端、输入规模和测量口径时才能与 44.16 ms 直接比较；`--input-tokens 289` 会严格检查输入长度。

## E2：相同题目比较单前向与生成式推理

离线 GPU 使用 `scripts/submit_aux_gpu.py --stage e2 --plan` 查看完整执行计划；当前有效的 [已保存计划](results/e2_gpu_stage_plan_20261102_v3.json) 包含一次 S1 与三个生成预算的 S2 采集及配对比较。配置有效 GPU 身份后去掉 `--plan` 才会实际提交。该入口使用此前固定的 `data/e2_fixed_sample_20261101.jsonl`，提交前和 worker 启动时核对数据、源码与模型字节；GPU 节点禁用代理和下载。S2 预算应用于每个字段的单次生成，`typed_decisions` 一行含五个字段；请求耗时和字段用量均保留。每个预算保留全部失败、用量与完整回执，单个失败阶段会停止且不自动重启。以下直接命令供 GPU 环境内分步执行。

在准备好的 HF 环境中，先验证并导出官方数据。导出保留行号和来源 ID，模型请求剥离标准答案。原生 E1 数据保持原样。先固定一个计算量可控的 E2 样本：保留所有公开 Jevbench，其余每套件随机抽 100 个场景组。扩大实验时重新声明样本与输出，不能依结果挑题。

```bash
python -m decision_lab export-benchmarks --output data/official_canonical.jsonl
python -m decision_lab sample-e2 --data data/official_canonical.jsonl \
  --seed 17 --groups-per-suite 100 --output data/e2_fixed_sample.jsonl
python -m decision_lab predict-s1 --data data/e2_fixed_sample.jsonl \
  --checkpoint /shared/path/Intern-Decision-4B --output runs/e2.s1.jsonl
python -m decision_lab predict-s2 --data data/e2_fixed_sample.jsonl \
  --checkpoint /mnt/shared-storage-user/xiejiaqing/models/Qwen/Qwen3-4B-Thinking-2507 \
  --max-new-tokens 512 --output runs/e2.s2-512.jsonl
python -m decision_lab compare --data data/e2_fixed_sample.jsonl \
  --s1 runs/e2.s1.jsonl --s2 runs/e2.s2-512.jsonl --output runs/e2-512.json
python -m decision_lab.plots --comparisons runs/e2-512.json --output runs/e2-figures
```

对 128 和 2048 token 预算用独立输出重复生成式推理，再把三份 `compare` 报告一起交给 `--comparisons`。截断/无效输出计入失败；不丢弃难题，也不从答案编造概率。原始推理文本不落盘，保留最终选择、token 数和延迟。Qwen3 Thinking 与 Intern-Decision 的骨干不同；这个比较提供系统层证据。获得本地 Qwen3.5-4B 后应增加同骨干对照。`--no-thinking` 只有在模型模板支持关闭思考时才构成有效消融；Thinking 专用模型不能据此假定关闭成功。

## E3：校准、冻结路由和真实 handoff

先用**同一个 System-1 checkpoint 和后端**分别预测 calibration、router_validation、test_iid。生成式 System-2 分别预测 router_validation 和 test_iid。下面只列分析命令；各划分的预测用 `predict-s1`/`predict-s2` 获得。

```bash
python -m decision_lab calibrate \
  --data data/labqueue_v1_seed17/calibration.jsonl \
  --predictions runs/calibration.s1.jsonl --output runs/temperature.json
python -m decision_lab select-router \
  --data data/labqueue_v1_seed17/router_validation.jsonl \
  --s1 runs/router_validation.s1.jsonl --s2 runs/router_validation.s2.jsonl \
  --calibration runs/temperature.json --max-route-fraction 0.25 --output runs/router.json
python -m decision_lab evaluate-router \
  --data data/labqueue_v1_seed17/test_iid.jsonl \
  --s1 runs/test_iid.s1.jsonl --s2 runs/test_iid.s2.jsonl \
  --router runs/router.json --output runs/router-test.json
python -m decision_lab evaluate \
  --data data/labqueue_v1_seed17/test_iid.jsonl \
  --predictions runs/test_iid.s1.jsonl --calibration runs/temperature.json \
  --output runs/test-calibration.json
python -m decision_lab route-sweep \
  --data data/labqueue_v1_seed17/test_iid.jsonl \
  --s1 runs/test_iid.s1.jsonl --s2 runs/test_iid.s2.jsonl \
  --calibration runs/temperature.json --output runs/routing-sweep
python -m decision_lab.plots --evaluation runs/test-calibration.json \
  --routing runs/routing-sweep/routing.json --output runs/e3-figures
```

offline replay 同时考虑 System-2 修正和损害，失败时保留 System-1；全 System-2 基线另外报告不回退的准确率。初始模型时间按请求计一次，升级按字段计数。曲线标明顺序重放时间，不能冒充真实在线服务延迟。Oracle 使用测试标签，只作为同预算上界。

真实 API 实验用 `predict-handoff` 调用官方 `ThinkingModel`。预先在进程环境配置 `LLM_BASE_URL` 和 `LLM_API_KEY`，模型名称通过 `--model` 指定；凭据不写入配置或日志。API 路由必须用同一 API 配置的验证集预测重新选阈值，不能把本地生成式模型的阈值优化结果直接冒充 API 路由。

GPU 禁网环境下，`predict-handoff` 在可联网 CPU 端运行，读取共享目录中的题目与 S1 输出；下面的 `online-route` 示例要求模型推理进程能访问 API，当前离线 GPU 条件不满足。实际首轮做本地 S2 和重放，之后实现 CPU 协调的跨节点 handoff 并独立测量交接开销。真实在线跨节点路径尚未完成，不能把重放时间冒充端到端测量。

```bash
python -m decision_lab predict-handoff \
  --data data/labqueue_v1_seed17/router_validation.jsonl \
  --model YOUR_REASONING_MODEL --output runs/router_validation.api.jsonl
python -m decision_lab select-router \
  --data data/labqueue_v1_seed17/router_validation.jsonl \
  --s1 runs/router_validation.s1.jsonl --s2 runs/router_validation.api.jsonl \
  --calibration runs/temperature.json --max-route-fraction 0.25 --output runs/api-router.json
python -m decision_lab online-route \
  --data data/labqueue_v1_seed17/test_iid.jsonl \
  --checkpoint /shared/path/Intern-Decision-4B \
  --model YOUR_REASONING_MODEL --router runs/api-router.json --output runs/online.jsonl
```

官方 handoff 的提示要求最终选项 JSON，不要求公开长解释；是否使用内部推理由所选模型决定。适配器请求 stream usage，记录提供方返回的真实 token 数；若提供方不支持，可加 `--no-usage`，成本保持未知。[官方 handoff 实现](https://github.com/InternLM/Intern-Decision/blob/main/src/inference/thinking.py)。

计价可传入填写了实际费率的 `--rates configs/rates.example.json`。API 使用输入/输出 token 费率；本地模型使用 GPU 时间费率。缺失费率、失败请求用量或 provider usage 时，美元成本为 `null`。重放的策略成本不包括预先收集所有 System-2 预测的研究开销；在线实验应同时保存全部调用用量。

## E4：0.8B 新域微调与能力保持

对种子 17、43、97 分别做零样本预测、训练、独立温度拟合和四个测试划分评估。基线与微调后各跑一遍原七套件，报告遗忘。固定两轮、学习率 2e-6；不凭测试集挑 checkpoint。

已新增三份使用共享 `.venv-xtuner/bin/python` 的队列计划：[种子 17](results/e4_gpu_stage_plan_20261102_seed17_v2.json)、[43](results/e4_gpu_stage_plan_20261102_seed43.json)、[97](results/e4_gpu_stage_plan_20261102_seed97.json)。入口 `scripts/submit_aux_gpu.py --stage e4 --seed 17 --plan` 先生成计划；有效 GPU 授权就绪后按种子去掉 `--plan` 实际提交。该 worker 只执行完整语言骨干训练阶段，`training-stage-complete.json` 明确保留 `e4_complete=false`；随后继续核验最终 HF checkpoint、独立温度、新域四条件及原七套件，不能按测试成绩选择 checkpoint。

```bash
python -m decision_lab.workflows train \
  --checkpoint /shared/path/Intern-Decision-0.8B \
  --data data/labqueue_v1_seed17/train.jsonl \
  --seed 17 --gpus 1 --epochs 2 --lr 2e-6 --output runs/e4-seed17
```

训练 launcher 使用官方 masked next-token 目标，完整微调语言骨干，冻结视觉路径，保存实际 seed 和解析后的配置。它不假定单卡显存足够，真实 GPU 上仍需验证；必要时通过 `--gpus` 调整。训练完成后定位最终 HF checkpoint，并按官方 `scripts.verify_checkpoint` 核查权重和初始加载审计，再使用 `predict-s1`、`calibrate` 和 `evaluate`。微调后温度重新拟合，不能复用官方预设。

训练后使用 [后评测入口](scripts/e4_posttrain.py) 和 [离线 GPU worker](scripts/run_e4_posttrain.sh)。`prepare` 必须读取真实完成的训练阶段目录，核对训练回执、两轮／`2e-6`／种子、固定派生配置及各 rank 初始化审计，从 `.xtuner` 元数据定位唯一最终 HF checkpoint。它不会按目录时间或测试成绩选权重。固定版本的配置 JSON 没有序列化模型子类的冻结参数；入口因此核对派生文件与已固定的配置源码，随后由官方权重核验检查视觉张量保持及语言层更新。

每个训练种子对基线和微调模型各采集 240 条独立校准数据，再评估 IID、规模、表示、组合 OOD；两模型均在相同 HF GPU 后端、原始 `T=1` 下重跑七套件 10,751 行／12,351 个决策，分别保留原始与新域校准结果。新域每个模型共 1,840 个请求，不使用当前 CPU 温度；原七套件保持性使用原始概率。实际阶段的时间、退出码及输出哈希会落盘，任一步失败即停。单种子完成记录仍保留 `e4_complete=false`，还需三个种子齐备及最终独立审计。

```bash
# E4_TRAINING_STAGE 指向实际训练阶段目录，包含 training-stage-complete.json。
.venv-hf/bin/python scripts/e4_posttrain.py prepare \
  --training-stage "$E4_TRAINING_STAGE" \
  --output runs/e4-post17 --plan .runtime/e4-post17.json
# 在获得授权的离线 GPU 节点运行；PLAN_SHA256 为上述计划文件的实际 SHA256。
E4_POST_OUTPUT="$PWD/runs/e4-post17" bash scripts/run_e4_posttrain.sh \
  --prepared .runtime/e4-post17.json --prepared-sha256 "$PLAN_SHA256"
```

[后评测准备核验](results/e4_evaluation_preparation_20261102/verification.json) 包括 8 项合成生命周期／覆盖检查、真实 XTuner 配置对象探针与当前缺失训练产物的拒绝检查。没有真实训练、合法后评测运行计划或 GPU 结果；这些检查不计为 E4 实验完成。原 E2／E4 训练准备计划的 13 份源码均未修改。离线准备记录另补登记了此前新增的 `decision_lab/cpu_recovery.py`；旧记录、差异与复核日志保存在 [准备记录刷新核验](results/e4_evaluation_preparation_20261102/seal_refresh/verification.json)。HF 和 XTuner 的实际启动上下文分别核对，原有源码、已安装库及已发布权重不变，CPU 推理没有重启。

## 输出口径

所有输出要求新目录或新文件。完整覆盖与输入哈希不匹配会终止评估；输出 `.run.json` 记录权重/源码哈希、后端、依赖、GPU 和 warmup。若中断导致缺少预测，不把部分输出作为完整结果。

Brier 是多类概率误差的原始求和，ECE 是 10 个等宽桶的 pooled 指标；同时报告逐套件准确率和 suite macro，避免大套件决定所有结论。置信度采用 max(P)，正温度必须保持 argmax。置信区间按场景组抽样，成对选项变体和同请求字段不作为独立样本。
