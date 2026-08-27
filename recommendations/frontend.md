# Frontend Libraries

`shadcn/ui` で解決しない領域の既定です。掲載条件・拘束力・健全性チェックは [README](README.md) を参照してください。

各エントリは結論と確認日を持ちます。不採用としたライブラリを網羅的に列挙せず、避けるべき理由が具体的にあるものだけを「非推奨」へ記載します。

---

## 先にStandardで決着している用途

次はここで選び直さない。

| 用途 | 参照先 |
|---|---|
| Dialog、DatePicker、DataTable、Toast、Combobox等の基本UI | `shadcn/ui`（[Application UI Standard](../standards/application-ui/)） |
| 日付選択 | `shadcn/ui` の Calendar。内部エンジンは React DayPicker のため、別途ライブラリを選定しない |
| 通知（Toast） | `shadcn/ui` の Sonner。公式が従来の `toast` Componentを非推奨化しSonnerを後継としているため、別途ライブラリを選定しない |
| データテーブル（並び替え・絞り込み・ページネーション） | `shadcn/ui` の Table と TanStack Table を組み合わせる（[一覧画面](../standards/application-ui/optional/list-screens.md)）。別途ライブラリを選定しない |
| セレクト・オートコンプリート | Native `<select>` または `shadcn/ui` の Combobox |
| CSS | Tailwind CSS |

---

## 動画・音声プレイヤー

**既定**: Media Chrome — https://media-chrome.org/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- Web Components で `<video>` にコントロールを載せる。Django Template直書きでもReact Islands内でも同じ形で使える。
- HLS / CMAF 配信では `hls-video-element` を併用する。
- チャプター（`<track kind="chapters">`）、Chromecast、AirPlay を標準サポートする。
- テーマは [player.style](https://player.style) のギャラリーを利用できる。
- **使わなくてよい場面**: 再生できれば十分な用途では素の `<video controls>` で足りる。

確認日時点で最終リリース 4.19.2 (2026-06-10)、Open Issues 6。保守状態は良好。

---

## 画像ギャラリー / ライトボックス

**既定**: yet-another-react-lightbox — https://yet-another-react-lightbox.com/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- React Island内で利用する。React 16.8〜19対応、MIT、有償ティアなし。
- swipe / pinch-zoom に対応し、モバイルでの操作精度を確保できる。
- zoom, thumbnails, captions, video, fullscreen, slideshow 等のプラグインを必要な分だけ有効化する。
- 確認日時点で週間ダウンロード 517,552、最終コミット 2026-08-10、**Open Issues 3件**。この規模のライブラリとしては保守状態が突出して良い。
- インタラクティブUIをReact Islandsへ集約する [ADR-0002](../decisions/adr-0002-frontend-technology-boundary.md) と整合する。
- **使わなくてよい場面**: 単純な拡大表示だけで足りる場合は、`shadcn/ui` のDialogと画像表示で済むことがある。

GitHub star数は後述のPhotoSwipeより大幅に少ないが、star数は登場からの経過年数を強く反映するため保守状態の指標にしない（[README §3](README.md#最終リリース日だけで判断しない)）。週間ダウンロード数ではPhotoSwipeを上回っている。

### React Islandを置けない場合

素のDjango Templateページなど、React Islandを持たない画面でギャラリーが必要な場合に限り **PhotoSwipe v5**（https://photoswipe.com/ ）を使う。

**ステータス**: 様子見 / **確認日**: 2026-08-15

- MITライセンス、依存ゼロ、gzip 約13KB。Vanilla JSのためReactを必要としない。
- **様子見の理由**: 確認日時点で最終リリースが 5.4.4 (2024-05-24) と2年以上前。アーカイブはされておらず最終コミットは 2025-12-04 だが、リリース活動は減速し Open Issues は170件。
- この用途が実在しないことが確認できた時点で、エントリごと削除してよい。

---

## チャート

**既定**: Recharts — https://recharts.org/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- React Islands内で利用する。React 19 対応、アクセシビリティ対応を内蔵する。
- 確認日時点で最終リリース 3.10.1 (2026-07-25)。
- **Vanilla JS のチャートライブラリを併用しない。** [ADR-0002](../decisions/adr-0002-frontend-technology-boundary.md) によりインタラクティブUIはReact Islandsへ集約するため、同じ用途で2つ持つ理由がない。

---

## 地図

**既定**: Leaflet — https://leafletjs.com/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- gzip 約40KB。地点表示・ルート描画には十分。
- ベクタタイルや3D表現が必要な場合のみ MapLibre GL JS 等を検討する。バンドルサイズが約6倍になるため、必要性を確認してから採用する。
- **注意**: 最終リリースは 1.9.4 (2023-05-18) だが、リポジトリの最終コミットは 2026-08-10 で活発。v2 の開発が進行している。リリース間隔だけで放棄と判断しないこと（[README §3](README.md#最終リリース日だけで判断しない)）。

---

## 並べ替え（Drag & Drop）

**既定**: dnd kit — https://dndkit.com/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- React Islands内で利用する。tree-shake 対応。
- `@dnd-kit/core` の最終リリースは 6.3.1 (2024-12-05) だが、リポジトリの最終コミットは 2026-07-13 で活発。次期メジャーの開発が進行している。
- **Vanilla JS の並べ替えライブラリを併用しない。** チャートと同じ理由による（[ADR-0002](../decisions/adr-0002-frontend-technology-boundary.md)）。

---

## アイコン

**既定**: Lucide — https://lucide.dev/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- React では `lucide-react` を利用する。ISCライセンス。
- `shadcn/ui` が標準で利用しているアイコンセットのため、基本UIと見た目が揃う。
- 確認日時点で最終リリース 1.31.0 (2026-08-09)。リリース頻度は高い。

---

## 非推奨

新規採用しない。既存利用の即時書き換えは求めない。

| ライブラリ | 用途 | 理由 | 移行先 |
|---|---|---|---|
| **flatpickr** | 日付選択 | 事実上放棄。最終リリース 4.6.13 (2022-04-14)、Issue多数放置 | `shadcn/ui` Calendar |
| **Pikaday** / **Litepicker** / **Easepick** / **Tempus Dominus** | 日付選択 | いずれもGitHubアーカイブ済。開発終了 | `shadcn/ui` Calendar |
| **lightGallery** | 画像ギャラリー | GPLv3 / 商用有償のデュアルライセンス。再配布上の制約リスク | yet-another-react-lightbox |
| **Fancybox (`@fancyapps/ui`)** | 画像ギャラリー | 商用利用に有償ライセンスが必要。lightGalleryと同じ理由 | yet-another-react-lightbox |
| **Plyr.js** | 動画プレイヤー | Web Components 非対応、HLS/CMAF パイプラインとの統合が困難。開発は継続しているが停滞（3.8.4 / 2026-01-03） | Media Chrome |
| **tom-select** | セレクト・自動補完 | ライブラリ自体は健全（2.6.2 / 2026-07-07）だが、独自スタイリングがデザインシステム統一の障壁になるため段階的に廃止する | Native `<select>` / `shadcn/ui` Combobox |
| **Tabulator** / **Grid.js** / **DataTables** | データテーブル | いずれも自前のCSSテーマで描画するためSemantic Tokenが効かず、デザインシステム統一の障壁になる（tom-selectと同じ理由）。Grid.jsは最終リリース 6.2.0 (2024-03-03) で更新も停滞、DataTablesはjQuery依存 | `shadcn/ui` Table + TanStack Table |

Vanilla JS の日付ピッカーは主要ライブラリが軒並みアーカイブ済であり、この領域は `shadcn/ui` Calendar へ集約する。
