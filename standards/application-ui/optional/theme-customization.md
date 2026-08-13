# Theme Customization

このOptional Standardは、アプリ固有のThemeを定義・変更する場合に参照します。

Core Application UI Standardでは、意味を持つ色・状態表現をSemantic Tokenで実装することだけを要求します。具体的な配色やTheme値は各アプリ側で決めます。

## 基本原則

- `primary`, `secondary`, `muted`, `accent`, `destructive`, `background`, `foreground`, `border`, `input`, `ring` など、`shadcn/ui` のSemantic Token体系を基本とする。
- Tokenは「何色か」ではなく「何のための表現か」で選ぶ。
- Themeの具体値は各アプリ側で定義する。
- `shadcn/ui` ComponentがSemantic Tokenを適切に使っている場合は、画面側から固定色で上書きしない。
- Componentのvariantで意味を表現できる場合は、色の`className`よりvariantを優先する。

```tsx
<Button variant="destructive">削除</Button>
<Button>保存</Button>
```

## 固定色の扱い

意味を持つUI状態・役割について、`bg-blue-600` や `text-red-500` のような固定Tailwind Colorの直接指定は原則避ける。

一方、margin / padding / gap / width / flex / grid / position / responsive layoutなど、画面固有の構造・配置は通常どおりTailwind CSSで指定してよい。

## Theme値

Themeでは `oklch(...)` 等を利用して具体値を定義できる。

```css
:root {
  --primary: oklch(...);
  --primary-foreground: oklch(...);
  --destructive: oklch(...);
}
```

Standard側では `primary` を青にする等の具体的な配色は固定しない。

## Tokenを増やす場合

既存Tokenで表現できる場合は追加しない。新しいTokenは、既存Tokenでは表現できない独立した意味が継続的に必要になった場合だけ検討する。

色や場所をそのまま名前にしたTokenは避ける。

```text
避ける: company-blue / light-blue / header-gray
検討可能: success / warning
```

`success` や `warning` も、将来使うかもしれないという理由だけで先に追加しない。
