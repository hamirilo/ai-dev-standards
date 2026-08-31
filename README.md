# AI Development Standards

**「複数のリポジトリを継続的に開発するときに、AIと人間の判断・実装・UI/UXのブレを減らす」**ための Opinionated な開発スタンダードです。

本リポジトリは、あらゆる技術スタックに対応する汎用ガイドラインではなく、**Djangoを中心としたWebアプリケーションを、AI支援で効率的・一貫して開発するための少数の強いデフォルト**を提供します。

Standardの価値は項目数や網羅性ではなく、実際に繰り返される重要な判断を少ないルールで再利用できることにあります。有用なベストプラクティスであることや、将来役立ちそうであることだけを理由にStandardを増やしません。

## 位置づけ

このリポジトリは **「何を守るか」** の正本です。

利用時の統合入口、Recommendations、導入・適用手順は [ai-dev-platform](https://github.com/hamirilo/ai-dev-platform) が扱います。詳細な実装・移行・検証手順は [ai-dev-playbook](https://github.com/hamirilo/ai-dev-playbook)、UI設計・再利用可能なUI実装は [ui-platform](https://github.com/hamirilo/ui-platform) が扱います。

通常のApplicationは本リポジトリを直接submoduleとして組み込みません。`ai-dev-standards` は `ai-dev-platform` のsubmoduleとしてバージョン固定され、ApplicationのAI設定は **Platform側の `ai/ONBOARDING.md` を唯一の入口として参照**します。

```text
Application
    |
    v
ai-dev-platform/ai/ONBOARDING.md
    |
    +-- standards/       [submodule: ai-dev-standards]
    +-- recommendations/
    +-- playbook/        [submodule: ai-dev-playbook]
    +-- ui-platform      [independent repository]
```

Platform自体の初回導入や既存プロジェクトへの適用方法は、PlatformのREADME / Adoption Guideを参照してください。

## 構成と役割

| ディレクトリ | 役割 | 内容 |
|---|---|---|
| `standards/governance/` | **人・AIはどう行動するか** | AI利用方針、Git運用、Standard逸脱時のルール |
| `standards/architecture/` | **システムをどう作るか** | Django/PostgreSQL/React Islands等の技術構成、認可、Security、Logging、Testing |
| `standards/application-ui/` | **画面構造・操作をどう揃えるか** | UI原則、Layout、Semantic Token、コンポーネント利用方針 |
| `decisions/` | **Standard自体のADR** | なぜ現在のStandard構成・境界になったか |

本リポジトリには、Recommendations、導入手順、詳細Playbook、UI実装コード、Application向けAIルーターを重複して持ちません。

## Core と Optional

各Standard領域の `README.md` は、対象プロジェクトの大半に適用する **Core Standard** です。
特定機能だけに必要な共通契約は、各領域の `optional/` 配下へ分離します。

- Coreは少数で変わりにくい判断だけを持つ
- Optionalは該当機能を扱う場合のみ参照する
- Optionalは「揃っていること自体に価値がある仕様」に限定する
- 実装手順・移行手順・検証手順はPlaybookへ置く
- 現時点のライブラリ選定はRecommendationへ置く
- プロジェクト固有の判断はProject Context / ADRへ置く

この分離の理由と追加基準は [ADR-0003](decisions/adr-0003-core-and-optional-standards.md) を参照してください。

## 既存プロジェクトへの適用方針

Standardは原則として、**これから行う判断・新規実装・変更箇所のデフォルト**を定めます。

既存実装が現在のStandardと異なることだけを理由に、一括移行、全面的なリファクタリング、依存ライブラリの置換、インフラ更新を要求しません。

Standardレビューで見つかった事項は次のように扱います。

- **Required**: 今回の新規・変更箇所でStandardに反するもの、またはセキュリティ、データ整合性、必須CIゲート等に関わる現在の問題
- **Adopt going forward**: 変更対象外の既存方式が現在のStandardと異なるもの。直ちに一括移行せず、今後その箇所を変更するときに寄せる
- **Optional improvement**: 品質向上、近代化、追加機能等。Standard適合とは分離する

具体的な導入・棚卸しの進め方はPlatform側のAdoption Guideで扱います。

## Standard以外の配置先

| レイヤー | 答える質問 | 正本 |
|---|---|---|
| **Standard** | 何を守るか | `ai-dev-standards` |
| **Recommendation** | 普段は何を選ぶか | `ai-dev-platform/recommendations` |
| **Playbook** | どう実装・移行・検証するか | `ai-dev-playbook` |
| **UI Platform** | UIをどう設計し、何を再利用するか | `ui-platform` |
| **Project Context / ADR** | このプロジェクト固有ではどうするか | 各Application |

同じ判断や手順を複数の層へコピーしません。Standardには判断原則だけを残し、具体例・コマンド・移行チェックリスト・トラブルシューティングが必要になった場合はPlaybookを参照します。

## 基本原則

1. **Standardは判断の再利用に限定する**: 実装手順集や知識ベースへ拡張しない。
2. **Standardからの逸脱は許容する**: 重要な逸脱だけをプロジェクト側ADR等に記録する。
3. **繰り返しがないものを先回りして標準化しない**: 将来必要になるかもしれないという理由でStandardを増やさない。
4. **追加より既存ルールへの統合を優先する**: 既存Standardで判断できるなら新しいルールを作らない。
5. **HowをStandardへ持ち込まない**: 実装・移行・検証・障害対応はPlaybookへ分離する。

Standardへの追加基準は [ADR-0003](decisions/adr-0003-core-and-optional-standards.md)、共有資産の境界は [ADR-0004](decisions/adr-0004-shared-asset-boundaries.md)、共有資産をフォークして利用する場合の運用は [ADR-0005](decisions/adr-0005-upstream-fork-operation.md) を参照してください。

## 意図的に扱わないもの

本リポジトリは、Web開発のベストプラクティス全集、包括的なAI向け知識ベース、詳細手順集、プロジェクト全体の改善チェックリストを目指しません。

次のような内容はStandardではなく、必要に応じてPlatform / Playbook / Project側で扱います。

- ai-dev-platform自体の導入・更新手順
- 既存リポジトリの移行チェックリスト
- CI/CD・デプロイ・インフラの詳細手順
- Docker Compose設定の棚卸し・変更手順・検証コマンド
- ライブラリの候補比較や現時点の推奨
- プロジェクト固有の機能要件・運用手順
- UI Component / Pattern / Template / Storybook
- AIエージェント定義、モデル設定、複雑なワークフロー実行基盤

## メンテナンスツール

本リポジトリ自体のメンテナンス用に最小限のツールを用意しています。独自の大規模な検証基盤は構築しません。

```bash
just check-docs
```
