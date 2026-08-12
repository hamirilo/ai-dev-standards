# Architecture Standard

本ドキュメントは、対象プロジェクトの大半に適用する **Core Architecture Standard** です。
特定機能だけに必要な詳細仕様は `optional/` 配下に分離し、該当機能を扱う場合のみ参照します。

---

## 1. 基本技術スタック

- **Backend**: Django
- **Database**: PostgreSQL
- **Internal Authentication**: OIDC + Django Session
- **Personal Authentication**: 固定しない
- **API**: 必要な場合のみ Django Ninja
- **Frontend Base**: Django Templates (SSR)
- **Interactive UI**: React Islands
- **Full SPA**: 明確な必要性がある場合のみ検討

社内システムではOIDCを認証の標準とし、ログイン後はDjango Session Cookieを利用します。JWT等をReact側で独自保持する構成を標準にはしません。

---

## 2. フロントエンドとバックエンドの境界

- Django Templatesがルーティング、ページシェル、SSR、Django Form、権限適用を担う。
- **インタラクティブUIの標準手段はReact Islands** とする。Dialog、DatePicker、Select、Toast、TableなどのUI状態を持つ要素はReactを優先する。
- htmxはサーバー起点の部分HTML更新に限定する。検索結果、ページネーション等のHTML差し替えや、サーバーイベント通知などに利用する。
- ページ全体のReact化やReact Router等によるルーティングは標準にしない。
- Django Formで完結する処理のためだけにJSON APIを作らない。

詳細な判断背景は [ADR-0002](../../decisions/adr-0002-frontend-technology-boundary.md) を参照してください。

---

## 3. Django アーキテクチャ

モデルは太く、ビューは薄く保つことを基本とし、必要性のないRepository / UseCase等の抽象レイヤーを増やしません。

| 処理内容 | 基本的な記述場所 |
|---|---|
| 不変条件・状態遷移 | `models.py` |
| 再利用するクエリ | QuerySet / Manager |
| 表示用プロパティ | Model property |
| 入力検証 | `forms.py` |
| 権限判定 | 専用permission module |
| 画面遷移・レンダリング | `views.py` |

`services.py` は、複数モデル横断、外部API通信、明確なトランザクション境界など、モデル単体に置くと責務が不自然になる場合に利用します。

---

## 4. 認可

- 業務機能の認可に `is_staff` / `is_superuser` を流用しない。
- 業務権限は `can_manage_xxx(user)` 等の専用認可層へ集約する。
- Django Adminアクセスなど、Django本来の意味で `is_staff` / `is_superuser` を利用することは許容する。
- 認可データモデル自体（RBAC/ABAC、部署権限等）はプロジェクト要件に応じて設計する。

---

## 5. Security Baseline

- DjangoのCSRF保護を無効化して問題を回避しない。React Islandsから状態変更する場合もCSRFトークンを正しく送信する。
- Django TemplateからReactへデータを渡す場合は、安全なシリアライズ手段を利用し、文字列連結でJSONを埋め込まない。
- Secret、Token、Password、DB認証情報等はGit管理せず、コードと分離する。
- 外部HTTP通信にはtimeoutを設定し、失敗を握り潰さない。
- HTTPS利用時は証明書検証を無効化しない。既存社内環境でHTTPが必要な場合は許容するが、機密情報を平文で送る必要性は個別に評価する。
- リソースの存在自体を秘匿する必要がある場合は404、存在を隠す必要がなく単なる権限不足であれば403を基本とする。

### 監査ログ

社内システムでは、重要な操作や権限変更について監査可能な記録を残します。すべてのCRUDを無条件に監査対象とはしません。
認証失敗、権限変更、破壊的操作、一括処理、機密データ変更、管理者操作などを優先します。

---

## 6. Logging

本番環境では **構造化ログを原則必須** とします。

共通して扱う基本フィールド:

- `timestamp`
- `level`
- `message`
- `service`
- `environment`
- `logger`
- `request_id`（HTTPリクエストでは原則必須）
- `user_id`（必要な場合のみ）
- `action`（業務イベントとして意味がある場合）

運用原則:

- `DEBUG`: 開発・詳細調査、`INFO`: 正常な重要イベント、`WARNING`: 継続可能な異常、`ERROR`: 処理失敗、`CRITICAL`: サービス継続に重大な影響、という意味を基本とする。
- 検索・集計したい値はmessage文字列だけに埋め込まず、構造化フィールドとして持つ。
- 想定外例外ではstack traceを残す。
- Secret / Token / Passwordをログへ出さない。個人情報も必要最小限とする。
- 本番ログ用途に `print()` を使わない。

ログ集約製品、保持期間、具体的なloggingライブラリ、request ID生成方式まではStandardで固定しません。

---

## 7. Testing / Error Handling

### Testing

網羅率そのものを目的にせず、壊れると影響が大きい振る舞いを優先します。

- ビジネスルール
- 権限
- 状態遷移
- DB制約・重要な入力制約
- 重要な失敗ケース
- 外部連携などの境界

フレームワーク自身の挙動や単純なテンプレート描画を重複して細かくテストすることは求めません。

### Error Handling

- 例外を握り潰さない。
- ユーザー向けメッセージと内部エラー詳細を分離する。
- 想定可能な業務エラーは明示的に扱う。
- 想定外例外は障害調査に必要なコンテキストとともにログへ残す。
- `except Exception: pass` のような処理を行わない。
- 外部サービス障害では、必要に応じて再試行可能性をユーザーへ伝えられるようにする。

UI上のエラー表現は [Application UI Standard](../application-ui/) に従います。

---

## 8. API / システム間連携

- Django Template / Formで完結するならAPIを作らない。
- React Islandsを使うこと自体をAPI作成理由にしない。
- 外部システム連携や、JSON境界が明確に適する複雑な非同期データ取得ではDjango Ninjaを利用できる。
- アプリ間連携はAPI一択にしない。リアルタイム性や疎結合が必要ならAPI、定期同期や大量データ連携ならバッチ・ファイル等も含め用途に応じて選択する。

特定の機械連携で共通契約が必要な場合はOptional Standardとして仕様を定義します。

---

## 9. 非同期・定期処理

非同期・定期処理は、必要なアプリだけ導入します。通常のCRUDや短時間で完了する処理を、理由なく非同期化しません。

次のような処理では非同期化を検討します。

- ユーザー応答を待たせる必要がない処理
- 処理時間が長い、または応答時間が安定しない処理
- 外部I/O、大量データ処理、メール送信、ファイル変換
- 定期同期・集計・メンテナンス
- 失敗時に再試行したい処理

非同期処理を導入した場合は、失敗のログ記録、再実行の考慮、可能な範囲での冪等性、必要に応じた処理状態の可視化を行います。

---

## Optional Standards

特定機能を扱う場合のみ参照します。

- [Status API / Monitoring Contract](optional/status-api.md) — 共通ダッシュボード等からサービス状態を取得する場合
