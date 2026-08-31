# 一覧画面

このOptional Standardは、並び替え、絞り込み、pagination、行選択等の対話的な一覧／検索画面を実装する場合に参照します。

業務systemで繰り返し現れる画面のため、実装手段と操作の判断を揃えます。Componentの具体的な実装手順は扱いません。

## 1. 実装手段の選択

| 画面の性質 | 実装 |
|---|---|
| 検索条件を送信して一覧を差し替えるだけで、client側の複雑なUI stateを持たない | Django Template + htmx |
| header操作、入力に追従する絞り込み、行選択等、client側のUI stateを持つ | React Island。表UIは `shadcn/ui` を基礎にし、必要に応じてTanStack Tableを利用する |

- htmxで十分な一覧を理由なくReact Islandへ移さない。
- UI stateを持つ表をhtmxと自前JavaScriptで複雑化しない。
- `shadcn/ui` のData Tableは完成済みの単一Componentではなく、TableとTanStack Tableを組み合わせるpatternとして扱う。

## 2. 絞り込み・並び替え・ページングの整合性

- server側でpaginationする場合、絞り込み・並び替えもserver側で行う。現在pageのdataだけをclient側で並び替えて、全体が並び替わったように見せない。
- 全件をclientへ渡してよいかはdata量、権限、機密性、初期転送量を含めて判断する。
- server側処理とclient側処理を混在させる場合は、利用者が見ている結果集合と操作対象が一致することを確認する。

大規模な一覧や性能問題を扱う場合は [Quality Recommendations](https://github.com/hamirilo/ai-dev-platform/blob/main/recommendations/quality.md) を参照してください。

## 3. 状態をURLへ反映する

並び替え、絞り込み条件、page番号は、再現性が必要な場合はquery parameterへ反映します。

- reload、browser back、URL共有で同じ一覧を再現できる。
- server側で処理する場合、URL parameterをqueryの入力として利用でき、stateの二重管理を減らせる。
- parameterはserver側で検証し、URL書き換えによって権限上見えない行や列が見えないようにする。

表示列等の個人表示設定は、URLへ載せるか永続化するかを画面ごとに判断して構いません。

## 4. 揃える操作

- 絞り込みUIは表の上部等、一貫した領域へまとめる。
- 並び替えは列headerから行い、昇順・降順のstateを見て分かるようにする。
- paginationは表の下部を基本とする。
- 一覧全体の主操作はPage Header領域へ置き、行単位の操作は当該行内へ置く。
- 行選択を持つ場合、絞り込みやpage移動時の選択stateの扱いを明確にする。

## 5. データがない場合

Core StandardのEmpty Stateに従い、次を区別します。

- **元dataが0件** — 有効な次の操作があれば示す。
- **絞り込み結果が0件** — 条件を緩める、または解除する手段を示す。

## 6. 共通化

- 同じ配線や操作が実際に繰り返された時点で共通化を検討する。1画面目から先行抽象化しない。
- 共通化へ業務domainの知識を持ち込まない。
- 対象Applicationが `application-ui-kit` を利用しており、既存Componentで解決できる場合は再実装しない。
- 汎用Componentとして複数Applicationから再利用する価値が確認された場合は、[ui-platform](https://github.com/hamirilo/ui-platform) への追加を検討する。

## 扱わないもの

- library選定 — [Recommendations / Frontend](https://github.com/hamirilo/ai-dev-platform/blob/main/recommendations/frontend.md)
- Data Tableの具体的なsetup、API、version migration — ai-dev-playbook
- Excel的なcell編集を伴う一覧 — 必要性が確認されたprojectで個別に設計する
