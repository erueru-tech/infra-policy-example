package conftest

import rego.v1

# METADATA
# description: |
#  ConftestのExamplesからコピーしてきた関数
#  以下のように、ノードにkeyが存在するか確認している
#  object:{"a":1}, field:"a" の場合、true が返る
#  object:{"b":2}, field:"a" の場合、false が返る
# related_resources:
# - ref: https://github.com/open-policy-agent/conftest/blob/master/examples/serverless/policy/util.rego
has_field(object, field) if object[field]

has_field(object, field) if object[field] == false

has_field(object, field) := false if {
	not object[field]
	not object[field] == false
}
