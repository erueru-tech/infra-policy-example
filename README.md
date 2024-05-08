# infra-policy-example

組織内のインフラプロジェクトのほぼすべての設定ファイルに対してポリシーを適用するためのプロジェクトです。

## 利用手順

このリポジトリに定義されているポリシーを使用して、各自のインフラプロジェクトの設定ファイルに対してテストを行う場合、以下のコマンドを実行します。

なお [Conftest](https://www.conftest.dev/install/) はすでにインストール済みであることを前提としています。

Conftest について解説が必要な場合は、[こちら](https://zenn.dev/erueru_tech/articles/6a9d502efc8d7b)の記事などを参考にしてください。

```bash
$ cd /path/to/your-infra-project

# このリポジトリのpolicyディレクトリを、各自のインフラプロジェクトのルート直下にorg-policiesというディレクトリ名でダウンロード
# なお各自のプロジェクトでGit管理されないようにするために.gitignoreでorg-policiesを定義する必要がある
$ conftest pull git::https://github.com/erueru-tech/infra-policy-example.git//policy -p org-policies

# org-policiesディレクトリ内に定義された全ポリシーテストを実行
$ conftest test -p org-policies --all-namespaces .
```

(組織内のインフラプロジェクトでポリシーテストを実行するための共有 Github Action はいずれ実装予定)

## 開発

このプロジェクトの開発では以下のツールを利用しています。

- [pre-commit](https://pre-commit.com/#install) v3.7.0
- [OPA](https://www.openpolicyagent.org/docs/latest/#1-download-opa) v0.64.1
- [Regal](https://github.com/StyraInc/regal?tab=readme-ov-file#download-regal) v0.21.3
- [Conftest](https://www.conftest.dev/install/) v0.51.0

各ツールのインストール手順は公式ドキュメントを参照してください。

## 開発手順

Rego のポリシーの実装に必要なコマンドは以下のようになります。

(Rego によるルール実装に関する記事は近日公開予定)

### Rego のテストコードの実行

```bash
$ conftest verify --show-builtin-errors
```

### フォーマッタの適用

```bash
$ ./scripts/opafmt.sh
```

### リンタの適用

```bash
$ ./scripts/regal.sh
```
