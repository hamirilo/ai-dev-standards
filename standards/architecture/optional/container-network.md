# Docker Compose ネットワークとポート公開

Docker Compose を利用するプロジェクトでは、**ホストまたはLANから直接アクセスする必要があるサービスだけをホストへ publish します。**

攻撃面とポート競合を増やさないため、コンテナ間通信だけで利用するサービスを慣習的に `ports:` で公開しません。

## 必須事項

- Webアプリケーション等、ホストまたはLANから直接アクセスする必要がある入口だけを `ports:` で公開する。
- PostgreSQL、Redis、Celery worker / beat等、同一Compose内のコンテナ間通信だけで利用するサービスは原則としてホストへpublishしない。
- コンテナ間通信では `localhost` やホスト側の公開ポートを経由せず、Composeのサービス名とコンテナ内部ポートを使用する（例: `db:5432`, `redis://redis:6379/0`）。
- ホストOSからのみ必要な管理UI等は、必要性を確認したうえで `127.0.0.1` へbindする。LANから不要な管理サービスを `0.0.0.0` へ公開しない。
- 利用していない管理サービスは、localhost公開を残すのではなく不要な公開を削除する。
- 同一Compose network上の通信のためだけに、理由なく `expose:` を追加しない。
- Compose標準のdefault networkで要件を満たせる場合、独自networkを追加しない。
- ホスト側ポートはプロジェクトごとに変更してよい。コンテナ内部ポートは、特別な理由がなければサービス標準のポートを維持する。

## `ports:` を追加する判断

`ports:` を追加する場合は、そのサービスが少なくとも次のいずれかに該当することを確認します。

1. ブラウザまたは外部クライアントからアクセスする必要がある。
2. LAN内の別端末からアクセスする必要がある。
3. ホストOS上のツールからアクセスする必要がある。

いずれにも該当せず、同一Compose内のサービスからのみ利用される場合はpublishしません。

## 例

LAN内の別端末からもアクセスするWebアプリの場合は、LAN公開を意図したポートとして明示します。

```yaml
services:
  web:
    ports:
      - "8001:8000"  # LANアクセスを意図した公開

  db:
    image: postgres:16

  redis:
    image: redis:7
```

ホスト上のブラウザからのみ利用するWebアプリや管理UIは、LANへ公開せずloopbackへbindします。

```yaml
services:
  web:
    ports:
      - "127.0.0.1:8001:8000"

  flower:
    ports:
      - "127.0.0.1:5555:5555"
```

DjangoからPostgreSQLへは `db:5432`、Redisへは `redis://redis:6379/0` のように接続します。

## 変更時の確認

Composeのポート公開を変更する場合は、既存のホストOS上のツール、開発スクリプト、LANアクセスを壊さないことを確認します。最終的な公開状態は `docker compose config` 等で確認し、意図しないホストポート公開がないことを検証します。

既存Composeの棚卸し、設定調査、移行手順、検証方法は [Docker Compose ポート公開 Playbook](https://github.com/jazmf-dx/ai-dev-playbook/blob/main/playbooks/docker-compose-port-exposure.md) を参照してください。
