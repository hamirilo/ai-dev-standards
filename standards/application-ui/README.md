# Application UI Standard

本ドキュメントは、複数Applicationで操作感を揃えるための **Core Application UI Standard** です。
見た目の細部やComponent仕様ではなく、繰り返し使うUI判断と制約だけを定義します。

UIの具体的なFoundations、Components、Patterns、Templates、Storybook Catalogは [ui-platform](https://github.com/hamirilo/ui-platform) を正とします。

---

## 1. UIの基本原則

- **基本UI**: React UIは原則として `shadcn/ui` を基礎にする。対象Applicationが `application-ui-kit` を採用している場合は、その既存Componentを優先し、同じPrimitiveを再実装しない。
- **Template側の部品**: Django Templateで描くbutton、alert、tab、pagination等も、`application-ui-kit` を採用している場合はUI Platformが配布するtemplate用classと汎用Islandを優先し、同じ部品を独自CSS / 独自JavaScriptで再実装しない。
- **独自ラッパー**: 既存UIを包むwrapperは、共通の見た目・振る舞い・policyを追加する明確なvalueがある場合だけ作る。Propsを素通しするだけのwrapperは作らない。
- **Primary Action**: 画面の主操作はPage Header付近の分かりやすい位置を基本とする。
- **通知**: 通常のfeedbackに `alert()` を使わず、保存成功等の補助的なfeedbackにはToastを使う。
- **破壊的操作**: 重要な削除等は `confirm()` に依存せず、Confirm Dialog等で意図を確認する。
- **Empty State**: データがない状態を明示し、有効な次の操作がある場合のみ提示する。
- **基本操作性**: keyboard操作、focus表示等、利用しているUI Componentのaccessibility上の振る舞いを壊さない。
- **先行抽象化を避ける**: 実際の繰り返しが確認されるまで不要なwrapperや共通Componentを増やさない。

---

## 2. Semantic Tokens

意味を持つ色・状態表現は、具体色ではなくSemantic Tokenで指定します。

- `primary`, `secondary`, `muted`, `accent`, `destructive`, `background`, `foreground`, `border`, `input`, `ring` 等、`shadcn/ui` のToken体系を基本とする。
- Tokenは「何色か」ではなく「何のための表現か」で選ぶ。
- `blue-600` や `red-500` のようなraw colorを、主要操作・状態表現の意味として直接使わない。
- Themeの具体値はStandardで固定せず、UI Platformまたは利用側Applicationのtheme設定で管理する。
- 既存Tokenで表現できる場合は新しいTokenを増やさない。

具体的なToken値、Theme実装、Componentへの適用方法はUI Platformを参照してください。

---

## 3. 初期描画の安定性

- 初期描画時のFOUC、FOIT、FOUT、予期しないlayout shiftを抑える。
- Page shell、navigation、主要content等、初期表示に必要な領域は描画前に確保する。
- 画像、SVG、動画、埋め込み要素には固有size、`aspect-ratio`、またはcontainer sizeを指定する。
- Web font利用時も読み込み中・失敗時の可読性と操作性を維持する。
- Critical CSSは初期layoutを安定させる最小限の用途に限定し、個別Componentのdesign調整には使わない。

具体的な実装・検証方法はPlaybookで扱います。

---

## 4. エラーとフィードバック

| 種類 | 基本表現 |
|---|---|
| 入力項目のerror | Field Error |
| Form全体・業務ruleのerror | Form Error / Alert |
| 継続して伝える注意・案内（未完了の設定、権限による制限、メンテナンス予告等） | Alert / Banner |
| 操作・非同期処理の一時的失敗 | Toast |
| Page・機能自体を利用できない | Error State / Error Page |

入力errorをToastだけで伝えず、内部例外やstack traceをそのまま利用者へ表示しません。Toastは一時的なfeedback、Alert / Bannerは利用者が対処または確認するまでpage上に残す表現として使い分けます。

---

## 5. Form / Validation UX

- 早く検出できる入力不備は可能な範囲でclient側でも知らせる。
- 正当性の最終判断はserver側で行う。
- Field Errorは対象fieldの近くに表示する。
- Form全体の業務errorは分かりやすい位置に表示する。
- 送信失敗時に入力内容を不用意に失わない。
- 保存中は必要に応じて二重送信を防止する。

見た目の細部とComponent APIはStandardで固定しません。

---

## 6. Domain Components

社員・組織・拠点等、特定の業務domainに意味を持つUIは、そのdomainを所有するprojectで管理します。UI Platformへは置きません。

例:

- 社員選択: `UserPicker` / `EmployeeSearch`
- 組織・部署選択: `DepartmentPicker` / `OrganizationTree`

`DatePicker`, `DataTable`, `Dialog`, `Toast` 等の汎用UIはDomain Componentとして扱いません。まず採用済みUI実装または `shadcn/ui` を利用します。

動画、画像gallery、chart、map等、`shadcn/ui` で解決しない領域のlibrary選定は [Recommendations / Frontend](https://github.com/hamirilo/ai-dev-platform/blob/main/recommendations/frontend.md) を参照してください。

他Applicationが同じdomain情報を必要とする場合は、所有projectが公開する連携境界を利用します。Domain Componentへ認証・CSRF・endpoint等のdomain連携を焼き込んで汎用UI packageとして共有しません。

---

## 7. Layout Profiles

新規画面・Applicationは、原則として **Standard App / Simple App / Focus App** のいずれかを起点にします。これらは実装codeをcopyするTemplateではなく、navigationや主要操作位置を揃えるためのLayout Profileです。

### Standard App

一般的な業務system、管理画面、master管理向け。

- Global Headerを上部に配置する。
- Header左側にApplication / brand、右側にUser Menuを配置する。
- 主要navigationは左Sidebarに配置する。
- Main Content上部にPage Headerを配置する。
- Primary ActionはPage Header領域を基本とする。

### Simple App

単機能tool、小規模utility、簡易申請向け。

- Sidebarを持たない。
- Header左側にApplication名、右側にUser Menuを配置する。
- Main Contentを中心に構成する。

### Focus App

座席表、editor、canvas型tool等、広い作業領域が重要なApplication向け。

- Minimal Headerを上部に配置する。
- 残りをMain Workspaceとして広く利用する。
- 主要操作はHeaderまたは一貫したToolbarへ集約する。

既存Profileで足りない場合は最も近いものを拡張し、同じ派生が複数projectで繰り返された場合にStandardへの昇格を検討します。

具体的な画面例・TemplateはUI Platformを参照してください。

---

## 8. UI Platformとの境界

本Standardは **守るUI判断・制約** を定義します。次は [ui-platform](https://github.com/hamirilo/ui-platform) が所有します。

- **Foundations**: Tokenの具体値、Typography、Spacing等
- **Components**: 再利用可能なUI実装。Applicationから利用するpackage名は `application-ui-kit`
- **Template classes**: Django Templateから使う共通class（`.btn-*`、`.alert`、`.tabs` 等）。対応するReact Componentと見た目を揃える責務を含む
- **Patterns**: UX課題に対する設計候補と選択条件
- **Templates**: 画面レベルの構成例
- **Catalog / Storybook**: 実際の見た目・状態・操作の確認
- **Design reference**: Claude Design等へ渡す自己完結した設計参照

Component仕様、Props一覧、実装code、Storybook内容をStandardへ複製しません。

`application-ui-kit` を採用しているApplicationでは、Template classesと汎用Islandで表現できる部品をApplication側の独自CSS / JavaScriptで再実装しません（採用していないApplicationには§1の採用条件がそのまま当てはまり、この項目を理由にUI Kitを追加しません）。Applicationのbrand差分はTokenの上書きで表現します。既存実装の置き換えは変更箇所から順に行い、一括migrationを要求しません（[ADR-0007](../../decisions/adr-0007-presentation-only-islands-and-template-classes.md)）。

## Optional Standards

該当する作業を行う場合のみ参照します。

- [一覧画面](optional/list-screens.md) — 並び替え、絞り込み、pagination、行選択等の対話的な一覧／検索画面を実装する場合
