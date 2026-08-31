# AI Development Standards

**「複数のリポジトリを一人で継続的に開発するときに、AIと人間の判断・実装・UI/UXのブレを減らす」** ための Opinionated な開発スタンダードです。

本リポジトリは、あらゆる技術スタックに対応する汎用的なガイドラインではなく、**「Djangoを中心としたWebアプリケーションを、AI支援で効率的・一貫して開発するため」** の具体的で強いデフォルト（Opinion）を提供します。

Standardの価値は項目数や網羅性ではなく、**実際に繰り返される重要な判断を少ないルールで再利用できること**にあります。有用なベストプラクティスであることや、将来役立ちそうであることだけを理由にStandardを増やしません。

## 構成と役割

このリポジトリは「どう作るべきか（判断の再利用）」を定義するものであり、「実際のUIコンポーネントやテンプレートの実装コード」は含まれません。

| ディレクトリ | 役割 | 内容 |
|---|---|---|
| `ai/` | （移動済み） | ルーターは `ai-dev-platform/ai/ONBOARDING.md` にある。ここには誘導だけを残している |
| `standards/governance/` | **人・AIはどう行動するか** | AI利用方針、Git運用、Standard逸脱時のルール |
| `standards/architecture/` | **システムをどう作るか** | Django/PostgreSQL/React Islands等の技術選定、ファイル構成、権限管理 |
| `standards/application-ui/` | **画面構造・操作の一貫性** | UIの基本原則、Layouts定義（画面レイアウトのパターン）、コンポーネント利用方針 |
| `decisions/` | **ADR (アーキテクチャ決定記録)** | なぜ現在のStandardやArchitectureになったのかを説明する重要な過去の技術決定の背景 |

## Core と Optional

各Standard領域の `README.md` は、対象プロジェクトの大半に適用する **Core Standard** です。
特定機能だけに必要な詳細仕様は、各領域の `optional/` 配下へ分離します。

- Coreは少数で変わりにくい判断だけを持つ
- Optionalは該当機能を扱う場合のみ参照する
- Optionalは必要であればURL、レスポンス形式、運用契約等まで具体的に規定できる
- 特定ライブラリの候補、実装コード、プロジェクト固有の判断をStandardへ混ぜない

この分離の理由と追加基準は [ADR-0003](decisions/adr-0003-core-and-optional-standards.md) を参照してください。

## 利用方法（プロジェクトからの参照）

**各アプリへは submodule として配布しません**（[ADR-0004](decisions/adr-0004-shared-asset-boundaries.md) 項目8）。一方、統合入口である `ai-dev-platform` からは `standards/` submodule として参照されます。プロジェクトが読むのは常に `ai-dev-platform` 側の入口です。

```markdown
<!-- 各プロジェクトの CLAUDE.md への記載例 -->
開発Standardは ../ai-dev-platform/ai/ONBOARDING.md を最初に読むこと。
```

開発中は最新のmainを参照してよいものとします。ただし、同じ判断を再現したい作業やドキュメント生成では、`ai-dev-platform` 側で release tag または commit を pin します。各アプリへsubmoduleや実行時依存として組み込む必要はありません。

### 既存プロジェクトへの適用

Standardは原則として、**これから行う判断・新規実装・変更箇所のデフォルト**を定めます。

既存実装が現在のStandardと異なることだけを理由に、一括移行、全面的なリファクタリング、依存ライブラリの置換、インフラ更新を要求しません。既存部分は必要な変更を行うときにStandardへ寄せることを基本とします。

Standardを使ったレビューで見つかった事項は、次のように扱います。

- セキュリティ、データ整合性、必須CIゲート等に関わる重大な問題 → 必要な修正として扱う
- 現在のStandardと異なる既存方式 → 原則として今後の新規・変更箇所から寄せる
- 品質向上、近代化、追加機能等 → Standard適合作業から分離し、通常の改善候補として扱う

Standardレビューを、リポジトリ全体の改善監査や近代化ロードマップ作成へ自動的に拡張しません。

## Standard以外の配置先

Standardへ置かない判断や実装資産の主な配置先です。

| レイヤー | 内容 | 現状 |
|---|---|---|
| **Project Context / ADR** | 対象ユーザー、利用環境、認証・認可、プロジェクト固有の重要判断 | 各プロジェクトで管理 |
| **Domain Components** | EmployeePicker等、業務ドメイン固有の再利用UI | 所有するドメイン／プロジェクトで管理 |
| **Recommendation** | サードパーティライブラリの既定、品質向上の推奨チェック | ai-dev-platform の `recommendations/`（本リポジトリから移動済み） |
| **Playbook / Starter** | 詳細な実装手順、検証方法、失敗例、新規プロジェクトの開始点 | ai-dev-playbook（Standardとは別リポジトリ。必要時のみ参照） |
| **Application UI Kit** | 汎用UIの設計参照、実装コード、Pattern、Template、Storybook | ui-platform（Standardとは別リポジトリ。パッケージ名は `application-ui-kit` のまま） |

### Recommendation・Playbook・UI Kitの境界

| 層 | 答える質問 | 置き場所 |
|---|---|---|
| Recommendation | 現時点で何を選ぶか | ai-dev-platform |
| Playbook | どう実施するか | ai-dev-playbook |
| UI Kit | どのデザイン・実装を再利用するか | ui-platform |

Recommendationは短い現在の既定、Playbookは詳細な手順・検証・失敗例です。UI KitはClaude Design向けの設計参照と、再利用可能なUI実装を管理します。これらをStandardへ取り込んで常時読ませません。

