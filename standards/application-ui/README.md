# Application UI Standard

本ドキュメントは、複数アプリで操作感を揃えるための **Core Application UI Standard** です。
見た目の細部や共通デザインそのものではなく、「どのUIをどの場面で使うか」「UIの意味をどのようにコードで表現するか」という判断を揃えます。

---

## 1. UIの基本原則

- **基本UI**: Reactの基本UIコンポーネントには、原則として `shadcn/ui` を使用する。既存コンポーネントで要件を満たせる場合は独自Primitiveを再実装しない。
- **Primary Action**: 画面の主操作は、原則としてPage Header付近の分かりやすい位置（通常は右側）に置く。画面特性上より適切な配置がある場合は例外を許容する。
- **通知**: `alert()` を通常の通知に使わない。保存成功など、操作後の補助的なフィードバックにはToastを使う。
- **破壊的操作**: `confirm()` に依存せず、重要な削除等はConfirm Dialog等で意図を確認する。
- **Empty State**: データがない場合は空の表だけを出さず、状態を明示する。ユーザーが次に取れる有効な操作がある場合のみ、そのアクションも提示する。
- **基本操作性**: 主要な操作がキーボードで完結でき、フォーカス位置が視認できる状態を損なわない。`shadcn/ui` 等が持つアクセシビリティ上の振る舞いを不用意な独自実装で壊さない。
- **再利用**: プロジェクト内またはドメイン側に既存の共有コンポーネントがある場合は、同じ用途のUIを再実装しない。
- **先行抽象化を避ける**: 共通UIライブラリや独自Design Systemを前提にしない。複数箇所で実際に繰り返されるまで、不要なラッパーや共通化を増やさない。

---

## 2. Semantic Tokens — 見た目ではなく意味を指定する

UIの色や状態表現は、具体的な色ではなく **意味（semantic role）** を基準に指定する。

本Standardでは共通の配色やブランドデザインを規定しない。各アプリは独自のThemeを持ってよいが、UI実装を具体的な色値から分離する。

### 2.1. 基本原則

- `primary`, `secondary`, `muted`, `accent`, `destructive`, `background`, `foreground`, `border`, `input`, `ring` など、`shadcn/ui` のSemantic Token体系を基本とする。
- Tokenは「何色か」ではなく「何のための表現か」で選択する。
- Tokenの具体的な値は各アプリ側のThemeで定義する。
- Standard側では `primary` を青にするなど、具体的な配色を固定しない。
- `shadcn/ui` ComponentがSemantic Tokenを適切に使用している場合は、画面側から固定色で上書きせず、その意味付けを維持する。
- Componentのvariantで意味を表現できる場合は、`className` による色指定よりvariantを優先する。

例えば、削除操作は「赤いボタン」として実装するのではなく、破壊的操作という意味を指定する。

```tsx
<Button variant="destructive">削除</Button>
```

主要操作についても、具体的な青色を指定するのではなく、Buttonのdefault variantが持つ意味を利用する。

```tsx
<Button>保存</Button>
```

### 2.2. Themeとの責務分離

Semantic TokenとThemeは別の責務として扱う。

```text
UI実装
  ↓
primary / destructive / muted
「何を意味するか」
  ↓
Theme
  ↓
oklch(...) 等
「実際に何色で表示するか」
```

各アプリでは、例えば以下のように具体値を定義してよい。

```css
:root {
  --primary: oklch(...);
  --primary-foreground: oklch(...);
  --destructive: oklch(...);
  --destructive-foreground: oklch(...);
}
```

異なるアプリで `primary` の実際の色が異なることは問題ではない。重要なのは、UIコードが `blue-600` や `red-500` といった具体色ではなく、`primary` や `destructive` という意味に依存していることである。

### 2.3. 固定色の直接指定

意味を持つUI状態・役割について、固定Tailwind Colorの直接指定は原則避ける。

避ける例:

```tsx
<Button className="bg-blue-600 text-white hover:bg-blue-700">保存</Button>
<div className="bg-red-500 text-white">削除できません</div>
```

Semantic Tokenを使用する例:

```tsx
<Button>保存</Button>
<div className="bg-destructive text-destructive-foreground">削除できません</div>
```

ただし、この原則はTailwind CSSによる直接スタイリング全般を禁止するものではない。以下のような画面固有の構造・レイアウトは通常どおり直接指定してよい。

- margin / padding / gap
- width / height / max-width
- flex / grid
- position
- responsive layout
- 画面固有の配置

```tsx
<div className="mt-6 flex max-w-4xl gap-4 px-6">
```

### 2.4. Tokenを増やす場合

`shadcn/ui` の既存Semantic Tokenで表現できる場合は、新しいTokenを追加しない。

新しいTokenは「この色を再利用したい」ではなく、「既存Tokenでは表現できない独立した意味が継続的に必要になった」場合のみ追加を検討する。

色や場所をそのまま名前にしたTokenは避ける。

```text
避ける: company-blue / light-blue / header-gray
検討可能: success / warning
```

`success` や `warning` についても、将来必要になるという理由だけで事前に標準化しない。

---

## 3. エラーとフィードバックの粒度

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

## 4. フォーム / バリデーションUX

- 必須、形式、文字数など、早く検出できる入力不備は可能な範囲でクライアント側でも知らせる。
- 正当性の最終判断は必ずサーバー側で行う。
- Field Errorは対象フィールドの近くに表示する。
- フォーム全体の業務エラーはフォーム上部等の分かりやすい場所に表示する。
- 送信失敗時に入力内容を不用意に失わない。
- 保存中は必要に応じて二重送信を防止する。
- 保存成功などはToast等で補助的にフィードバックする。
- 必須記号の色や具体的な余白など、見た目の細部はCore Standardで固定しない。

