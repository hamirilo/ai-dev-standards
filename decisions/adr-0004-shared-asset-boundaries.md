# ADR-0004: 共有開発資産を用途・ライフサイクルで分離する

**ステータス**: 採用

## コンテキスト

AI開発では、同じ判断・調査・実装・UI検討を繰り返さないことがコスト削減につながる。一方で、Standard、詳細手順、UI実装、導入手順を一つの巨大な知識ベースへ集約すると、AIが読む量と保守範囲が増え、責務が曖昧になる。

その後、分離された資産を利用者が毎回個別に探索する負担も確認されたため、資産そのものを統合するのではなく、**利用時の入口とバージョン組合せだけを `ai-dev-platform` に集約する**構成を採用する。

## 決定

1. `ai-dev-standards` は **何を守るか** を扱う。判断原則と、揃っていること自体に価値があるCore / Optional Standardだけを管理する。
2. Recommendationは **普段は何を選ぶか** を扱い、`ai-dev-platform/recommendations` を正本とする。StandardsにはRecommendation本文を重複して持たない。
3. `ai-dev-playbook` は **どう実装・移行・検証・復旧するか** を扱う。具体例、コマンド、チェックリスト、トラブルシューティングはStandardへ重複して持たない。
4. `ui-platform` はUIのComponent、Pattern、Template、Catalog / Storybook等の設計・実装資産を扱う。ApplicationがUI packageを利用する場合、実際の依存versionはApplication側の `package.json` / lockfileを正とする。
5. `ai-dev-platform` は資産を吸収するモノレポではなく、**統合入口（composition root）** とする。Standards / Playbookをsubmoduleとして組み合わせ、RecommendationsとAI向けルーター、導入ガイドを持つ。
6. 各Applicationは `ai-dev-standards` や `ai-dev-playbook` を直接submoduleとして組み込まない。ワークスペース上の `ai-dev-platform/ai/ONBOARDING.md` を入口として参照する。
7. 対象ユーザー、認証の要否、主対象デバイス、認可粒度等のプロジェクト固有前提は、各ApplicationのProject Context / ADRで管理する。
8. 社員検索、組織ツリー、認証基盤連携等の業務ドメイン固有資産は、そのドメインを所有するプロジェクトで管理する。

## 境界

| 資産 | 答える問い | 正本 | 利用方法 |
|---|---|---|---|
| Standard | 何を守るか | `ai-dev-standards` | Platformから必要なCore / Optionalを参照 |
| Recommendation | 普段は何を選ぶか | `ai-dev-platform/recommendations` | 新規採用・依存変更時に参照 |
| Playbook | どう実施するか | `ai-dev-playbook` | タスク単位で必要な手順だけ参照 |
| UI Platform | UIをどう設計し、何を再利用するか | `ui-platform` | UIタスク時に参照。package利用時はApplicationのlockfileを正とする |
| Adoption / Routing | どう導入し、どこを読むか | `ai-dev-platform` | Platform README / `ai/ONBOARDING.md` / Adoption Guide |
| Project Context / ADR | このプロジェクト固有ではどうするか | 各Application | 実装前に必要な前提だけ参照 |

## StandardとPlaybookの分離例

同じテーマがStandardとPlaybookの両方に存在すること自体は問題ではない。ただし、同じ内容をコピーしない。

例えばDocker Composeでは、Standardは「外部から必要なサービスだけをhostへpublishする」という公開境界を決める。`ports:` の棚卸し、YAML例、接続先変更、検証コマンド、移行手順はPlaybookが扱う。

このように **Standardは判断、Playbookは実施** に分ける。

## 結果

- Applicationから見たAI向け入口をPlatformの1箇所にできる。
- Standardを短く保ちながら、詳細な実装知識をPlaybookへ蓄積できる。
- Recommendationの二重管理を防げる。
- 導入・移行手順がGovernance Standardへ混ざらない。
- UI資産、実装手順、判断原則をそれぞれ異なる更新頻度・利用方法で管理できる。
- Platform自体はルーティングと組合せに限定され、巨大なモノレポ化を避けられる。

## 例外・見直し

別レイヤーの内容を同じリポジトリへ統合する場合は、同じリリースで更新する必要性があり、分離による負担が実際に上回ることをADRで説明する。単にリンクしやすい、同じ公開範囲である、AIが一度に読めるという理由だけでは統合しない。