未整備のレイヤーが受け皿になる判断は、整備されるまで各プロジェクト側で行い、重要な選定はプロジェクト側のADR等に記録します。AIは存在しないレイヤーを探索しません。

## 基本原則

1. **AIファースト・ルーター**: すべてのドキュメントを最初からAIに読ませるのではなく、`ai-dev-platform/ai/ONBOARDING.md` を起点として、タスクに必要なStandardだけを読ませるようにします。
2. **Standardからの逸脱は許容する**: Standardは強いデフォルトですが、絶対的な制約ではありません。あえて異なる技術選定をするなど、重要な逸脱を行った場合は、プロジェクト側のADRとして「なぜ外れたのか」を記録します。
3. **実装との分離**: 本リポジトリにはUIコンポーネント（EmployeePicker等）やプロジェクト雛形の「実コード」は置きません。基本UIは shadcn/ui を基礎とする採用済みの Application UI Kit または各プロジェクトで管理し、業務ドメイン固有の共有UIはそのドメインを所有する側で管理します。Playbook、Starter、UI実装は、それぞれの外部資産リポジトリで管理します。
4. **繰り返しがないものを先回りして標準化しない**: 「将来必要になるかもしれない」だけでStandard、Template、Shared実装を増やしません。
5. **追加より既存ルールへの統合を優先する**: 新しい知識が有用でも、既存Standardで判断できるなら新しいルールを追加しません。不要になったルールは残し続けず、削除・統合を検討します。

## Standardへ追加する前に

追加基準と配置先の判断は [ADR-0003](decisions/adr-0003-core-and-optional-standards.md) を正とします。要点は「複数プロジェクトで繰り返しが確認された判断だけを、Core / Optional / Standard以外の適切な場所へ置く」ことです。**有用であること、一般的なベストプラクティスであること、将来役立ちそうであることだけでは追加理由になりません。** 基準の重複記載による記述ドリフトを避けるため、本READMEには基準の詳細を再掲しません。

共有資産をStandardへ取り込まない境界と、Standard・Playbook・UI Kitの分離理由は [ADR-0004](decisions/adr-0004-shared-asset-boundaries.md) を参照してください。

共有資産のリポジトリをフォークして採用する場合の運用（フォークにソース差分を持たない、配布物の識別子は公開時に所有者から導出する、組織固有のものは所有プロジェクトへ置く）は [ADR-0005](decisions/adr-0005-upstream-fork-operation.md) を参照してください。

## フォーク差分（ADR-0005 項目5 の記録）

本リポジトリは上流のフォークです。[ADR-0005](decisions/adr-0005-upstream-fork-operation.md)
項目1 は「フォークにソース差分を持たない」と定めていますが、次の 2 点は
**上流では意味を持たない構成差分**なので、やむを得ずフォーク側に持っています。
項目5 に従い、差分と再適用手順をここに記録します。

| 差分 | 内容 | 上流へ出さない理由 |
|---|---|---|
| Recommendations の移設 | `recommendations/` を本リポジトリから削除し、`ai-dev-platform/recommendations/` を正とした。`standards/**` からの内部リンクは `../../../recommendations/` のように 1 階層多く辿る | `ai-dev-platform` という統合入口の存在が前提。上流にこの階層は無い |
| ルーターの移設 | `ai/ONBOARDING.md` を `ai-dev-platform/ai/ONBOARDING.md` へ移し、ここには誘導スタブだけを残した | 同上。入口が 2 つあるとエージェントへの指示が分岐する |

**上流を取り込み直したときの再適用手順:**

1. 上流が `recommendations/` を更新していたら、その差分を `ai-dev-platform/recommendations/`
   へ反映する（本リポジトリ側には戻さない）
2. 上流が `ai/ONBOARDING.md` を更新していたら、その差分を
   `ai-dev-platform/ai/ONBOARDING.md` へ反映する。スタブは上書きしない
3. `standards/**` に `../../recommendations/` のような**上流の階層のままの相対リンク**が
   入っていないか確認する。入っていたら `../` を 1 つ足す
4. `standards/**` から `ai/ONBOARDING.md` を参照している箇所は
   `ai-dev-platform` 側（`../../../../ai/ONBOARDING.md`）を指しているか確認する

汎用的な改善（Standard の内容そのもの）は、ADR-0005 項目3 に従って上流へ PR を出します。
上記の構成差分だけをフォークに留めます。

## 意図的に扱わないもの

本リポジトリは、Web開発のベストプラクティス全集、包括的なAI向け知識ベース、詳細手順集、プロジェクト全体の品質改善チェックリストを目指しません。

次の領域は、現時点で本Standardの対象外です。繰り返しの判断が実際に発生し、統一しないことによる問題が確認された場合にのみ再検討します。

- CI/CD・リリースフローの詳細な実装
- デプロイ・インフラ構成、バックアップ等の運用手順の詳細
- ネーミング・コーディングスタイルの詳細規約（各プロジェクトのlint / formatter設定に委ねる）
- アクセシビリティの詳細仕様（基本操作性の原則のみApplication UI Standardに置き、詳細化は実際の必要性が確認された場合に検討する）
- i18n / 多言語対応

## メンテナンスツール

本リポジトリ自体のメンテナンス用に最小限のツールを用意しています。
プラットフォーム化を防ぐため、独自の大規模な検証スクリプト等は構築しません。

```bash
# ドキュメントのリンク切れなどをチェック (要: just, lychee)
just check-docs
```
