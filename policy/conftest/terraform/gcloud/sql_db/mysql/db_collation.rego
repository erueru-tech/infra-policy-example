package conftest.terraform.gcloud.sql_db.mysql

import rego.v1

msg_db_collation1 := "the `db_collation` value in GoogleCloudPlatform/sql-db module is required"

msg_db_collation2 := "the value of `db_collation` in GoogleCloudPlatform/sql-db module must be `utf8mb4_bin`"

# METADATA
# description: db_collationの値は定義必須
# authors:
# - name: fittecs
# custom:
#  severity: HIGH
violation_db_collation1 contains decision if {
	module := input.module[_]
	module.source == "GoogleCloudPlatform/sql-db/google//modules/mysql"
	not module.db_collation
	decision := {
		"severity": rego.metadata.rule().custom.severity,
		"msg": msg_db_collation1,
	}
}

# METADATA
# description: |
#  db_collationの値は`utf8mb4_bin`でなければいけない
#  `utf8_bin`等を設定した場合、絵文字が扱えなくなる
# authors:
# - name: fittecs
# custom:
#  severity: HIGH
violation_db_collation2 contains decision if {
	module := input.module[_]
	module.source == "GoogleCloudPlatform/sql-db/google//modules/mysql"
	module.db_collation != "utf8mb4_bin"
	decision := {
		"severity": rego.metadata.rule().custom.severity,
		"msg": msg_db_collation2,
	}
}
