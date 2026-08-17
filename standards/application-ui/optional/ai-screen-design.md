# AI Screen Design

このOptional Standardは、Claude Design等のAIへ画面デザインを依頼する場合に参照します。

大規模なAI専用Design Systemや詳細な画面テンプレートをCore Standardへ追加しません。プロジェクトがapplication-ui-kitを採用している場合は、そのdesign-system/ディレクトリを画面設計の追加参照資料としてAIへ渡します。ここでは設計参照の使い方だけを定義し、具体的な実装コードは扱いません。

## 方向性

- 社内業務向けの、落ち着いて分かりやすいデザインとする。
- 装飾より、操作性と情報の把握しやすさを優先する。
- 情報密度は中〜やや高めを基本とする。

## 避ける表現

- 過剰なCard分割
- 大きすぎる見出しや余白
- 意味のないGradient、強いShadow、過度な角丸
- 装飾だけを目的とした色やAnimation
- 業務画面に適さないLanding Page風の表現

## 実装前提

- `shadcn/ui` と Tailwind CSS を前提とする。アイコンは [Recommendations](../../../recommendations/frontend.md) の既定に従う。
- Core StandardのSemantic TokenとLayoutに沿って実装できる構成にする。
- `shadcn/ui` で表現できるものを不用意に独自Component化しない。
- Django + React Islandsで実装困難な構成を避ける。

## 依頼時に伝える情報

画面固有の仕様はStandardへ追加せず、依頼ごとに次を伝える。

- 画面の目的と主な利用者
- 表示する情報
- 最も重要な操作
- 現在の画面や業務上の課題

新しい共通ルールは、複数の画面・プロジェクトで同じ判断の迷いが繰り返された場合にのみ検討する。
