# ADR-0007: 見せ方だけを切り替えるUIとtemplate側共通classをUI Platformが所有する

**ステータス**: 採用
**関連**: [ADR-0002](adr-0002-frontend-technology-boundary.md)（補足。置換しない）、[ADR-0006](adr-0006-platform-composition-boundary.md)

## コンテキスト

ADR-0002はclient-side UI stateを持つinteractionをReact Islandsへ寄せ、htmxをserver起点の部分HTML更新へ限定しました。一方で、次の2つが未定義のまま複数Applicationで別々に解かれています。

1. **サーバーが描画したHTMLの見せ方だけを切り替えるUI。** tab切替、開閉、選択肢に応じた入力欄の出し分け等は、client stateを持つためADR-0002の表ではReactの責務に見えますが、Django Formが描いたHTMLをReactへ渡し直すと「Django Formで完結する処理のためだけにJSON APIを作らない」と衝突します。Applicationは自前の薄いIslandや軽量frameworkでこの隙間を埋めており、同じ制御が複数repositoryへ重複しています。
2. **Django Templateから使う共通CSS class。** UI PlatformはReact Componentと一部のtemplate用class（`.btn-*` / `.card` / `.badge` 等）を配布していますが、alert、tab、page header、pagination等はApplicationごとに独自CSSで定義され、Applicationあたり千行規模の重複と、React部品との見た目の差を生んでいます。

いずれも業務domainを含まない汎用UIであり、Applicationごとに差が出ることに価値がありません。

## 決定

1. **サーバー描画HTMLの見せ方だけを切り替えるUIは、UI Platformが提供する汎用Islandで扱う。** Islandはtab bar等の操作部だけを描き、対象contentはDjango Templateが描いたHTMLのまま表示・非表示を切り替える。Django Formの描画をReactへ持ち上げない。
2. `application-ui-kit` を採用しているApplicationは、当該UIを自前で実装しない。UI Platformに無い場合はUI Platformへ追加する。domain連携を内部に持つものは従来どおりApplicationが所有する。
3. **Django Templateから使う共通classはUI Platformが所有・配布する。** classは対応するReact Componentと見た目を揃え、Semantic Tokenだけで表現する。Applicationは同じ部品を独自CSSで再実装せず、brand差分はTokenの上書きで表現する。
4. htmxの役割、Alpine.js等を標準にしない判断、Domain Componentの扱いは変更しない。

## 理由

| 案 | 内容 | 判断 |
|---|---|---|
| A | 見せ方だけのUIもすべてReact Componentへ移し、contentをpropsで渡す | 却下。Django Formの描画がReact側へ移り、JSON APIとvalidationの複製を招く |
| B | 見せ方だけのUIは各Applicationの自前JavaScript / CSSに任せる | 却下。同じ制御と同じCSSがrepositoryごとに重複し、accessibilityと見た目が揃わない |
| C | UI Platformが汎用Islandとtemplate classを配布し、contentはserver描画のまま | 採用 |

- 案Cは、Django側にForm / SSR / authorizationを残すというADR-0002の目的をそのまま守れる。
- template classとReact Componentを同じrepositoryで所有すると、Tokenの変更が両方へ同時に反映される。
- UI Platformは既にtemplate用classとDjango接続Islandsを配布しており、責務境界を新設しない（ADR-0006の資産境界を変えない）。

## 結果

- 「見せ方だけならUI Platformの汎用Island、client stateを持つinteractionならReact Component、server描画の差し替えならhtmx」の3択で判断できる。
- Applicationはtemplate用CSSの自前定義と薄い制御Islandを、変更箇所から順にUI Platformのものへ置き換えられる。一括migrationは要求しない（ADR-0003「既存projectへの適用」のAdopt going forward）。
- UI Platformはtemplate classの一覧をpackageの公開契約として管理する必要がある。
- 具体的なIslandの契約、class一覧、対応するReact Componentは `ui-platform` が、Django側の接続手順は `ai-dev-playbook` が扱う。このADRにはIsland名・class名を列挙しない。

## 見直し

汎用Islandで扱えない見せ方の制御が複数projectで繰り返された場合、React Componentへ寄せるかhtmxで解くかを利用実績に基づいて再判断します。
