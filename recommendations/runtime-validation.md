# Runtime Validation

TypeScriptの型は実行時には消えるため、信頼境界から入るデータの正当性は必要に応じて実行時に検証します。

## 既定

**Zod** を既定とします。

対象例:

- APIレスポンス
- Django Templateから渡すJSON
- URLパラメータ
- `localStorage` 等のクライアント保存データ
- 外部サービスから受け取るデータ

## 利用原則

- 信頼境界で検証し、通過したデータをアプリケーション内部の型として扱う。
- TypeScriptの型定義と検証スキーマを可能な範囲で二重管理せず、Zodスキーマから `z.infer` で型を導出する。
- すべての内部オブジェクトをZodで再検証する必要はない。境界での検証を目的とする。
- 検証失敗を型アサーションやデフォルト値で隠さず、データ契約の不整合として扱う。
- サーバー側のDjango / PydanticスキーマとTypeScriptスキーマの自動共有基盤は、必要性が確認される前に導入しない。

## 例

```ts
import { z } from "zod"

const userSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
})

type User = z.infer<typeof userSchema>

const result = userSchema.safeParse(input)
if (!result.success) {
  // 境界データの不整合として処理する
}

const user: User = result.data
```

具体的なフォームバリデーションやAPI実装方法まで本Recommendationでは固定しません。
