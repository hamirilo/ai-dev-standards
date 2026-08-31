# Docker Compose ネットワークとポート公開

Docker Composeを利用する場合の **公開境界に関する判断原則** を定義するOptional Standardです。

具体的なCompose設定例、既存構成の棚卸し、移行手順、検証コマンド、トラブルシューティングはStandardへ重複して記載しません。実施時は [Docker Compose ポート公開 Playbook](https://github.com/hamirilo/ai-dev-playbook/blob/main/playbooks/docker-compose-port-exposure.md) を参照してください。

## Standard

- **ホストまたはLANから直接アクセスする必要があるサービスだけをhostへpublishする。**
- PostgreSQL、Redis、Celery worker / beat等、同一Compose内のコンテナ間通信だけで利用するサービスは、理由なくhostへpublishしない。
- コンテナ間通信は、host側の公開ポートや `localhost` を経由せず、Composeのサービス名とコンテナ内部ポートを利用する。
- LANから不要な管理サービスを `0.0.0.0` へ公開しない。hostからのみ必要な場合は公開範囲をhostへ限定する。
- Compose標準のnetworkで要件を満たせる場合、ポート整理だけを理由に独自networkや不要な `expose:` を追加しない。
- host側のポート番号はプロジェクト都合で変更してよい。コンテナ内部ポートは、特別な理由がなければサービス標準を維持する。

## `ports:` を追加する判断

hostへpublishするのは、少なくとも次のいずれかに該当する場合です。

1. ブラウザまたは外部クライアントから直接アクセスする必要がある。
2. LAN内の別端末から直接アクセスする必要がある。
3. host OS上のツールから直接アクセスする必要がある。

いずれにも該当せず、同一Compose内のサービスからのみ利用される場合はpublishしません。

## 境界

このStandardが決めるのは **「何を外へ公開してよいか」** までです。

次はPlaybookの責務です。

- 既存 `ports:` の棚卸し方法
- `127.0.0.1` bindやCompose YAMLの具体例
- DB / Redis接続先の変更方法
- `docker compose config` 等による検証
- 既存環境を壊さない移行順序
- Before / Afterの記録方法
- よくある失敗と障害対応
