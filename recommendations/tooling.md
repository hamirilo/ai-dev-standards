# Toolchain

JS側のツールチェーンの既定です。掲載条件・拘束力は [README](README.md) を参照してください。

「プロジェクト間で統一し無秩序に変えない」という要求自体は [Architecture Standard](../standards/architecture/) が持ちます。本ファイルは **現時点で何に統一しているか** を持ちます。

Pythonの環境・依存管理（uv）はArchitecture Standardが決めているため、ここでは扱いません。

---

## パッケージマネージャ

**既定**: Bun — https://bun.sh/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- 全リポジトリで `bun.lock` に統一する。
- `package-lock.json` を併存させない。1リポジトリに複数のロックファイルがあると、開発環境とCIで依存解決が食い違う。
- ロックファイルはGitへコミットする（Architecture Standard）。

**非推奨**: 同一リポジトリ内での `npm` / `yarn` / `pnpm` との混在。単独利用を禁止するものではないが、プロジェクトを跨いで揃える対象とする。

---

## ビルドツール

**既定**: Vite
**ステータス**: 推奨 / **確認日**: 2026-08-15

- Tailwind CSS は `@tailwindcss/vite` プラグイン経由で組み込む。
- Django Templates + React Islands の構成では、ページ単位のエントリではなくIsland単位でバンドルを分けられる構成を基本とする。
