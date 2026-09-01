# ADR-0005: 共有資産のforkにsource差分を持たない

**ステータス**: 採用

## コンテキスト

[ADR-0006](adr-0006-platform-composition-boundary.md) で定義する共有資産は公開repositoryとして管理し、利用組織がforkして利用できるようにします。

forkの主な目的は次です。

1. **配布・運用の所有**: UI package等を利用組織自身のscopeでpublishできる。
2. **上流への往復路**: 組織内で検証した汎用改善をupstreamへ返せる。

forkへ恒常的なsource差分を持つと、upstream追従、submodule参照、package publish、上流PRのすべてで差分管理が必要になります。

## 決定

1. **forkへ恒常的なsource差分を持たない。** forkは別製品を作る場所ではなく、配布・検証・upstreamとの往復に利用する。
2. **owner依存値をsourceへ固定しない。** package scope等はpublish時または利用側設定から導出する。
3. **Platformのsubmodule URLはowner固定を避ける。** sibling repository構成を前提にrelative URLを利用し、fork側で `.gitmodules` の恒常差分を持たない。
4. **汎用改善はupstreamへPRする。** 組織名、内部URL、内部host、特定project固有path、非公開運用等を含まない変更を候補とする。
5. **組織固有情報はforkへ混ぜない。** その情報を所有するApplicationや別の組織内共有資産へ置く。
6. やむを得ずforkへ恒常差分を持つ必要が生じた場合は、forkではなく独立repositoryとして分岐すべきかを先に検討する。

## Package

UI Platform repository名は `ui-platform`、Applicationから利用するpackage依存名は `application-ui-kit` とします。

GitHub Packagesの実package名は `@<owner>/application-ui-kit` とし、publish元repositoryのownerに合わせます。Application側はnpm aliasで `application-ui-kit` に固定し、source codeへowner差分を持ち込みません。

## Platform submodule

PlatformはStandards / Playbookをsubmoduleとしてpinします。

`.gitmodules` は次のようにrelative URLを利用します。

```ini
[submodule "standards"]
    path = standards
    url = ../ai-dev-standards.git

[submodule "playbook"]
    path = playbook
    url = ../ai-dev-playbook.git
```

これにより、`owner-a/ai-dev-platform` は同じownerの `owner-a/ai-dev-standards` / `owner-a/ai-dev-playbook` を参照し、forkごとにURLを書き換えるsource差分を避けられます。

この構成を利用するownerは、Platformだけでなく対応するStandards / Playbook repositoryも同じowner配下へ用意します。

## 結果

- upstream更新を取り込みやすい。
- forkごとの `.gitmodules` 差分を避けられる。
- UI packageをownerごとのscopeでpublishしてもsource差分が生じない。
- upstream PRへ組織固有差分が混ざりにくい。
- forkと独立製品の境界を明確にできる。

## 見直し

upstreamと恒常的に異なる要件を持つようになった場合は、fork差分を積み上げず独立repositoryとして分岐する判断をADRへ残します。
