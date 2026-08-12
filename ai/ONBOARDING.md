# AI エージェント オンボーディング

> 本リポジトリは、開発における「判断のブレ」を減らすための Development Standards です。
> AI エージェントがプロジェクトに参加するとき、**最初にこのファイルのみを読みます**。

---

## 必守事項

1. **既存Standardを確認してから新しい判断を行うこと。**
2. **既存の再利用可能な実装がある場合は再実装しないこと。**
3. 最初からすべてのドキュメントを読まないこと。**タスクに必要なCore Standardだけを読み、Optional Standardは該当機能を扱う場合のみ読むこと。**
4. Standardから重要な逸脱をする場合は、プロジェクト側で理由（ADR等）を残すこと。軽微な例外にADRは不要。
5. 新しいStandardを追加する前に、Core / Optional / Recommendation / 共通実装 / プロジェクト固有判断のどれに属するかを判断すること。

---

## 参照先

### 1. 開発フロー・ガバナンス・Git運用
👉 [Governance & Rules](../standards/governance/)

### 2. バックエンド・インフラ・認証・API・ログ
👉 [Architecture Standard](../standards/architecture/)

Architecture配下の `optional/` は、監視APIなど該当機能を実装・変更する場合のみ参照してください。

### 3. フロントエンド・画面構造・操作の一貫性
👉 [Application UI Standard](../standards/application-ui/)

Application UI配下にOptional Standardがある場合も、該当機能を扱う場合のみ参照してください。

---

## Standardを増やす前の判断

以下のいずれにも該当しない場合、Standard化しないでください。

- 複数プロジェクトで同じ判断を繰り返している
- 統一しないことによる実害がある
- AIへ同じ説明を繰り返している
- 長期間変わりにくい判断である

特定ライブラリの候補はRecommendation、実装コードはShared UI等、単一案件固有の内容はプロジェクト側に置きます。
詳細は [ADR-0004](../decisions/adr-0004-core-and-optional-standards.md) を参照してください。

---

## 実装について

本リポジトリにはルールと契約を記載し、実際のUIコンポーネントやプロジェクト雛形の実装コードは含めません。
実装が別リポジトリや共通パッケージとして提供されている場合は、そちらを参照してください。