---

## 5. Domain Components

社員・組織・拠点など、特定の業務ドメインに意味を持つUIは、そのドメインを所有するプロジェクトで管理する。

代表例:

- 社員選択: `UserPicker` / `EmployeeSearch`
- 組織・部署選択: `DepartmentPicker` / `OrganizationTree`

これらは単なるUI Primitiveではなく、検索条件、識別子、表示形式、権限、API契約などのドメイン知識を含み得るため、汎用UI Standard側で実装を所有しない。

一方、`DatePicker`, `DataTable`, `Dialog`, `Toast` などの汎用UIはDomain Componentとして扱わない。まず `shadcn/ui` や既存ライブラリ、プロジェクト内の既存実装を利用し、独自の共通UIパッケージを先行して作らない。

---

## 6. Layouts — Template Standard

新規画面・アプリは、原則として以下の **Standard App / Simple App / Focus App** のいずれかをベースにします。
これらは単なる参考例ではなく、ナビゲーションや操作位置の一貫性を保つためのテンプレート標準です。

アプリ固有要件がある場合も、最初から独自レイアウトを設計せず、まず既存レイアウトの拡張で対応します。

### 6.1. Standard App

一般的な業務システム、管理画面、マスタ管理向け。

**主要骨格**:

- Global Headerを画面上部に配置する。
- Header左側にアプリ / ブランド、右側にUser Menuを配置する。
- アプリ内の主要ナビゲーションは左Sidebarに配置する。
- Main Content上部にPage Headerを配置する。
- Primary Actionは原則としてPage Header領域に配置する。

### 6.2. Simple App

単機能ツール、小規模ユーティリティ、簡易申請向け。

**主要骨格**:

- Sidebarを持たない。
- Headerを上部に配置し、左側にアプリ名、右側にUser Menuを配置する。
- Main Contentを中心に構成する。
- 画面タイトルやPrimary Actionが必要な場合は、Main Content上部で一貫したPage Headerパターンを利用する。

### 6.3. Focus / Tool App

座席表、エディタ、キャンバス型ツール等、広い作業領域が重要なアプリ向け。

**主要骨格**:

- Minimal Headerを上部に配置する。
- 残りをMain Workspaceとして広く利用する。
- アプリ内の主要操作はHeaderまたは一貫したToolbarに集約する。
- ユーザー関連操作の位置をアプリごとに無秩序に変更しない。

### 6.4. 固定するもの / 自由にするもの

利用者が複数アプリ間で学び直さなくて済むよう、次の要素は強く統一します。

- Headerの基本位置
- User Menuの位置
- Standard AppにおけるSidebarの役割と位置
- Page Headerの役割
- Primary Actionの基本的な配置領域

一方、次のようなコンテンツ内部の構成はアプリ要件に応じて変更できます。

- Contentの最大幅
- Grid / Card構成
- Dashboard Widgetの配置
- Filter Bar
- Tabs
- 補助Panel / Inspector
- Toolbarの具体的な操作項目
- 情報密度やコンテンツ固有の配置

例えばStandard Appに右側Inspectorを追加する構成は、新しいレイアウト種別ではなく **Standard Appの派生拡張** として扱います。

### 6.5. 既存レイアウトで足りない場合

既存3レイアウトで要件を満たせない場合は、次の順で判断します。

1. 既存レイアウトのどれが最も近いか確認する。
2. Sidebar、Inspector、Tabs、Toolbar等の拡張で対応できないか確認する。
3. それでも適合しない明確なUX上の理由がある場合のみ、プロジェクト固有Layoutを作成する。
4. 同じ派生Layoutが複数プロジェクトで繰り返された場合に限り、Application UI Standardへの昇格を検討する。

標準レイアウトの主要骨格を変更する場合は、「なぜ既存レイアウトの拡張では不足するのか」を説明できることを求めます。重要な逸脱であればプロジェクト側に理由を残します。

レイアウトの実装は各プロジェクト側で行い、実際に複数プロジェクトで同じ実装が繰り返されるまでは共通パッケージ化しません。


---

## 7. AIによる画面デザイン生成

Claude Design等のAIに画面デザインを依頼する場合も、本Standardを前提とする。AI専用のDesign Systemや詳細な画面テンプレートは別途作成しない。

### 7.1. 方向性

- 社内業務向けの、落ち着いて分かりやすいデザインとする。
- 装飾より、操作性と情報の把握しやすさを優先する。
- 情報密度は中〜やや高めを基本とする。

### 7.2. 避ける表現

- 過剰なCard分割
- 大きすぎる見出しや余白
- 意味のないGradient、強いShadow、過度な角丸
- 装飾だけを目的とした色やAnimation
- 業務画面に適さないLanding Page風の表現

### 7.3. 実装前提

生成するデザインは、`shadcn/ui`、Tailwind CSS、Lucide Iconsを前提とし、本StandardのSemantic TokenとLayoutに沿って実装可能な構成にする。`shadcn/ui` で表現できるものは独自Componentにせず、Django + React Islandsで実装困難な構成を避ける。

### 7.4. 依頼時に伝える情報

共通Standardへ画面固有の仕様を追加する代わりに、依頼ごとに次の情報を伝える。

- 画面の目的と主な利用者
- 表示する情報
- 最も重要な操作
- 現在の画面や業務上の課題

項目の詳細化や新しい共通ルールの追加は、複数の画面・プロジェクトで同じ判断の迷いが繰り返された場合にのみ検討する。
