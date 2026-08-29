# AI エージェント オンボーディング

> 本リポジトリは、開発における「判断のブレ」を減らすための Development Standards です。
> AI エージェント（Claude / Codex / Gemini 等）がプロジェクトに参加するとき、**最初にこのファイルのみを読みます**。
> 各プロジェクトへは、そのプロジェクトの `CLAUDE.md` 等に本ファイルへのパスを記載して参照させます（submodule等では配布しません）。

---

## 必守事項

1. **既存Standardを確認してから新しい判断を行うこと。**
2. **既存Component / 採用済みのShared UI実装がある場合は再実装しないこと。**
3. 最初からすべてのドキュメントを読まないこと。**タスクに必要なCore Standardだけを読み、Optional Standardは該当機能を扱う場合のみ読むこと。**
4. Standardから重要な逸脱をする場合は、プロジェクト側で理由（ADR等）を残すこと。
5. 新しいStandardやレイアウト・共通実装を「将来使うかもしれない」という理由だけで増やさないこと。**有用なベストプラクティスであることだけでも追加理由にはならない。既存ルールへの統合、Standard外への配置、追加しない判断を先に検討すること。**
6. **新しいライブラリ・パッケージを追加する前に [Recommendations](../recommendations/) を確認すること。** 未収録のものを導入する場合は、健全性チェックの結果を短く提示してから追加すること。
7. **実装に入る前に、対象プロジェクトの `decisions/project-context.md` があれば読むこと。** 対象ユーザー、認証の要否、主対象デバイス、認可の粒度といった前提を勝手に仮定しないこと。存在しない場合でも無関係な小規模修正は止めず、前提がタスクの設計を実質的に左右する場合だけ確認すること。その他のプロジェクト側ADRは、関連するタスクを扱う場合のみ読むこと。
8. **詳細な実装手順や検証方法をStandardへ追加しないこと。** 必要な場合はai-dev-playbookを参照し、再利用可能なUI設計・実装はapplication-ui-kitを参照すること。どちらも該当タスクのときだけ読むこと。
9. **対象プロジェクトで定義されている型チェック、Linter、Build、基本テストを通過させること。** これらは該当する場合、PR・マージ・リリースの必須ゲートです。
10. **Standard適合レビューをプロジェクト全体の改善監査へ拡張しないこと。** 既存実装が現在のStandardと異なるだけなら原則として一括移行を要求せず、新規・変更箇所から寄せる。品質向上、近代化、追加機能はStandard適合作業と分離すること。

---

## 参照先（ルーター）

### 1. 開発フロー・ガバナンス・Git運用
AIと人間の行動規範、モデル選定、レビュー方針、Standard追加時の判断について:

👉 [Governance & Rules](../standards/governance/)

リポジトリの立ち上げや、既存リポジトリのStandard適合を行う場合のみ、Governanceから `standards/governance/optional/project-setup.md` へ進むこと。

### 2. バックエンド・技術構成・認証・ログ・API
Django構成、Reactの責務、OIDC、認可、Security、Logging、Testing、API利用基準など:

👉 [Architecture Standard](../standards/architecture/)

React IslandsやTypeScript実装、型エラー、API境界の型安全を扱う場合は [TypeScript / 型安全 Standard](../standards/architecture/typescript.md) も読むこと。

Docker Composeの `ports:`、サービス間接続、ホスト/LANへの公開境界を扱う場合は [Docker Compose ネットワークとポート公開](../standards/architecture/optional/container-network.md) も読むこと。

特定機能にOptional Standardがある場合のみ、Architecture Standardから該当ファイルへ進むこと。
例: 共通ダッシュボード向けのStatus APIを実装・利用する場合は `standards/architecture/optional/status-api.md` を読む。

### 3. フロントエンド・画面構造・操作の一貫性
レイアウト、通知、エラー表示、フォームUX、`shadcn/ui`、Semantic Tokenについて:

👉 [Application UI Standard](../standards/application-ui/)

