# AI エージェント オンボーディング

> 本リポジトリは、開発における「判断のブレ」を減らすための Development Standards です。
> AI エージェント（Claude / Codex / Gemini 等）がプロジェクトに参加するとき、**最初にこのファイルのみを読みます**。

---

## 必守事項

1. **既存Standardを確認してから新しい判断を行うこと。**
2. **既存Component / Shared実装がある場合は再実装しないこと。**
3. 最初からすべてのドキュメントを読まないこと。**タスクに必要なCore Standardだけを読み、Optional Standardは該当機能を扱う場合のみ読むこと。**
4. Standardから重要な逸脱をする場合は、プロジェクト側で理由（ADR等）を残すこと。
5. 新しいStandardやレイアウト・共通実装を「将来使うかもしれない」という理由だけで増やさないこと。

---

## 参照先（ルーター）

### 1. 開発フロー・ガバナンス・Git運用
AIと人間の行動規範、モデル選定、レビュー方針、Standard追加時の判断について:

👉 [Governance & Rules](../standards/governance/)

### 2. バックエンド・技術構成・認証・ログ・API
Django構成、Reactの責務、OIDC、認可、Security、Logging、Testing、API利用基準など:

👉 [Architecture Standard](../standards/architecture/)

特定機能にOptional Standardがある場合のみ、Architecture Standardから該当ファイルへ進むこと。
例: 共通ダッシュボード向けのStatus APIを実装・利用する場合は `standards/architecture/optional/status-api.md` を読む。

### 3. フロントエンド・画面構造・操作の一貫性
レイアウト、通知、エラー表示、フォームUXなど:

👉 [Application UI Standard](../standards/application-ui/)

新規画面・アプリは、Application UI Standardで定義された **Standard / Simple / Focus** のいずれかのレイアウトを原則として起点にする。独自レイアウトをゼロから作る前に、既存レイアウトの拡張で対応できないか確認すること。

---

## Standardを増やそうとしたとき

まず [ADR-0003: StandardsをCoreとOptionalに分離する](../decisions/adr-0003-core-and-optional-standards.md) を確認してください。

- 大半のプロジェクトに適用する変わりにくい判断 → **Core候補**
- 特定機能を使う場合だけ必要な共通仕様 → **Optional候補**
- 特定ライブラリのデフォルト候補 → **Recommendation**
- 再利用する実装コード → **Shared implementation / Shared UI**
- 1プロジェクトだけの判断 → **Project側**

繰り返しが確認されていないものを先回りしてStandard化しません。

---

## 実装資産について

本リポジトリは「判断の再利用」を扱い、実装コードは含みません。
UIコンポーネントやUI系Recommendationは別のShared UIリポジトリ等から利用します。
Project TemplateやDjango側の共通実装も、実際の複数プロジェクトで繰り返しが確認されてから分離を検討します。
