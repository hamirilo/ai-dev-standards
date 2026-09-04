# Architecture Standard

本ドキュメントは、対象プロジェクトの大半に適用する **Core Architecture Standard** です。
特定機能だけに必要な共通契約は `optional/` 配下に分離し、該当機能を扱う場合のみ参照します。

具体的な実装例、変更手順、移行、検証、トラブルシューティングは [ai-dev-playbook](https://github.com/hamirilo/ai-dev-playbook) の責務です。

---

## 1. 基本技術スタック

- **Backend**: Django
- **Database**: PostgreSQL
- **社内向け認証**: OIDC + Django Session
- **社外・一般ユーザー向け認証**: 固定しない
- **API**: 必要な場合のみ Django Ninja
- **Frontend Base**: Django Templates (SSR)
- **Interactive UI**: React Islands
- **Full SPA**: 明確な必要性がある場合のみ検討

社内システムではOIDCを認証の標準とし、ログイン後はDjango Session Cookieを利用します。JWT等をReact側で独自保持する構成を標準にはしません。

### 時刻・タイムゾーン

- `USE_TZ = True` とし、DBにはUTCで保存する。
- 表示タイムゾーンは `Asia/Tokyo` を基本とする。
- 「今日」など表示タイムゾーン基準のローカル日付は `timezone.localdate()` を使う。`timezone.now().date()` や `date.today()` は使わない。
- naive datetimeを作らない。
- 日付境界に関わる判定は境界時刻を含めて検証する。

機械的に検出できる誤用の既定は [Recommendations / Quality](https://github.com/hamirilo/ai-dev-platform/blob/main/recommendations/quality.md) を参照してください。

### 依存関係・ツールチェーン

- Pythonの環境・依存管理は **uv** で統一する。
- 依存はlockfileで固定し、Gitへcommitする。
- JS側は同一リポジトリ内でpackage managerやlockfileを混在させない。
- 新規プロジェクトのtoolchain既定は [Recommendations / Toolchain](https://github.com/hamirilo/ai-dev-platform/blob/main/recommendations/tooling.md) を参照する。

---

## 2. フロントエンドとバックエンドの境界

- Django Templatesがルーティング、ページシェル、SSR、Django Form、権限適用を担う。
- **インタラクティブUIの標準手段はReact Islands** とする。
- htmxはサーバー起点の部分HTML更新に限定する。
- サーバーが描画したHTMLの見せ方だけを切り替えるUI（tab切替、開閉、入力欄の出し分け等）は、`application-ui-kit` を採用しているApplicationではUI Platformが提供する汎用Islandで扱い、Django Formの描画をReactへ持ち上げない。
- ページ全体のReact化やReact Router等によるルーティングは標準にしない。
- Django Formで完結する処理のためだけにJSON APIを作らない。

詳細な判断背景は [ADR-0002](../../decisions/adr-0002-frontend-technology-boundary.md) と [ADR-0007](../../decisions/adr-0007-presentation-only-islands-and-template-classes.md) を参照してください。

---

## 3. Django アーキテクチャ

- DjangoのModel / QuerySet / Form / View等の標準的な責務を優先し、必要性のないRepository / UseCase等の抽象レイヤーを先に増やさない。
- どの入口から保存されても守るべき不変条件や状態遷移は、ModelまたはDB制約で守れる形にする。
- 業務認可は専用の認可層へ集約し、View、Template、APIへ同じ判定を分散させない。
- 複数Model横断、外部I/O、明確なtransaction境界等がある場合のみService等の追加レイヤーを検討する。

具体的な責務配置や実装例は [Django実装 Playbook](https://github.com/hamirilo/ai-dev-playbook/blob/main/playbooks/django-implementation.md) を参照してください。

---

## 4. 認可

- 業務機能の認可に `is_staff` / `is_superuser` を流用しない。
- Django Adminアクセスなど、Django本来の意味での利用は許容する。
- 業務権限は専用の認可層へ集約する。
- RBAC / ABAC、部署権限等のデータモデルはプロジェクト要件に応じて設計する。

---

## 5. Security Baseline

- DjangoのCSRF保護を無効化して問題を回避しない。React Islandsから状態変更する場合もCSRF保護を維持する。
- Django TemplateからReactへデータを渡す場合は安全なシリアライズ手段を利用する。
- Secret、Token、Password、DB認証情報等はGit管理せず、コードと分離する。
- 外部HTTP通信にはtimeoutを設定し、失敗を握り潰さない。
- HTTPS利用時は証明書検証を無効化しない。
- リソースの存在自体を秘匿する必要がある場合は404、単なる権限不足は403を基本とする。

### アップロードファイル

ユーザーがアップロードするファイルを扱う場合は、次を守ります。

- サイズ上限と許可する種類をサーバー側で検証する。拡張子・Content-Typeの自己申告だけを信頼しない。
- 元のファイル名を保存パスへそのまま使わない。
- アップロード済みファイルも認可対象のデータとして扱う。
- SVG・HTML等、ブラウザがコードとして実行しうる形式は原則許可しない。必要な場合も同一originでinline表示せず、`Content-Disposition: attachment` と `X-Content-Type-Options: nosniff` を設定して配信する。

配信方式、Storage、非同期アップロード構成はプロジェクト側で決めます。

### 監査ログ

社内システムでは、認証失敗、権限変更、破壊的操作、一括処理、機密データ変更、管理者操作等、後から説明が必要な重要操作を優先して監査可能な記録を残します。すべてのCRUDを無条件に監査対象とはしません。

---

## 6. Logging

本番環境では **構造化ログを原則必須** とします。

基本フィールド:

- `timestamp`
- `level`
- `message`
- `service`
- `environment`
- `logger`
- `request_id`（HTTP requestでは原則必須）
- `user_id`（必要な場合のみ）
- `action`（業務eventとして意味がある場合）

原則:

- 検索・集計したい値はmessage文字列だけに埋め込まず、構造化fieldとして持つ。
- 想定外例外ではstack traceを残す。
- Secret / Token / Passwordをログへ出さない。個人情報も必要最小限とする。
- 本番ログ用途に `print()` を使わない。

ログ集約製品、保持期間、具体的なlogging library、request ID生成方式まではStandardで固定しません。

---

## 7. Testing / Error Handling

### Testing

網羅率そのものを目的にせず、壊れると影響が大きい振る舞いを優先します。

- ビジネスルール
- 認証・認可
- 状態遷移
- DB制約・重要な入力制約
- 重要な失敗ケース
- 外部連携等の境界

型チェック、Linter、Build、対象プロジェクトの基本テストは、該当する場合に必須ゲートとして扱います。

### Error Handling

**失敗を隠して成功扱いにせず、エラー抑制より根本原因の解決を優先します。**

- エラーを消すことだけを目的に、例外の握り潰し、過剰なfallback、`|| true`、警告無効化、型チェック抑制等を追加しない。
- 例外を捕捉する場合は、その層で処理する明確な責務を持たせる。
- ユーザー向けmessageと内部error詳細を分離する。
- 想定外例外は調査に必要なcontextとstack traceをログへ残す。
- fallbackや継続処理を行う場合は、それが正常な仕様として説明できることを求める。

UI上のエラー表現は [Application UI Standard](../application-ui/) に従います。TypeScriptの型安全は [TypeScript Standard](typescript.md) を参照してください。

---

## 8. API / システム間連携

- Django Template / Formで完結するならAPIを作らない。
- React Islandsを使うこと自体をAPI作成理由にしない。
- 外部システム連携やJSON境界が明確に適する処理ではDjango Ninjaを利用できる。
- アプリ間連携はAPI一択にせず、リアルタイム性、データ量、結合度に応じてAPI、batch、file等を選ぶ。

### ドメインデータの所有

- 他システムが参照するmaster dataは、その正を持つprojectが所有する。
- 各app固有の業務dataをmaster所有projectへ集約しない。
- 他appがmaster情報を必要とする場合は、所有projectが公開する連携境界を利用する。

特定の機械連携で共通契約が必要な場合はOptional Standardとして仕様を定義します。

---

## 9. 非同期・定期処理

非同期・定期処理は、必要なApplicationだけ導入します。通常のCRUDや短時間で完了する処理を理由なく非同期化しません。

非同期処理を導入した場合は、失敗の記録、再実行、可能な範囲での冪等性、必要に応じた処理状態の可視化を考慮します。

---

## 10. コンテナと配布

コンテナで配布するApplicationでは、**CIで検証・作成したimageを配布し、staging / productionはその同一imageを取得して起動します。**

- CIでimageをbuildし、registryへ配布する。
- CIでimage build自体を検証する。
- build失敗や成果物の欠落を隠さない。
- 実行環境でbuildする必要がある場合は、その制約をproject ADRへ残す。
- host / LANへpublishするのは外部から直接必要なserviceだけとし、container間通信だけのserviceを理由なくpublishしない。
- Compose標準のnetworkで満たせる要件のために不要なnetwork構成を増やさない。

具体的な構成、移行、検証は次のPlaybookを参照してください。

- [コンテナ配布](https://github.com/hamirilo/ai-dev-playbook/blob/main/playbooks/container-delivery.md)
- [Docker Compose ポート公開](https://github.com/hamirilo/ai-dev-playbook/blob/main/playbooks/docker-compose-port-exposure.md)

---

## Optional Standards

特定機能を扱う場合のみ参照します。

- [Status API / Monitoring Contract](optional/status-api.md) — 共通dashboard等からservice状態を取得する場合
