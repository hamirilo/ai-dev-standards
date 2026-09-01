# TypeScript / 型安全 Standard

フロントエンドでは、実行前に検出できる不整合を可能な限り開発・CI段階で検出します。

## 必須原則

- React Islandsを含む新規のフロントエンドApplication codeは、原則としてJavaScriptではなく **TypeScript / TSX** を使用する。
- TypeScriptは `strict: true` を基本とする。
- 型チェックはBuildとは別の検証として実行し、対象projectのPR・merge・releaseにおける必須gateとする。
- 型errorを解消する目的だけで `any`、`@ts-ignore`、不必要な型assertionを常用しない。
- 型errorが発生した場合は抑制して通す前に、data structure、API契約、null / undefined、component間契約等の不整合を確認し、可能な限り原因側を修正する。
- API response、Django Templateから渡されるJSON、user input、外部service等の **実行時dataはTypeScriptの型だけで正当性を保証しない**。信頼境界では必要に応じてruntime validationを行う。既定の検証手段は [Runtime Validation Recommendation](https://github.com/hamirilo/ai-dev-platform/blob/main/recommendations/runtime-validation.md) を参照する。

`noUncheckedIndexedAccess`、`exactOptionalPropertyTypes` 等の追加optionはprojectの複雑さや既存codeへの影響を見て採用し、Core Standardでは一律必須にしません。

## 既存JavaScriptの扱い

既存の `.js` / `.jsx` を、このStandardの導入だけを理由に一括変換する必要はありません。機能追加や大きな変更を行う範囲から段階的にTypeScript化し、移行そのものを目的とした大規模変更は避けます。

## 意図

TypeScript導入の目的は型注釈を増やすことではなく、存在しないproperty参照、null / undefined、function引数・戻り値、component間契約等の不整合を実行時まで残さないことです。

Linter、Formatter、Build、Testと同様に、機械的に判定できる問題はAIや人間の目視判断へ委ねず、toolで早期に検出します。検出された失敗を抑制して成功扱いにするのではなく、[Architecture Standard](README.md) のError Handlingに従って根本原因の解決を優先します。
