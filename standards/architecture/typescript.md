# TypeScript / 型安全 Standard

フロントエンドでは、実行前に検出できる不整合を可能な限り開発・CI段階で検出します。

## 必須原則

- React Islandsを含む新規のフロントエンドアプリケーションコードは、原則としてJavaScriptではなく **TypeScript / TSX** を使用する。
- TypeScriptは `strict: true` を基本とする。
- 型チェックはBuildとは別の検証として実行し、対象プロジェクトのPR・マージ・リリースにおける必須ゲートとする。
- 型エラーを解消する目的だけで `any`、`@ts-ignore`、不必要な型アサーションを常用しない。利用する場合は、外部ライブラリの型不足や段階的移行など、型安全性を保てない明確な理由があること。
- 型エラーが発生した場合は、抑制して通す前にデータ構造、API契約、null/undefinedの扱い、コンポーネント間の契約等の不整合を確認し、可能な限り原因側を修正する。
- APIレスポンス、Django Templateから渡されるJSON、ユーザー入力、外部サービス等の **実行時データはTypeScriptの型だけで正当性を保証しない**。信頼境界では、必要に応じてruntime validationを行ってからアプリケーション内部の型として扱う。既定の検証手段は [Runtime Validation Recommendation](../../../recommendations/runtime-validation.md) を参照する。

最小構成の例:

```json
{
  "compilerOptions": {
    "strict": true,
    "noEmit": true
  }
}
```

`noUncheckedIndexedAccess`、`exactOptionalPropertyTypes` 等の追加オプションはプロジェクトの複雑さや既存コードへの影響を見て採用し、Core Standardでは一律必須にしません。

## 既存JavaScriptの扱い

既存の `.js` / `.jsx` を、このStandardの導入だけを理由に一括変換する必要はありません。機能追加や大きな変更を行う範囲から段階的にTypeScript化し、移行そのものを目的とした大規模変更は避けます。

## 意図

TypeScript導入の目的は型注釈を増やすことではなく、存在しないプロパティ参照、null/undefinedの扱い、関数引数・戻り値の不整合、コンポーネント間の契約違反など、静的に検出できるエラーを実行時まで残さないことです。

Linter、Formatter、Build、Testと同様に、機械的に判定できる問題はAIや人間の目視判断へ委ねず、ツールで早期に検出します。検出された失敗を抑制して成功扱いにするのではなく、[Architecture Standard](README.md) の Error Handling に従って根本原因の解決を優先します。
