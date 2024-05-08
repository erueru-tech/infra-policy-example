package conftest.terraform.eol

import rego.v1

# Terraformのリリース日は予測できないため現在の有効バージョンをリテラルで記述
hashicorp_support_verion := "1.7.0"

msg_required_version1 := "the terraform version used by your project has reached its end of life (EOL)"

# METADATA
# description: |
#  Terraformでは直近2リリースまでのバージョンの利用を望ましいとしているため、それより前のバージョンを使用している場合は警告を行う
# authors:
# - name: fittecs
# related_resources:
# - ref: https://support.hashicorp.com/hc/en-us/articles/360021185113-Support-Period-and-End-of-Life-EOL-Policy
#   description: HashiCorp社のEOLに対する見解
# - ref: https://endoflife.date/terraform
#   description: さまざまなツールのEOLが確認できるサイト(上記公式記事はここから見つけた)
# - ref: https://github.com/hashicorp/terraform/tags
#   description: |
#    ルールを実装する前に過去の全バージョン文字列を把握しておいた方がいい
#    なお比較に使用するバージョン文字列はどちらも組織内の人間が設定するものなので、そこまで神経質になる必要がないかもしれない
# custom:
#  severity: LOW
warn_required_version contains decision if {
	required_version := input.terraform.required_version
	semver.compare(hashicorp_support_verion, required_version) == 1
	decision := {
		"severity": rego.metadata.rule().custom.severity,
		"msg": msg_required_version1,
	}
}
