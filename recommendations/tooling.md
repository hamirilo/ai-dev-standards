# Toolchain

JS側のツールチェーンの既定です。掲載条件・拘束力は [README](README.md) を参照してください。

同一リポジトリ内でツールとロックファイルを混在させないという要求は [Architecture Standard](../standards/architecture/) が持ちます。本ファイルは、新規採用時の既定を示します。既存プロジェクトへ機械的な移行を求めません。

Pythonの環境・依存管理（uv）はArchitecture Standardが決めているため、ここでは扱いません。

---

## パッケージマネージャ

**既定**: Bun — https://bun.sh/
**ステータス**: 推奨 / **確認日**: 2026-08-15

- 新規プロジェクトでは `bun.lock` を既定とする。
- 既存プロジェクトが `npm` / `yarn` / `pnpm` を単独で利用している場合、Bunへの移行は必須としない。
- 異なるパッケージマネージャのロックファイルを併存させない。開発環境とCIで依存解決が食い違うためである。
- ロックファイルはGitへコミットする（Architecture Standard）。

**非推奨**: 同一リポジトリ内での `npm` / `yarn` / `pnpm` / Bun の混在。

---

## ビルドツール

**既定**: Vite
**ステータス**: 推奨 / **確認日**: 2026-08-15

- Tailwind CSS は `@tailwindcss/vite` プラグイン経由で組み込む。
- Django Templates + React Islands の構成では、ページ単位のエントリではなくIsland単位でバンドルを分けられる構成を基本とする。
