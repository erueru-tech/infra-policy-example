package conftest.terraform.gcloud.sql_db.mysql

import rego.v1

msg_db_charset1 := "the `db_charset` value in GoogleCloudPlatform/sql-db module is required"

msg_db_charset2 := "the value of `db_charset` in GoogleCloudPlatform/sql-db module must be `utf8mb4`"

# METADATA
# description: db_charsetの値は定義必須
# authors:
# - name: fittecs
# custom:
#  severity: HIGH
violation_db_charset contains decision if {
	some module in input.module
	module.source == "GoogleCloudPlatform/sql-db/google//modules/mysql"
	not module.db_charset
	decision := {
		"severity": rego.metadata.rule().custom.severity,
		"msg": msg_db_charset1,
	}
}

# METADATA
# description: |
#  db_charsetの値は`utf8mb4`でなければいけない
#  `utf8`等を設定した場合、絵文字が扱えなくなる
# authors:
# - name: fittecs
# custom:
#  severity: HIGH
violation_db_charset contains decision if {
	some module in input.module
	module.source == "GoogleCloudPlatform/sql-db/google//modules/mysql"
	module.db_charset != "utf8mb4"
	decision := {
		"severity": rego.metadata.rule().custom.severity,
		"msg": msg_db_charset2,
	}
}

# METADATA
# description: |
#  古くから運用されているデータベースではdb_charsetの値がutf8のままで、かつ変更も容易ではない可能性がある
#  そのようなケースではexceptionでルールチェックを免除する
# authors:
# - name: fittecs
exception contains rules if {
	# 除外対象のインフラプロジェクトのリポジトリ名を以下に定義
	ignore_projects := ["ignore-project"]
	some project in ignore_projects
	contains(data.conftest.file.dir, sprintf("/%v/", [project]))
	rules := ["db_charset"]
}
