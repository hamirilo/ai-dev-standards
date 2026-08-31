# ADR-0006: Platformを共有開発資産の統合入口とする

**ステータス**: 採用

## コンテキスト

[ADR-0004](adr-0004-shared-asset-boundaries.md) では、Standard、詳細手順、UI実装等を利用方法・更新頻度・配布方法の違いに応じて分離する方針を採用した。この原則自体は有効だったが、分離された資産をApplicationやAIが個別に探索すると、入口・参照方法・バージョンの組合せがプロジェクトごとにずれる問題が残った。

また、その後の運用で次のドリフトが発生した。

- StandardsとPlatformの両方にAI向けONBOARDINGが存在した。
- Recommendations本文がStandardsとPlatformの両方に存在した。
- PlatformはStandards / Playbookをsubmoduleとして組み合わせている一方、Standards READMEは「submodule等では配布しない」と説明していた。
- Platformの導入・既存Applicationへの適用手順がGovernance Optional Standardへ置かれていた。
- Docker Compose等で、StandardとPlaybookの双方に具体例・移行・検証方法が重複した。
- UI資産について、repositoryとしての `ui-platform` とpackage利用名 `application-ui-kit` が混同されていた。

## 決定

1. `ai-dev-platform` をApplicationから見た **共有開発資産の唯一の統合入口（composition root）** とする。
2. Platformは資産本文を吸収するモノレポではなく、AIルーター、Adoption Guide、Recommendations、Standards / Playbookのversion組合せを管理する。
3. `ai-dev-standards` は **何を守るか** を扱う。判断原則と、揃っていること自体に価値があるCore / Optional Standardだけを正本として持つ。
4. Recommendationは **普段は何を選ぶか** を扱い、`ai-dev-platform/recommendations` を正本とする。StandardsにはRecommendation本文を重複して持たない。
5. `ai-dev-playbook` は **どう実装・移行・検証・復旧するか** を扱う。具体例、コマンド、チェックリスト、トラブルシューティングはStandardへ重複して持たない。
6. `ui-platform` はUIのComponent、Pattern、Template、Catalog / Storybook等の設計・実装資産を扱う。`application-ui-kit` はApplicationから利用するときのpackage依存名として区別する。
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

同じテーマがStandardとPlaybookの双方に存在すること自体は禁止しない。ただし、同じ内容をコピーしない。

Standardは **判断・制約** を持ち、Playbookは **実施方法** を持つ。

例えばDocker Composeでは、Standardは「外部から必要なサービスだけをhostへpublishする」という公開境界を決める。次の内容はPlaybookが扱う。

- 既存 `ports:` の棚卸し
- YAMLの具体例
- DB / Redisの接続先変更
- `docker compose config` 等による検証
- 既存環境を壊さない移行順序
- Before / Afterの記録
- よくある失敗と障害対応

この区別により、Standardを実装手順集へ戻さない。

## Recommendationsの互換パス

既存Standard内にはStandardsリポジトリ内の `recommendations/` への相対リンクが存在するため、移行時点では旧パスを直ちに削除せず、Platformの正本へ誘導する最小の互換ポインタだけを残す。

互換ファイルへRecommendation本文を追加・更新しない。正本は常にPlatformとする。

## 結果

- Applicationから見たAI向け入口をPlatformの1箇所にできる。
- Standardsを判断原則に限定できる。
- 詳細な実装知識をPlaybookへ蓄積してもStandardが肥大化しない。
- Recommendationsの本文を二重管理しない。
- 導入・移行手順がGovernance Standardへ混ざらない。
- PlatformがStandards / Playbookの組合せをpinするため、Applicationごとの参照versionのずれを減らせる。
- UI repositoryとApplication向けpackage名の役割を区別できる。

## 例外・見直し

別レイヤーの内容を同じリポジトリへ統合する場合は、同じリリースで更新する必要性があり、分離による負担が実際に上回ることを別ADRで説明する。

単にリンクしやすい、同じ公開範囲である、AIが一度に読めるという理由だけでは統合しない。
