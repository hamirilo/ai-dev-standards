# Status API / Monitoring Contract

このOptional Standardは、共通ダッシュボードや監視システムからWebアプリケーションの状態を取得する場合に適用します。

目的は、監視実装や利用ライブラリを統一することではなく、**監視側から見たインターフェース契約を統一すること**です。

## 適用条件

以下のいずれかに該当する場合、このContractを適用します。

- 共通ダッシュボードからサービス状態を取得する
- 外部の死活監視からHTTPで状態確認する
- 複数アプリの稼働状況を同じ仕組みで集約する

単独運用で外部監視を必要としないアプリには必須ではありません。

## Endpoint

```http
GET /api/status/
```

監視システムがプロジェクトごとのURL差異を意識しなくて済むよう、このパスを共通契約とします。

原則として認証なしで取得可能とします。ただし、レスポンスにはSecret、接続先、stack trace、個人情報などの機密情報を含めません。公開範囲が広い環境では、ネットワーク制御や監視方式を含めてリスクを評価してください。

## Response Contract

### 正常例

```json
{
  "status": "ok",
  "service": "idea-portal",
  "environment": "production",
  "timestamp": "2026-08-13T07:50:00+09:00",
  "version": "1.4.2",
  "checks": {
    "database": {
      "status": "ok"
    },
    "storage": {
      "status": "ok"
    }
  }
}
```

### 障害例

```json
{
  "status": "error",
  "service": "idea-portal",
  "environment": "production",
  "timestamp": "2026-08-13T07:50:00+09:00",
  "version": "1.4.2",
  "checks": {
    "database": {
      "status": "error",
      "message": "database unavailable"
    }
  }
}
```

## Fields

| Field | 必須 | 内容 |
|---|---|---|
| `status` | Yes | サービス全体の状態。`ok` / `degraded` / `error` |
| `service` | Yes | ダッシュボード上で一意に識別できる安定したサービス名 |
| `environment` | Yes | `production`, `staging` 等の実行環境 |
| `timestamp` | Yes | レスポンス生成時刻。ISO 8601形式 |
| `version` | No | デプロイ中のアプリケーションバージョンやcommit等 |
| `checks` | No | 依存サービス等の個別チェック結果 |

`checks` の各要素は最低限 `status` を持ちます。`status` の値はサービス全体と同じ `ok` / `degraded` / `error` の3値です。個別checkの結果からサービス全体の `status` をどう導出するか（例: 非必須依存の `error` を全体では `degraded` とする等）はプロジェクトで判断します。

```json
{
  "status": "ok"
}
```

必要に応じて、人間が理解できる短い `message` を追加できます。ただし、内部例外、ホスト名、接続文字列等をそのまま返しません。

## Status semantics

### `ok`

サービスが通常利用可能な状態。

### `degraded`

一部の非必須機能・依存先に問題があるが、サービスの主要機能は利用可能な状態。

### `error`

主要機能を提供できず、サービスとして利用不能と判断する状態。

## HTTP Status

- `200`: `status` が `ok` または `degraded`
- `503 Service Unavailable`: `status` が `error`

監視システムはJSON本文だけでなくHTTP statusでも障害判定できるようにします。
レスポンスには `Cache-Control: no-store` を設定し、経路上のキャッシュによる古い状態の返却を防ぎます。

## Checkの考え方

DB、Storage、Cache、外部API等の何をチェックするかはプロジェクト要件で決めます。
すべての依存先を無条件にチェックすることは要求しません。

チェック追加時は次を考慮します。

- その依存先の障害がサービス利用可否に影響するか
- 一時的な遅延で頻繁な誤検知を起こさないか
- Status API自体を重い処理にしないか

## Implementation Boundary

`django-health-check` 等の具体的なライブラリはStandardで固定しません。
利用する場合も、そのライブラリ固有レスポンスを外部契約にせず、このContractへ変換して返します。

```text
health-check library / custom checks
            ↓
        adapter / view
            ↓
      Status API Contract
            ↓
    dashboard / monitoring
```

これにより、内部実装を変更しても監視ダッシュボード側の契約を維持できます。

## Liveness / Readiness

現時点では `/live` と `/ready` をCore契約として分離しません。
必要性が生じた場合は、このOptional Standardを拡張するか、用途別Contractとして追加します。
