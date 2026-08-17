# ADR-0004: 共有開発資産を用途・ライフサイクルで分離する

**ステータス**: 採用

## コンテキスト

AI開発では、同じ判断・調査・実装・UI検討を繰り返さないことがコスト削減につながる。一方で、Standard、詳細手順、UI実装、テンプレートを一つのAI開発プラットフォームへ集約すると、AIが読む量と保守範囲が増え、以前の構成と同じ肥大化を招く。

また、UIには単なる色違いではなく、Select、Combobox、Filter Selectionのような利用目的そのものが異なるパターンがある。これらを一つのCore Standardへ詰め込まず、必要なときに参照できる設計・実装資産として管理する必要がある。

## 決定

1. ai-dev-standardsは、AIが通常タスクで読む少数の判断原則を管理する。Core Standardの領域はGovernance、Architecture、Application UIの3つとする。
2. Recommendationは現時点の選択を短く記録する。詳細な実装手順、コード例、検証方法、失敗例はRecommendationへ置かない。
3. 詳細な実装知識とStarterは、hamirilo/ai-dev-playbookとしてStandardとは別に管理する。Playbookは必要なタスクでのみ参照する。
4. 汎用UIの設計参照、UI実装、Storybookはhamirilo/application-ui-kitとしてStandardとは別に管理する。Claude Designへ渡す設計参照は、UI Kit内のdesign-system/ディレクトリに自己完結させる。
5. 社員検索、組織ツリー、Authentik連携などの業務ドメインUIは、各アプリまたはドメイン所有側で管理する。
6. ai-dev-foundationのような全資産を集約する単一モノレポは作らない。各リポジトリは同じ公開方針にできるが、利用方法・更新頻度・配布方法の違いを優先して分離する。
7. hamirilo/application-ui-kitの内部で複数の配布単位が必要になった場合は、そのリポジトリだけをモノレポ化する。StandardやPlaybookと同じリポジトリへ戻さない。
8. 各アプリには共有資産をサブモジュールとして持たせない。StandardとPlaybookは参照、UI Kitはパッケージ依存を基本とする。

## 境界

| 資産 | 正本 | 利用方法 |
|---|---|---|
| 判断原則 | ai-dev-standards | AIが必要なCore/Optionalを参照 |
| 現時点の選択 | ai-dev-standardsのRecommendation | 新規採用時に参照 |
| 詳細手順・検証・失敗例 | hamirilo/ai-dev-playbook | タスク単位で参照 |
| UI設計参照 | hamirilo/application-ui-kit/design-system/ | Claude Designや人間が参照 |
| UI実装 | hamirilo/application-ui-kit | パッケージとして利用 |
| 業務ドメインUI | 各アプリ・ドメイン所有側 | そのアプリの要件に合わせて実装 |

## 結果

- Standardを常時読む量を小さく保てる。
- 詳細知識を蓄積しながら、Standardの責務を広げずに済む。
- UIの大きなパターン差を、Core Standardのバリエーションとして増やさずに管理できる。
- UI実装は独立してバージョン管理・配布できる。
- 将来の分割判断を、ディレクトリ名ではなく利用者・更新単位・配布方法で行える。

## 例外・見直し

同じリポジトリへ統合する場合は、同じリリースで更新する必要があり、かつ別管理による負担が実際に上回ることをADRで説明する。単に同じ公開範囲であることや、リンクしやすいことだけを理由に統合しない。
