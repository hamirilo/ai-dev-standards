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
6. **新しいライブラリ・パッケージを追加する前に [Recommendations](../recommendations/) を確認すること。** 未収録のものを導入する場合は、健全性チェックの結果を短く提示してから追加すること。
7. **実装に入る前に、対象プロジェクトの `decisions/project-context.md` があれば読むこと。** 対象ユーザー、認証の要否、主対象デバイス、認可の粒度といった前提を勝手に仮定しないこと。存在しない場合でも無関係な小規模修正は止めず、前提がタスクの設計を実質的に左右する場合だけ確認すること。その他のプロジェクト側ADRは、関連するタスクを扱う場合のみ読むこと。

---

## 参照先（ルーター）

### 1. 開発フロー・ガバナンス・Git運用
AIと人間の行動規範、モデル選定、レビュー方針、Standard追加時の判断について:

👉 [Governance & Rules](../standards/governance/)

リポジトリの立ち上げや、既存リポジトリのStandard適合を行う場合のみ、Governanceから `standards/governance/optional/project-setup.md` へ進むこと。

### 2. バックエンド・技術構成・認証・ログ・API
Django構成、Reactの責務、OIDC、認可、Security、Logging、Testing、API利用基準など:

👉 [Architecture Standard](../standards/architecture/)

特定機能にOptional Standardがある場合のみ、Architecture Standardから該当ファイルへ進むこと。
例: 共通ダッシュボード向けのStatus APIを実装・利用する場合は `standards/architecture/optional/status-api.md` を読む。

### 3. フロントエンド・画面構造・操作の一貫性
レイアウト、通知、エラー表示、フォームUX、`shadcn/ui`、Semantic Tokenについて:

👉 [Application UI Standard](../standards/application-ui/)

詳細なTheme設定やAIによる画面デザインなど、該当するOptional Standardがある場合のみApplication UI Standardから参照すること。

### 4. ライブラリ選定（Standardではない）
動画、画像、チャート、地図、アイコン等、`shadcn/ui` で解決しない領域の既定と、非推奨ライブラリについて:

👉 [Recommendations](../recommendations/)

依存を追加・変更する場合のみ読むこと。Standardと異なり拘束力は弱く、逸脱にADRを求めない。

---

## Standardを増やそうとしたとき

追加基準と配置先（Core / Optional / Recommendation / Shared implementation / Project側）の判断は、[ADR-0003: StandardsをCoreとOptionalに分離する](../decisions/adr-0003-core-and-optional-standards.md) を正として従ってください。
繰り返しが確認されていないものを先回りしてStandard化しません。

---

## 実装資産について

本リポジトリは「判断の再利用」を扱い、実装コードは含みません。
実装資産の配置先や整備状況は [README「Standard以外の配置先」](../README.md#standard以外の配置先) を参照してください。
