# ADR-0003: StandardsをCoreとOptionalに分離する

**ステータス**: 採用

## コンテキスト

Standardを増やしていくと、個々のルールは有用でも、すべてを全project共通として積み上げることで次の問題が起きます。

- 小さなprojectまで不要なruleへ従う必要が生じる。
- AIが読むdocument量が増える。
- 特定機能だけに必要な契約がCoreへ混ざる。
- 「Standardに書くこと」が目的化し、repositoryが肥大化する。

一方、Status APIのresponse契約等、特定機能を利用する場合には細部まで統一した方が連携・運用costを下げられる仕様もあります。

## 決定

Standardsを **Core Standard** と **Optional Standard** に分離します。

Standardへの追加は保守的に判断します。新しい知識やbest practiceを見つけても、まず「追加しない」「既存ruleへ統合する」「Standard外へ置く」を検討し、Standardとして共有する必要性が確認できた場合だけ追加します。

### Core Standard

対象projectの大半に適用する、少数で変わりにくい判断だけを置きます。

Coreへ追加する前に次を確認します。

1. 複数projectで同じ判断が繰り返されているか。
2. AIへ同じ説明を繰り返しているか。
3. 統一しないことで実際の保守・運用・UX上の問題が起きるか。
4. 対象projectの大半で適用でき、長期間変わりにくいか。

「将来必要になるかもしれない」「一般的なbest practiceである」「品質向上に役立つ」という理由だけではCoreへ追加しません。

### Optional Standard

特定機能を扱う場合だけ参照・適用する **共通契約・制約** を置きます。

対象とするのは、同じ機能について複数projectで同じ判断が繰り返され、統一されていること自体が連携・security・運用・UX上の価値になるものです。

AIはOptional Standardを先回りしてすべて読まず、該当する場合だけ参照します。Optional Standardが存在すること自体は、その機能を各projectへ導入する理由にはなりません。

具体的なimplementation、migration、verification、troubleshootingの手順はOptional StandardではなくPlaybookへ置きます。

## 既存projectへの適用

Standardは原則として、今後の判断、新規実装、変更箇所のdefaultとして適用します。

既存実装が現在のStandardと異なることだけを理由に、一括migration、全面refactoring、library置換、追加機能、infrastructure更新を要求しません。

Standard reviewで見つかった事項は次の3種類に分けます。

- **Required**: security、data integrity、必須CI gate等に関わり、現在の問題として修正が必要。
- **Adopt going forward**: 既存方式は直ちに移行せず、新規・変更箇所からStandardへ寄せる。
- **Optional improvement**: 品質向上、近代化、追加機能等。Standard適合とは分離する。

具体的な導入・棚卸し方法は `ai-dev-platform` のAdoption Guideで扱います。

## Standard以外への配置

新しい知識や資産をStandardへ追加する前に、次の配置先を検討します。

- 現時点のlibrary / toolのdefault → **`ai-dev-platform/recommendations`**
- 詳細なimplementation、migration、verification、failure example → **`ai-dev-playbook`**
- UI Foundations / Components / Patterns / Templates / Catalog / design reference → **`ui-platform`**
- 対象user、利用環境、認証・認可等のproject前提 → **Project Context**
- 業務domain固有UI → **そのdomainを所有するproject**
- 1project固有の判断 → **Project側ADR等**
- 重要なStandard自体の判断背景 → **Standards側ADR**
- 実際に繰り返しが確認されていない共通資産 → **まだ共通化しない**

ADRは「何を標準化しないか」を列挙するためには作りません。重要な決定・変更の理由を将来説明する価値がある場合にだけ残します。

## Optional Standard と Recommendation の判別

### 1. 不統一そのものが実害を生むか

**projectごとの不統一によって、連携・security・運用・UXの一貫性に、project単独では解決できない実害が生じるか**で判断します。

- 実害が生じる → **Optional Standard**。揃っていること自体が価値になる。
- 実害が生じない → **Recommendation**。探索costと事故率を下げるためのcurrent default。

たとえばStatus APIのresponse形式は、揃っていなければ共通monitoringが成立しません。一方、画像viewerのlibraryがprojectごとに違っても、他projectとの機械的連携は通常壊れません。

### 2. 「揃える判断」と「現在何を選ぶか」を分ける

同じtopicが両方へ分かれるのは正常です。

- 統一すること自体の要求 → **Standard**
- 現時点の具体的な選択 → **Recommendation**

例: JS package managerを同一repository内で混在させないことはStandard、新規採用時のcurrent defaultはRecommendationです。

### 3. 拘束力

- **Optional Standard**: Standardとして従う。重要な逸脱はproject側ADR等に理由を残す。
- **Recommendation**: 特に理由がなければ従う。逸脱にADRは要求しない。

## Standardへ製品名を書いてよい場合

具体的な製品名は原則としてRecommendationで扱います。ただし、次をすべて満たす基盤はStandardへ名指しできます。

- Application全体のarchitecture、UI基盤、data model、development flow等を大きく規定する。
- 差し替えcostが局所的ではなく、projectごとに毎回選び直す前提が成り立たない。
- 選定を変える場合、ADRを伴う規模のarchitecture decisionになる。

Django、PostgreSQL、`shadcn/ui`、Tailwind CSS等はこの条件を満たし得ます。特定機能に閉じた差し替え可能なlibraryはRecommendationで扱います。

## document構造

Standardsのtop-level領域は原則として次の3つから増やしません。

```text
standards/
├── governance/
├── architecture/
│   ├── README.md
│   └── optional/
└── application-ui/
    ├── README.md
    └── optional/
```

各領域の `README.md` をCoreとし、Optionalはその領域配下へ置きます。

## 結果

- Coreを短く保てる。
- 特定機能の共通契約だけをOptionalへ分離できる。
- implementation手順やcurrent library選定をStandardから分離できる。
- UI implementationをUI Platformへ集約できる。
- Standard適合をrepository全体の近代化projectへ拡張せずに済む。
