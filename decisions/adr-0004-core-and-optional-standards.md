# ADR-0004: StandardsをCoreとOptionalに分離する

**ステータス**: 採用

## コンテキスト

複数プロジェクトで同じ判断を繰り返さないためにStandardを整備すると、Security、Logging、Monitoring、File Upload、非同期処理など、標準化したい項目は自然に増えていく。

すべてを同じ強さ・同じ階層のStandardとして追加すると、次の問題が起きる。

- 小さなプロジェクトにも不要なルールが適用される
- AIがタスクと無関係な文書まで読み、コンテキストが増える
- Standardsリポジトリ自体が巨大なPlatformへ戻る
- 詳細仕様を追加しづらくなり、逆に曖昧なStandardが増える

一方、Status APIのようなシステム間契約は、必要なプロジェクトに対してはJSON形式やHTTP statusまで詳細に統一した方が運用上の価値が高い。

## 決定

Standardsを **Core Standard** と **Optional Standard** の2層に分ける。

### Core Standard

対象プロジェクトの大半に適用され、適用しない方が例外となる、長期間変わりにくい原則のみを置く。

各Standard領域の `README.md` をCoreとし、短く保つ。

### Optional Standard

特定機能を実装・利用する場合だけ適用する詳細仕様を `optional/` 配下に置く。

Optionalは必要な場合だけ読むため、システム間契約、必須フィールド、HTTP status、UX状態などをCoreより具体的に規定してよい。

### 新しいStandardの追加条件

新しい内容を追加する前に次を確認する。

1. 複数プロジェクトで同じ判断を繰り返しているか
2. 統一しないことで実際の運用・UX・保守上の問題があるか
3. AIへ同じ説明を繰り返しているか
4. 長期間変わりにくい内容か

Coreへの追加はさらに、対象プロジェクトの大半に適用されることを要求する。

### Standard以外へ置くもの

- 特定ライブラリのデフォルト候補: Recommendation
- 再利用するコード: Shared UI等の実装リポジトリ
- プロジェクトの起動雛形: 実際に繰り返しが確認された後にProject Templateへ抽出
- 単一プロジェクト固有の判断: プロジェクト側
- 判断の背景: ADR

## AIの読み方

AIは最初に `ai/ONBOARDING.md` を読み、タスクに関係するCore Standardだけを参照する。
Optional Standardは、該当機能を実装・変更する場合のみ読む。

例:

```text
通常の画面開発
→ Application UI Core

監視ダッシュボード連携
→ Architecture Core
→ architecture/optional/status-api.md
```

## 結果

- Standardの総数が増えても、1タスクあたりのコンテキスト量を抑えられる。
- 小規模アプリへ不要な機能要件を強制しない。
- 必要な機能についてはOptional側で十分に具体的な仕様を持てる。
- 「標準化したい = Coreへ追加する」という肥大化を防ぐ。
- 使われない、重複した、陳腐化したStandardは定期的にMERGE / MOVE / DELETEする前提とする。
