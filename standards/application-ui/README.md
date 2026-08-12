# Application UI Standard

本ドキュメントは、複数アプリで操作感を揃えるための **Core Application UI Standard** です。
見た目の細部ではなく、「どのUIをどの場面で使うか」という判断を揃えます。実際のコンポーネントコードは別のShared UI等で管理します。

---

## 1. UIの基本原則

- **Primary Action**: 画面の主操作は、原則としてPage Header付近の分かりやすい位置（通常は右側）に置く。画面特性上より適切な配置がある場合は例外を許容する。
- **通知**: `alert()` を通常の通知に使わない。保存成功など、操作後の補助的なフィードバックにはToastを使う。
- **破壊的操作**: `confirm()` に依存せず、重要な削除等はConfirm Dialog等で意図を確認する。
- **Empty State**: データがない場合は空の表だけを出さず、状態を明示する。ユーザーが次に取れる有効な操作がある場合のみ、そのアクションも提示する。
- **再利用**: 共通UIやDomain Componentが存在する場合は、同じ用途のUIを各プロジェクトで再実装しない。

---

## 2. エラーとフィードバックの粒度

エラーの種類に応じて、表示場所と強さを揃えます。

| 種類 | 基本表現 | 例 |
|---|---|---|
| 入力項目のエラー | Field Error | 必須、形式、文字数 |
| フォーム全体・業務ルールのエラー | Form Error / Alert | 状態上この操作を実行できない |
| 操作・非同期処理の一時的失敗 | Toast | 保存失敗、アップロード失敗、通信失敗 |
| ページ・機能自体を利用できない | Error State / Error Page | 対象消失、重大な読込失敗 |

ユーザーが修正しなければならない入力エラーをToastだけで伝えません。
内部例外の詳細やstack traceをそのままユーザーへ表示しません。

---

## 3. フォーム / バリデーションUX

- 必須、形式、文字数など、早く検出できる入力不備は可能な範囲でクライアント側でも知らせる。
- 正当性の最終判断は必ずサーバー側で行う。
- Field Errorは対象フィールドの近くに表示する。
- フォーム全体の業務エラーはフォーム上部等の分かりやすい場所に表示する。
- 送信失敗時に入力内容を不用意に失わない。
- 保存中は必要に応じて二重送信を防止する。
- 保存成功などはToast等で補助的にフィードバックする。
- 必須記号の色や具体的な余白など、見た目の細部はCore Standardで固定しない。

---

## 4. 共通 Domain Components

複数アプリで繰り返すドメインUIや複雑なUIは、Shared UI等で提供されている共通実装を優先します。

代表例:

- 社員選択: `UserPicker` / `EmployeeSearch`
- 組織・部署選択: `DepartmentPicker` / `OrganizationTree`
- 日時選択: `DatePicker` / `DateRangePicker`
- データ一覧: `DataTable`

具体的なライブラリ選定や実装方式は、このStandardsリポジトリではなくShared UI側のRecommendation / 実装ドキュメントで管理します。

---

## 5. Layouts

新規画面ごとにナビゲーション構造をゼロから設計せず、目的に近い基本レイアウトを選びます。

### 5.1. Standard App

一般的な業務システム、管理画面、マスタ管理向け。

- Global Header: 左側にアプリ/ブランド、右側にUser Menu
- Sidebar: アプリ内の主要ナビゲーション
- Main Content: 主作業領域
- Page Header: 画面タイトルとPrimary Action

### 5.2. Simple App

単機能ツール、小規模ユーティリティ、簡易申請向け。

- Sidebarを持たない
- Headerにアプリ名とUser Menu
- Main Contentを中心に構成

### 5.3. Focus / Tool App

座席表、エディタ等、広い作業領域が重要なアプリ向け。

- Minimal Header
- 残りをMain Workspaceとして広く利用
- 必要な操作はヘッダーまたはツールバー等に集約

レイアウトの具体的なDjango Template / React実装はShared UI等で管理します。
