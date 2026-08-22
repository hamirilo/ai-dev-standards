# Application UI Standard

本ドキュメントは、複数アプリで操作感を揃えるための **Core Application UI Standard** です。
見た目の細部ではなく、全体で繰り返し使うUI判断だけを定義します。

---

## 1. UIの基本原則

- **基本UI**: Reactの基本UIコンポーネントは、原則として `shadcn/ui` を基礎にする。プロジェクトが `application-ui-kit` 等の採用済みUI実装を利用している場合は、その実装を優先し、同じPrimitiveを再実装しない。
- **独自ラッパー**: 採用済みUI実装や `shadcn/ui` を包む独自ラッパーは、複数箇所で共通の見た目・振る舞い・ポリシーを維持する必要がある場合に限って作る。Propsを素通しするだけのラッパーは作らない。
- **Primary Action**: 画面の主操作は、原則としてPage Header付近の分かりやすい位置（通常は右側）に置く。
- **通知**: `alert()` を通常の通知に使わず、保存成功などの補助的なフィードバックにはToastを使う。
- **破壊的操作**: `confirm()` に依存せず、重要な削除等はConfirm Dialog等で意図を確認する。
- **Empty State**: データがない場合は状態を明示し、有効な次の操作がある場合のみ提示する。
- **基本操作性**: キーボード操作やフォーカス表示など、利用しているUI Componentのアクセシビリティ上の振る舞いを不用意に壊さない。
- **先行抽象化を避ける**: UI Kitを導入すること自体を目的にせず、実際の繰り返しが確認されるまで不要なラッパーや共通化を増やさない。採用済みのUI Kitがある場合は再実装せず利用する。

---

## 2. Semantic Tokens

意味を持つ色・状態表現は、具体的な色ではなくSemantic Tokenで指定する。

- `primary`, `secondary`, `muted`, `accent`, `destructive`, `background`, `foreground`, `border`, `input`, `ring` など、`shadcn/ui` のToken体系を基本とする。
- Tokenは「何色か」ではなく「何のための表現か」で選ぶ。
- `blue-600` や `red-500` のような固定色を、主要操作・状態表現の意味として直接使わない。
- Themeの具体的な色値は各アプリ側で管理し、Standardでは固定しない。
- 既存Tokenで表現できる場合は、新しいTokenを増やさない。

Themeを定義・変更する場合の詳細は [Theme Customization](optional/theme-customization.md) を参照する。

---

## 3. 初期描画の安定性

- 初期描画時のFOUC、FOIT、FOUTおよび予期しないレイアウトシフトを抑える。
- ページシェル、ナビゲーション、主要コンテンツなど、初期表示に必要な領域は描画前に確保する。
- 画像、SVG、動画、埋め込み要素には、固有サイズ、`aspect-ratio` またはコンテナサイズを指定する。
- Webフォントを使用する場合は、読み込み中・失敗時にもテキストの可読性と操作性を維持し、フォント切り替えによる大きなレイアウトシフトを避ける。
- 通常のスタイルはビルド済みCSSで管理する。外部CSSだけでは初期レイアウトを安定させられない場合に限り、ページシェルや主要領域の初期サイズを定義する最小限のCritical CSSを `base.html` の `<head>` に記述できる。これは個別コンポーネントのデザイン調整には使用しない。

---

## 4. エラーとフィードバック

| 種類 | 基本表現 |
|---|---|
| 入力項目のエラー | Field Error |
| フォーム全体・業務ルールのエラー | Form Error / Alert |
| 操作・非同期処理の一時的失敗 | Toast |
| ページ・機能自体を利用できない | Error State / Error Page |

入力エラーをToastだけで伝えず、内部例外やstack traceをそのままユーザーへ表示しない。

---

## 5. フォーム / バリデーションUX

- 早く検出できる入力不備は、可能な範囲でクライアント側でも知らせる。
- 正当性の最終判断は必ずサーバー側で行う。
- Field Errorは対象フィールドの近くに表示する。
- フォーム全体の業務エラーは分かりやすい位置に表示する。
- 送信失敗時に入力内容を不用意に失わない。
- 保存中は必要に応じて二重送信を防止する。

見た目の細部はCore Standardで固定しない。

---

## 6. Domain Components

社員・組織・拠点など、特定の業務ドメインに意味を持つUIは、そのドメインを所有するプロジェクトで管理する。共通UIライブラリ側には置かない。

