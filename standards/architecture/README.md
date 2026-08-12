# Architecture Standard

本ドキュメントは、「システムをどう作るか」というプロジェクト横断での技術選定およびアーキテクチャの基準を定義します。
自由度よりも、複数リポジトリ間での一貫性と生産性（AIによる推論しやすさ）を優先します。

---

## 1. 基本技術スタック (Opinionated Stack)

本スタンダードでは、以下の技術スタックを強く推奨（デフォルト）とします。

* **Backend**: Django
* **Database**: PostgreSQL
* **Authentication**: OIDC (OpenID Connect) を基本
* **API**: 必要な場合のみ Django Ninja
* **Frontend Base**: Django Templates (SSR)
* **Interactive UI**: React Islands
* **CSS / Styling**: 共通UI方針（別途指定するUIコンポーネントライブラリ）に従う
* **Full SPA**: 明確な必要性がある場合のみ検討（原則非推奨）

---

## 2. フロントエンドとバックエンドの境界 (SSRファースト)

* **基本は HTML を返す**: ビューは原則として HTML を返し、JSON API を安易に作成しない。
* **フォームの主導権**: フォームは Django Form を用いてサーバー側でバリデーションを行い、React専用のフォーム状態管理（JSON送信）は原則作らない。
* **React Islands の役割**: チャート、高度な日付選択、ドラッグ＆ドロップ、モーダルなど「リッチなインタラクションが必要なコンポーネント」のみをReact化する。ルーティングやページ全体のReact化は行わない。
* **htmx の役割**: サーバー起点の部分 HTML 更新（ページネーション、検索フィルター結果の差し替え等）に限定する。

---

## 3. Django アーキテクチャとファイル構成

モデルは太く、ビューは薄く保つことを基本とします。無闇に抽象レイヤー（RepositoryやUseCase等）を増やしません。

### 3.1. 責務の分割
| 処理内容 | 記述場所 |
|---|---|
| 不変条件・状態遷移 | `models.py` (`Meta.constraints`, `clean()`) |
| 再利用するクエリ | `models.py` (QuerySet メソッド) |
| 表示用プロパティ | `models.py` (`@property`) |
| 入力検証 | `forms.py` |
| 権限判定 | `apps/accounts/permissions.py` 等の専用モジュール |
| 画面遷移・レンダリング | `views.py` (FBVを基本とする) |

### 3.2. Serviceレイヤーの利用条件
ビジネスロジックは可能な限り `models.py` に収めますが、以下の場合は `services.py` を作成して処理を切り出します。
* 複数モデルを横断する処理
* 外部 API 通信
* 明示的なトランザクション境界が必要な処理

---

## 4. 権限（パーミッション）管理

* **直接参照の禁止**: ビューやテンプレート内で `request.user.is_staff` や `request.user.is_superuser` を直接参照して分岐してはならない。
* **権限判定の集約**: 専用のパーミッションモジュール（例: `can_manage_ideas(user)`）を作成し、必ずそこを経由して判定する。

---

## 5. API 利用基準 (Django Ninja)

* 基本的に画面描画は Django Template (SSR) + React Islands + htmx で完結させるため、内部向けの REST API は作成しない。
* 外部システムとの連携、あるいは React Islands からの非同期な複雑なデータフェッチ（グラフ描画用の時系列データ等）で「どうしても JSON API が最適な場合」にのみ、Django Ninja を利用してエンドポイントを生やす。
