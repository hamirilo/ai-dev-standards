# ADR-0002: React Islandsをinteractive UIの標準としhtmxの役割を限定する

**ステータス**: 採用
**置換対象**: ADR-0001（非推奨）
**補足**: [ADR-0007](adr-0007-presentation-only-islands-and-template-classes.md) が、サーバー描画HTMLの見せ方だけを扱うUIの置き場所とtemplate側共通classの所有を追加で決定（このADRは置換しない）

## コンテキスト

Django Templatesをpage shell / SSR / Form / authorizationの基盤として維持しながら、interactive UIを複数のJavaScript手段へ分散させると、同じUI stateをReact、htmx、自前JavaScript等で実装できてしまい、Application間で判断がぶれます。

UI PlatformはReact ComponentとDjango接続用Islandsを提供するため、interactive UIの標準手段をReactへ寄せ、htmxはHTMLをserverから部分更新する用途へ限定します。

## 決定

**React Islandsをinteractive UIの標準手段とする。**

| 技術 | 責務 |
|---|---|
| Django Templates | Routing、page shell、SSR、Django Form、server-side authorization |
| React Islands | Dialog、DatePicker、Select、Toast、Table等のclient-side UI stateを持つinteraction |
| htmx | Serverから返るHTMLによる部分更新と軽量event接続 |

### htmxを利用する代表的な場面

1. 検索・filter・pagination等、serverで生成したlist HTMLを差し替える。
2. React IslandのDialog等からDjango Form HTMLを取得して表示する。
3. `HX-Trigger` 等でserver処理結果をclient側UI feedbackへ接続する。

この範囲を超えてclient-side UI stateを複雑に持つ場合はReact Islandを優先します。

Alpine.js等、同じinteractive UI layerを増やす軽量frameworkを標準にはしません。

## 理由

- UI stateの実装手段を絞り、AIと人間の判断を安定させる。
- Django Form、SSR、authorizationをserver側へ維持できる。
- Server-generated HTMLの単純な差し替えではhtmxの方が小さく保てる。
- UI PlatformのReact Component / IslandsをApplication間で再利用できる。

## 結果

- 「client-side UI stateを持つならReact Island」をdefaultにできる。
- htmxとReactの責務が重複しにくくなる。
- DjangoをBFF / API-only serverへ不用意に変えずにrich UIを利用できる。

具体的なDjango / React接続方法はPlaybookとUI Platformで扱います。