例:

- 社員選択: `UserPicker` / `EmployeeSearch`
- 組織・部署選択: `DepartmentPicker` / `OrganizationTree`

`DatePicker`, `DataTable`, `Dialog`, `Toast` などの汎用UIはDomain Componentとして扱わない。まず `shadcn/ui`、採用済みのApplication UI Kit、またはプロジェクト内の既存実装を利用する。

動画、画像ギャラリー、チャート、地図など `shadcn/ui` で解決しない領域のライブラリ選定は [Recommendations](../../recommendations/frontend.md) を参照する。

### 他プロジェクトからの利用

他のアプリが同じドメインの情報を必要とする場合は、所有プロジェクトが公開する連携境界を利用する。連携方式は、リアルタイム性・データ量・可用性に応じてAPI、定期同期、バッチ等から選ぶ。

Domain Componentを、データ取得・認証・CSRF・エンドポイント設定を内包するUIパッケージとして共有しない。こうした都合を利用側へ持ち込むと結合が強くなる。

同じUIが複数プロジェクトで実際に繰り返された場合は、データ連携と表示・操作を分離できることを確認した上で、共有の是非を検討する（[ADR-0003](../../decisions/adr-0003-core-and-optional-standards.md)）。1つ目の利用者しか存在しない段階では分離しない。

---

## 7. Layout Profiles

新規画面・アプリは、原則として **Standard App / Simple App / Focus App** のいずれかを起点にする。これらは実装コードをコピーするTemplateではなく、ナビゲーションや主要操作位置を揃えるためのLayout Profileとして扱う。実装テンプレートやStarterは別の資産として管理する。

### Standard App

一般的な業務システム、管理画面、マスタ管理向け。

- Global Headerを上部に配置する。
- Header左側にアプリ / ブランド、右側にUser Menuを配置する。
- アプリ内の主要ナビゲーションは左Sidebarに配置する。
- Main Content上部にPage Headerを配置する。
- Primary Actionは原則としてPage Header領域に配置する。

### Simple App

単機能ツール、小規模ユーティリティ、簡易申請向け。

- Sidebarを持たない。
- Headerを上部に配置し、左側にアプリ名、右側にUser Menuを配置する。
- Main Contentを中心に構成する。
- 必要な場合はMain Content上部に一貫したPage Headerを置く。

### Focus / Tool App

座席表、エディタ、キャンバス型ツール等、広い作業領域が重要なアプリ向け。

- Minimal Headerを上部に配置する。
- 残りをMain Workspaceとして広く利用する。
- 主要操作はHeaderまたは一貫したToolbarに集約する。
- ユーザー関連操作の位置をアプリごとに無秩序に変更しない。

### 固定するもの / 拡張してよいもの

強く揃えるもの:

- Headerの基本位置
- User Menuの位置
- Standard AppにおけるSidebarの役割と位置
- Page Headerの役割
- Primary Actionの基本的な配置領域

アプリ要件に応じて変更できるもの:

- Content幅、Grid / Card構成
- Filter Bar、Tabs、Toolbar
- 補助Panel / Inspector
- Dashboard Widgetや情報密度

既存3レイアウトで足りない場合も、まず最も近いレイアウトを拡張する。それでも適合しない明確なUX上の理由がある場合だけプロジェクト固有Layoutを作り、同じ派生が複数プロジェクトで繰り返された場合にStandardへの昇格を検討する。

---

## 8. デザイン参照と実装資産の境界

本Standardは、UIの判断原則・利用場面・操作の一貫性を定義します。次の資産は本リポジトリへ移しません。

- Claude Designや人間向けの設計参照: 採用済みApplication UI Kitのdesign-system/
- 再利用可能な実装: Application UI KitのUI package
- 使用例・状態確認・視覚検証: Application UI KitのStorybook
- 社員検索や組織ツリーなどの業務ドメインUI: 各アプリまたはドメイン所有側

UI Kitの全コンポーネント仕様や実装手順をStandardへ重複して記載しないでください。Standardから参照が必要な場合も、該当するタスクでのみUI Kitを追加で読みます。

## Optional Standards

該当する作業を行う場合のみ参照する。

- [Theme Customization](optional/theme-customization.md) — Themeの具体値やToken追加を扱う場合
- [AI Screen Design](optional/ai-screen-design.md) — Claude Design等へ画面デザインを依頼する場合
