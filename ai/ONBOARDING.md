# AI エージェント オンボーディング

> 本リポジトリは、開発における「判断のブレ」をなくすための Development Standards です。
> AI エージェント（Claude / Gemini 等）がプロジェクトに参加するとき、**最初にこのファイルのみを読みます**。

---

## 必守事項

1. **既存Standardを確認してから新しい判断を行うこと。**
2. **既存Componentがある場合は再実装しないこと。**
3. 最初からすべてのドキュメントを読まないこと。**タスクに必要なStandardだけを読むこと。**
4. Standardから重要な逸脱をする場合は、プロジェクト側で理由（ADR等）を残すこと。軽微な例外までADRを要求しない。
5. 新しいStandardを追加する前に、それがCore / Optional / Recommendation / Shared実装 / Project固有のどこに属するかを判断すること。

---

## 参照先（ルーター）

以下の分類に従い、**タスクに必要なドキュメントだけをピンポイントで参照**してください。

### 1. 開発フロー・ガバナンス・Git運用
AIと人間の行動規範、コスト管理、レビュー方針、Standard追加判断については以下を参照してください。

👉 [Governance & Rules](../standards/governance/)

### 2. バックエンド・システム設計
Djangoの構成、Reactの責務、認証・認可、Security、Logging、Testing、API利用基準などについては以下を参照してください。

👉 [Architecture Standard](../standards/architecture/)

Architecture配下の `optional/` は、該当機能を扱う場合のみ読みます。通常タスクで先回りしてすべて読んではいけません。

例:

- 共通ダッシュボード・死活監視を実装する → `standards/architecture/optional/status-api.md`

### 3. フロントエンド・画面構造・操作の一貫性
レイアウト、ナビゲーション位置、通知、エラー表現、フォームUXなどについては以下を参照してください。

👉 [Application UI Standard](../standards/application-ui/)

新規アプリ・新規画面のレイアウトは、原則としてStandard App / Simple App / Focus Appのいずれかをベースにします。画面ごとにナビゲーション構造をゼロから設計せず、固有要件はまず既存レイアウトの拡張で解決してください。

---

## 実装資産について

本リポジトリには判断ルールと契約を置き、実際のUIコンポーネントやレイアウト実装コードは置きません。
共通実装が指定されている場合は、そのShared UI / package / repositoryを優先して利用してください。

具体的なサードパーティUIライブラリの推奨はShared UI側のRecommendationを参照し、Standards側でライブラリ一覧を増やさないでください。
