# AI エージェント オンボーディング（移行用）

> **Deprecated compatibility entrypoint**
>
> Application向けの正式なAI入口は `ai-dev-platform/ai/ONBOARDING.md` へ移動しました。
> このファイルは、旧構成で `ai-dev-standards/ai/ONBOARDING.md` を参照しているApplicationを移行期間中に壊さないための互換ポインタです。

新しいApplicationでは、このファイルを入口として設定しないでください。

既存Applicationは、AI設定ファイル（`CLAUDE.md` 等）の参照先を **ai-dev-platform側の `ai/ONBOARDING.md`** へ変更してください。

代表的な配置では次を参照します。

- StandardsがPlatformのsubmoduleとして配置されている場合: `../../ai/ONBOARDING.md`
- `ai-dev-standards` と `ai-dev-platform` をworkspace直下へ並べている旧構成の場合: `../../ai-dev-platform/ai/ONBOARDING.md`

配置が異なる場合は、workspace内の `ai-dev-platform/ai/ONBOARDING.md` を探して参照します。

正式な導入・移行方法は [ai-dev-platform](https://github.com/hamirilo/ai-dev-platform) のREADME / Adoption Guideを正とします。

このファイルにはStandard本文・Recommendations・Playbookのルーティングを再掲しません。移行完了後に削除できる互換資産として扱います。
