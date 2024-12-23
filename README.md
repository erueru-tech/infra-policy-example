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

# org-policies/conftestディレクトリ内に定義された全ポリシーテストを実行
$ conftest test -p org-policies/conftest --all-namespaces .
```

## 開発

このプロジェクトの開発では以下のツールを利用しています。

- [pre-commit](https://pre-commit.com/#install) v4.0.1
- [OPA](https://www.openpolicyagent.org/docs/latest/#1-download-opa) v1.0.0
- [Regal](https://github.com/StyraInc/regal?tab=readme-ov-file#download-regal) v0.29.2
- [Conftest](https://www.conftest.dev/install/) v0.56.0
- [Trivy](https://aquasecurity.github.io/trivy/latest/getting-started/installation/) v0.57.0

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

## 情報

設計に関する詳細は[ブログ](https://zenn.dev/erueru_tech)などで公開していますので、興味のある方はそちらを確認してください。
