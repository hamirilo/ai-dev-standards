# Project Setup

このOptional Standardは、新しいリポジトリを立ち上げるとき、および既存リポジトリをStandardへ適合させるときに参照します。

ここは **既に他のStandardで定義されている義務の集約点** です。規則そのものを再掲せず、規定元を指します。記述が食い違った場合は、常に規定元を正とします。

---

## 用意するもの

| | 項目 | 規定元 |
|---|---|---|
| 1 | `CLAUDE.md` 等のAI設定ファイルから `ai-dev-platform/ai/ONBOARDING.md` を参照させる | [Governance §1.2](../README.md) |
| 2 | `decisions/` を用意する | [Governance §1.1](../README.md) |
| 3 | Pythonの環境・依存管理を uv にする | [Architecture §1](../../architecture/README.md) |
| 4 | ロックファイルをGitへコミットする | [Architecture §1](../../architecture/README.md) |
| 5 | JSのパッケージマネージャとロックファイルを同一リポジトリ内で混在させない | [Architecture §1](../../architecture/README.md) / [Recommendations / Toolchain](../../../../recommendations/tooling.md) |
| 6 | FormatterとLinterを導入する。利用可能ならType Checkerも導入する | [Governance §4.1](../README.md) |
| 7 | PostgreSQLを使う | [Architecture §1](../../architecture/README.md) |
| 8 | 社内向けの従業員ログインは OIDC + Django Session とする | [Architecture §1](../../architecture/README.md) |
| 9 | 基本UIに `shadcn/ui`、CSSに Tailwind CSS を使う | [Application UI §1](../../application-ui/README.md) |
| 10 | 起点レイアウトを Standard App / Simple App / Focus App から選ぶ | [Application UI §6](../../application-ui/README.md) |
| 11 | 本番運用を開始する前に構造化ログを用意する | [Architecture §6](../../architecture/README.md) |

**1と2を最初に済ませます。** この2つが無い状態では、以降の項目をAIが自力で参照できません。

11は立ち上げ時点で必須ではありません。本番運用の開始までに満たします。

---

## 決めるもの

答えはプロジェクトごとに異なります。Standardが揃えるのは答えではなく、**着手前に答えが出ていること** と **どこに書いてあるか** です。

未決定のまま実装へ入ると、AIはセッションごとに別の仮定を置きます。結果として、プロジェクト内部で不整合が生じます。

| | 決めること | 未決定だと起きること | 関連 |
|---|---|---|---|
| A | ログインを必要とするか。必要な場合、利用するのは社内従業員か、社外の一般ユーザーか、その両方か | 認証方式を選べない。後から認証を足すと全体へ波及する | [Architecture §1](../../architecture/README.md) |
| B | 各ユーザーがメールアドレスを持つか、社員番号等の内部IDのみか | AIはメールアドレスが存在する前提で実装する。通知手段やアカウント回復の設計もそれに引きずられる | [Architecture §1](../../architecture/README.md) |
| C | PC、タブレット、モバイルのうち主に使われるのはどれか。複数ある場合どれを優先するか | 画面ごとに情報密度と操作系がばらつく | Standardに規定なし |
| D | Standard App / Simple App / Focus App のどれを起点とするか | 画面ごとにナビゲーションや主要操作の位置が変わる | [Application UI §6](../../application-ui/README.md) |
| E | 業務権限をどの単位で分けるか | データモデルに直結する。後から変えると移行が重い | [Architecture §4](../../architecture/README.md) |

Aの答えによって、BとEが不要になることがあります。該当しない項目は「該当なし」と記録します。

選択肢を先に列挙しません。列挙は必ず不完全になり、そこに無い答えを選びにくくします。

### 項目を増やす場合

次を満たすものだけを追加します。

> **未決定のままだとAIが実装中に勝手に仮定を置き、その仮定が後で覆ったときの手戻りが大きいもの。**

機能要件、スケジュール、体制は含めません。未決定でもAIが勝手に埋めないためです。ここを要件定義の置き場にしません。

### 決めた内容の記録先

プロジェクトの `decisions/` へ `project-context.md` として残します。

これは連番ADRではなく、AIエージェントが実装前に読む**現在のプロジェクト前提**です。既存リポジトリですでに `adr-0001` が使われていても番号衝突を起こしません。前提を変更した場合はこのファイルを更新し、変更理由を将来説明する価値があるときだけ、[Governance §1.1](../README.md) に従って別の連番ADRを残します。

ファイル名を固定するのは、AIエージェントが実装前にこれを読むためです（[ONBOARDING 必守事項7](../../../../ai/ONBOARDING.md)）。場所や名前がプロジェクトごとに違うと、決めた前提が読まれません。

---

## 既存リポジトリへ適用する場合

既存リポジトリ向けの別手順を作らず、上の一覧をそのまま点検項目として使います。

- 1と2から先に埋める。これによって、以降の差分の洗い出しをAIへ任せられるようになる。
- 一括再整形や依存の入れ替えを、機能変更と同じcommit / PRへ混ぜない（[Governance §4.2](../README.md)）。
- 既存の選択がStandardと異なる場合、機械的に合わせない。切り替えコストが見合わない場合は逸脱として扱い、[Governance §1](../README.md) に従って理由を残す。

適合を一度に完了させることを求めません。着手時点で差分を把握できていれば足ります。

---

## ここで扱わないもの

- CI/CD、デプロイ、インフラ構成（[README「意図的に扱わないもの」](../../../README.md#意図的に扱わないもの)）
- プロジェクト固有の機能要件
- 個別のツール名、ルールセット、コマンド名（[Governance §4.2](../README.md)）
