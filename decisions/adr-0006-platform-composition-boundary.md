# ADR-0006: Platformを共有開発資産の統合入口とする

**ステータス**: 採用

## コンテキスト

Standard、Recommendations、Playbook、UI実装、プロジェクト固有判断は、目的・更新頻度・利用方法が異なります。これらを一つの巨大なリポジトリへ集約すると責務が曖昧になり、AIが読む量と保守範囲も増えます。

一方、利用側が各資産を個別に探索・取得すると、入口や参照versionがApplicationごとにずれます。

そのため、資産本文は責務ごとに分離したまま、利用時の入口とStandards / Playbookのversion組合せだけをPlatformへ集約します。

## 決定

1. `ai-dev-platform` をApplicationから見た **共有開発資産の唯一の統合入口（composition root）** とする。
2. Platformは資産本文を吸収するモノレポではなく、AIルーター、Adoption Guide、Recommendations、Standards / Playbookのversion組合せを管理する。
3. `ai-dev-standards` は **何を守るか** を扱う。技術選定、責務境界、守る制約と、揃っていること自体に価値があるCore / Optional Standardだけを正本として持つ。
4. Recommendationは **普段は何を選ぶか** を扱い、`ai-dev-platform/recommendations` を正本とする。
5. `ai-dev-playbook` は **どう実装・移行・検証・復旧するか** を扱う。具体例、コマンド、チェックリスト、トラブルシューティングはPlaybookへ置く。
6. `ui-platform` はUIのFoundations、Components、Patterns、Templates、Catalog / Storybook等の設計・実装資産を扱う。`application-ui-kit` はApplicationから利用するときのpackage依存名として区別する。
7. 各Applicationは `ai-dev-standards` / `ai-dev-playbook` を直接submoduleとして組み込まず、ワークスペース上の `ai-dev-platform/ai/ONBOARDING.md` をAI向け入口として参照する。
8. `ai-dev-platform` はStandards / Playbookをsubmoduleとしてpinし、どの組合せを利用するかのSource of Truthとなる。
9. Platformの初回導入、更新、既存Applicationへの段階適用はPlatformのAdoption Guideで扱い、Governance Standardへ置かない。
10. Project Context / ADRは各Applicationが所有する。対象ユーザー、認証、主対象デバイス、認可粒度等のプロジェクト固有前提をPlatformやStandardsへ移さない。

## 境界

| 資産 | 答える問い | 正本 | 利用方法 |
|---|---|---|---|
| Standard | 何を守るか | `ai-dev-standards` | Platformから必要なCore / Optionalを参照 |
| Recommendation | 普段は何を選ぶか | `ai-dev-platform/recommendations` | 新規採用・依存変更時に参照 |
| Playbook | どう実施するか | `ai-dev-playbook` | タスク単位で必要な手順だけ参照 |
| UI Platform | UIをどう設計し、何を再利用するか | `ui-platform` | UIタスク時に参照 |
| Application UI Kit | UI packageとして何を利用するか | `ui-platform` が提供するpackage | versionはApplicationの `package.json` / lockfileを正とする |
| Adoption / Routing | どう導入し、どこを読むか | `ai-dev-platform` | README / `ai/ONBOARDING.md` / Adoption Guide |
| Project Context / ADR | このプロジェクト固有ではどうするか | 各Application | 実装前に必要な前提だけ参照 |

## StandardとPlaybookの分離

同じテーマがStandardとPlaybookの双方に存在すること自体は禁止しません。ただし、同じ内容をコピーしません。

Standardは **判断・制約** を持ち、Playbookは **具体的な実施方法** を持ちます。

例えばDocker Composeでは、Standardは「外部から必要なサービスだけをhostへpublishする」という公開境界を決めます。次の内容はPlaybookが扱います。

- 既存 `ports:` の棚卸し
- YAMLの具体例
- DB / Redisの接続先変更
- `docker compose config` 等による検証
- 既存環境を壊さない移行順序
- Before / Afterの記録
- よくある失敗と障害対応

同様に、Djangoを採用することや責務境界はStandardで決められますが、具体的なファイル配置例、実装例、変更手順はPlaybookで扱います。

## 結果

- Applicationから見たAI向け入口をPlatformの1箇所にできる。
- Standardsを判断原則と制約に限定できる。
- 詳細な実装知識をPlaybookへ蓄積してもStandardが肥大化しない。
- RecommendationsをPlatformだけで管理できる。
- 導入・適用手順がGovernance Standardへ混ざらない。
- PlatformがStandards / Playbookの組合せをpinするため、Applicationごとの参照versionのずれを減らせる。
- UI repositoryとApplication向けpackage名の役割を区別できる。

## 例外・見直し

別レイヤーの内容を同じリポジトリへ統合する場合は、同じリリースで更新する必要性があり、分離による負担が実際に上回ることを別ADRで説明します。

単にリンクしやすい、同じ公開範囲である、AIが一度に読めるという理由だけでは統合しません。
