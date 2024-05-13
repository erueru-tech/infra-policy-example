package conftest.terraform.gcloud.google_storage_bucket

import rego.v1

# policy/conftest/util.regoモジュールをインポート(OPAの仕様より.utilは定義不要)
import data.conftest

# deny_public_access_prevention_msg1のように関数名の先頭にdeny_を付けると
# Conftest実行時にルールと誤認識してエラーが発生するので注意
msg_public_access_prevention1(name) := sprintf(
	"`public_access_prevention` argument isn't defined for google_storage_bucket.%v",
	[name],
)

msg_public_access_prevention2(name, public_access_prevention) := sprintf(
	"google_storage_bucket.%v.public_access_prevention is `%v` instead of `enforced`",
	[name, public_access_prevention],
)

# METADATA
# description: |
#  google_storage_bucketリソースにpublic_access_preventionを定義していない場合、ルール違反
# authors:
# - name: fittecs
# related_resources:
# - ref: https://cloud.google.com/storage/docs/public-access-prevention?hl=ja
#   description: 公開アクセス防止設定に関するドキュメント
# custom:
#  severity: MEDIUM
deny_public_access_prevention contains decision if {
	some name
	bucket := input.resource.google_storage_bucket[name]
	not conftest.has_field(bucket, "public_access_prevention")
	decision := {
		"severity": rego.metadata.rule().custom.severity,
		"msg": msg_public_access_prevention1(name),
	}
}

# METADATA
# description: |
#  google_storage_bucketリソースのpublic_access_preventionに"enforced"以外の値を指定した場合、ルール違反
# authors:
# - name: fittecs
# custom:
#  severity: MEDIUM
deny_public_access_prevention contains decision if {
	some name
	public_access_prevention := input.resource.google_storage_bucket[name].public_access_prevention
	public_access_prevention != "enforced"
	decision := {
		"severity": rego.metadata.rule().custom.severity,
		"msg": msg_public_access_prevention2(name, public_access_prevention),
	}
}