詳細なTheme設定やAIによる画面デザインなど、該当するOptional Standardがある場合のみApplication UI Standardから参照すること。

### 4. ライブラリ選定（Standardではない）
動画、画像、チャート、地図、アイコン等、`shadcn/ui` で解決しない領域の既定、信頼境界の実行時検証、非推奨ライブラリについて:

👉 [Recommendations](../recommendations/)

依存を追加・変更する場合のみ読むこと。Standardと異なり拘束力は弱く、逸脱にADRを求めない。

---

### 5. 詳細手順・UI資産（必要時のみ）

詳細な実装手順、検証方法、失敗例、新規アプリの開始点は、Standardへ追加せずai-dev-playbookで管理します。

UIを実装するプロジェクトがapplication-ui-kitを採用している場合は、次を必要に応じて参照します。

- design-system/: Claude Designや人間向けの設計参照
- UI package: 再利用可能な実装
- Storybook: 使用例・状態確認・視覚検証

業務ドメイン固有のUIは、引き続き各アプリまたはドメイン所有側で管理します。

## 必須基準と品質推奨

### 必須基準

対象プロジェクトで定義されている型チェック（TypeScriptでは `tsc --noEmit` 等）、Linter、Build、基本テストは、該当する場合にPR・マージ・リリースの必須ゲートとします。CIで自動検証し、エラーを解消してから先へ進みます。

### 品質推奨

性能、アクセシビリティ、実ブラウザでの操作性を高める確認は [Quality Recommendations](../recommendations/quality.md) を参照してください。Lighthouse、Core Web Vitals、N+1クエリ対策、高度なパフォーマンス最適化はSoft Targetであり、通常はリリースブロッカーにしません。

AIエージェントは品質推奨を常時適用せず、ユーザーから明示的な指示がある場合、または大規模なUI・パフォーマンス変更を行う場合に参照・適用します。実施手順は [ai-dev-playbook](https://github.com/hamirilo/ai-dev-playbook) から、該当する手順を必要なときだけ参照します。

## 既存プロジェクトをレビューするとき

Standardは原則として今後の判断、新規実装、変更箇所へ適用します。既存コードとの差分をすべて修正することを「適合」とみなしません。

レビュー結果は次の3種類に分けます。

1. **Required**: セキュリティ、データ整合性、必須CIゲート等に関わり、現在の問題として修正が必要。
2. **Adopt going forward**: 既存方式は直ちに移行せず、新規・変更箇所からStandardへ寄せる。
3. **Optional improvement**: 品質向上、近代化、追加機能等。Standard適合とは分離し、必要なら通常のBacklogとして扱う。

Optional Standardの発動条件に該当することは、その機能を新たに実装する義務を意味しません。例えばStatus APIのStandardが存在していても、Standardレビューだけを理由にStatus API機能を追加しません。

## Standardを増やそうとしたとき

追加基準と配置先（Core / Optional / Recommendation / Shared implementation / Project側）の判断は、[ADR-0003: StandardsをCoreとOptionalに分離する](../decisions/adr-0003-core-and-optional-standards.md) を正として従ってください。
繰り返しが確認されていないものを先回りしてStandard化しません。

新しい項目を提案する前に、**「追加しない場合に現在どのような繰り返しや実害があるか」**を確認してください。説明できない場合はStandardへ追加しません。

---

## 実装資産について

本リポジトリは「判断の再利用」を扱い、実装コードは含みません。詳細手順・Starter・UI実装は、タスクに応じてそれぞれの外部資産を参照します。
実装資産の境界は [README「Standard以外の配置先」](../README.md#standard以外の配置先) と [ADR-0004](../decisions/adr-0004-shared-asset-boundaries.md) を参照してください。 共有資産のリポジトリをフォークして使っている場合は、フォークへ組織固有の差分を足さないでください（[ADR-0005](../decisions/adr-0005-upstream-fork-operation.md)）。
