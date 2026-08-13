# AI エージェント オンボーディング

> 本リポジトリは、開発における「判断のブレ」を減らすための Development Standards です。
> AI エージェント（Claude / Codex / Gemini 等）がプロジェクトに参加するとき、**最初にこのファイルのみを読みます**。
> 各プロジェクトへは、そのプロジェクトの `CLAUDE.md` 等に本ファイルへのパスを記載して参照させます（submodule等では配布しません）。

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
レイアウト、通知、エラー表示、フォームUX、`shadcn/ui` の利用方針、Semantic Tokenによるスタイリングについて:

👉 [Application UI Standard](../standards/application-ui/)

Reactの基本UIは原則として `shadcn/ui` を使用し、意味を持つ色・状態表現は固定色ではなくSemantic Tokenで表現する。具体的な配色は各プロジェクトのThemeに委ねる。

新規画面・アプリは、Application UI Standardで定義された **Standard / Simple / Focus** のいずれかのレイアウトを原則として起点にする。独自レイアウトをゼロから作る前に、既存レイアウトの拡張で対応できないか確認すること。

---

## Standardを増やそうとしたとき

追加基準と配置先（Core / Optional / Recommendation / Shared implementation / Project側）の判断は、[ADR-0003: StandardsをCoreとOptionalに分離する](../decisions/adr-0003-core-and-optional-standards.md) を正として従ってください。
繰り返しが確認されていないものを先回りしてStandard化しません。

---

## 実装資産について

本リポジトリは「判断の再利用」を扱い、実装コードは含みません。

- 基本UIは各プロジェクトで導入する `shadcn/ui` を利用し、本リポジトリ専用の共通UIパッケージを前提にしません。
- 社員検索や組織選択などのDomain Componentは、そのドメインを所有するプロジェクトで管理します。
- Project TemplateやDjango側の共通実装も、実際の複数プロジェクトで繰り返しが確認されてから分離を検討します。
- 各レイヤーの整備状況は [README「関連レイヤーの所在」](../README.md#関連レイヤーの所在) を参照してください。
