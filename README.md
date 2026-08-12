# AI Development Standards

**「複数のリポジトリを一人で継続的に開発するときに、AIと人間の判断・実装・UI/UXのブレを減らす」** ための Opinionated な開発スタンダードです。

本リポジトリは、あらゆる技術スタックに対応する汎用的なガイドラインではなく、**「Djangoを中心としたWebアプリケーションを、AI支援で効率的・一貫して開発するため」** の具体的で強いデフォルト（Opinion）を提供します。

## 構成と役割

このリポジトリは「どう作るべきか（判断の再利用）」を定義するものであり、「実際のUIコンポーネントやテンプレートの実装コード」は含まれません。

| ディレクトリ | 役割 | 内容 |
|---|---|---|
| `ai/` | **AI エージェント向けルーター** | `ONBOARDING.md`（最初に読むファイル。必要なStandardだけへ案内） |
| `standards/governance/` | **人・AIはどう行動するか** | AI利用方針、Git運用、逸脱ルール、Standard追加の考え方 |
| `standards/architecture/` | **システムをどう作るか** | Django/PostgreSQL/React Islands等のCore Architectureと、必要時だけ読むOptional Standard |
| `standards/application-ui/` | **画面構造・操作の一貫性** | UI/UXのCore原則、標準Layouts、エラー・フォームの扱い |
| `decisions/` | **ADR** | なぜ現在のStandardやArchitectureになったのかを説明する重要な決定の背景 |

## Core と Optional

Standardは、すべてを同じ強さで積み上げません。

- **Core Standard**: 対象プロジェクトの大半に適用する、少数で変わりにくい原則。
- **Optional Standard**: 特定機能を採用した場合だけ適用する詳細仕様。必要な場合はJSON契約やHTTP仕様なども具体的に定義する。

AIはCoreを基本として参照し、Optionalは該当機能を扱う場合だけ読みます。
Standardの追加・配置判断は [ADR-0004](decisions/adr-0004-core-and-optional-standards.md) に従います。

## 基本原則

1. **AIファースト・ルーター**: すべてのドキュメントを最初からAIに読ませず、`ai/ONBOARDING.md` を起点として必要なStandardだけを読む。
2. **Standardは強いデフォルト**: Standardからの逸脱は禁止しないが、重要な逸脱はプロジェクト側で理由を記録する。軽微な例外までADRを要求しない。
3. **実装との分離**: UIコンポーネントやプロジェクト雛形の実コードは本リポジトリに置かない。実装はShared UIや各プロジェクト等から参照する。
4. **繰り返しが確認されてから共通化する**: 「将来使うかもしれない」という理由だけでStandard・Shared実装・Project Templateを増やさない。
5. **レイアウトはテンプレート標準として扱う**: 新規アプリ・画面はApplication UI StandardのStandard / Simple / Focusいずれかを原則ベースとし、ゼロからナビゲーション構造を設計しない。固有要件はまず既存レイアウトの拡張で解決する。

## Standardにしないもの

以下は自動的にStandardへ追加しません。

- 特定ライブラリのバージョンや比較調査 → Recommendation / 実装側ドキュメント
- 再利用する実装コード → Shared UI等
- 1プロジェクト固有の判断 → Project側
- 判断理由だけを残すもの → ADR
- まだ繰り返しが確認されていない雛形 → 実プロジェクトで確認後にTemplate化を検討

## メンテナンスツール

本リポジトリ自体のメンテナンス用に最小限のツールを用意しています。
プラットフォーム化を防ぐため、独自の大規模な検証スクリプト等は構築しません。

```bash
# ドキュメントのリンク切れなどをチェック
just check-docs
```
