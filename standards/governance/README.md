# Governance & Rules

本ドキュメントは、「人およびAIエージェントはどう行動するか」という開発時の行動規範・ルールを定義する **Core Governance Standard** です。
「システムをどう作るか」は [Architecture Standard](../architecture/)、「画面をどう揃えるか」は [Application UI Standard](../application-ui/) を参照してください。

---

## 1. Standardの扱いと逸脱

- **Standardは強いデフォルト**: 原則として本リポジトリのStandardに従う。
- **逸脱は禁止しない**: プロジェクト要件により、Standardと異なる判断を選択できる。
- **重要な逸脱だけ記録する**: 将来「なぜこのプロジェクトだけ違うのか」と問われる可能性が高いものは、プロジェクト側ADR等に理由を残す。軽微な例外にADRは不要。
- **Standardの追加を目的化しない**: Core / Optionalへの追加基準は [ADR-0003](../../decisions/adr-0003-core-and-optional-standards.md) に従う。

---

## 2. AI利用方針

### 2.1. モデル選定

タスクの難易度に応じてAIモデルのティアを使い分けます。具体的なモデル名はStandardへ固定しません。

- **Light**: テスト実行、ログ収集、単純検証、軽微な修正
- **Standard**: 通常の実装、ドキュメント、一般的なレビュー（デフォルト）
- **High Performance**: 複雑な設計、難しい障害調査、重要なレビュー

高性能ティアは必要性がある場合に利用し、通常タスクで常用しません。

### 2.2. コンテキストと探索

- タスクと無関係なリポジトリ全体を無差別に探索しない。
- `ai/ONBOARDING.md` をルーターとして、必要なCore Standardだけを読む。
- Optional Standardは該当機能を扱う場合のみ読む。
- Standardで既に判断済みの内容を、毎回ゼロから比較・調査しない。
- Shared implementation / Shared UIに既存実装がある場合は再実装しない。

---

## 3. Git運用

### 3.1. ブランチ

- mainへ直接コミットしない。
- 作業ブランチは `type/topic/short-description` 等、目的が読み取れる名前にする。
- 1ブランチに無関係な目的を混ぜない。
- mainへの取り込みは原則squash mergeとする。

### 3.2. AIによるcommit / push

AIは、ユーザーからcommit / pushの権限が与えられていない状態で勝手に公開操作を行いません。

- 現在の依頼に「commitする」「pushする」「PRを作る」等が明示されている場合、その依頼を承認として扱い、同じ操作について二重確認しない。
- 明示的な承認がない場合は、変更内容を提示してからcommit / pushの可否を確認する。
- 無関係な変更が作業ツリーに存在する場合は、それを勝手にcommitへ含めない。

---

## 4. コードレビュー・品質管理

- commit / PR前に、プロジェクトで用意されているlint、format、type check、test等の関連チェックを実行する。
- 「将来必要になるかもしれない」という理由だけで独自ラッパーや抽象レイヤーを増やさない。
- 機械的に安く確実に判定できるものは自動化する。
- ArchitectureやUXの妥当性のような判断を、巨大な独自コンプライアンスツールへ置き換えない。AIによるセルフレビューと人間のレビューを利用する。

---

## 5. 技術・資産の追加判断

新しい技術や共通資産を追加するときは、まず既存のStandard / Recommendation / Shared implementationで解決できないか確認します。

- **判断を繰り返す** → Standard候補
- **特定機能でだけ必要な共通契約を繰り返す** → Optional Standard候補
- **具体的なライブラリのデフォルトを決めたい** → Recommendation
- **実装を繰り返す** → Shared implementation / Shared UI候補
- **1プロジェクト固有** → そのProject側

同じ用途のサードパーティライブラリを各プロジェクトで無秩序に増やしません。UI系の具体的な推奨技術はShared UI側で管理します。
