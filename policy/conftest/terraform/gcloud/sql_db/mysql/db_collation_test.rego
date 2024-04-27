package conftest.terraform.gcloud.sql_db.mysql

import rego.v1

# db_collationが定義されていない場合、ルール違反
test_violation_db_collation1 if {
	cfg := parse_config("hcl2", `
		module "sql_db" {
			source = "GoogleCloudPlatform/sql-db/google//modules/mysql"
		}
	`)
	{"severity": "HIGH", "msg": msg_db_collation1} in violation_db_collation1 with input as cfg
}

# db_collationの値が`utf8mb4_bin`でない場合、ルール違反
test_violation_db_collation2 if {
	cfg := parse_config("hcl2", `
		module "sql_db" {
			source     = "GoogleCloudPlatform/sql-db/google//modules/mysql"
			db_collation = "utf8_bin"
		}
	`)
	{"severity": "HIGH", "msg": msg_db_collation2} in violation_db_collation2 with input as cfg
}

# moduleの名前はルール判定に影響しない(ルールの汎用性をテスト)
test_violation_db_collation3 if {
	cfg := parse_config("hcl2", `
		module "foo_bar" {
			source     = "GoogleCloudPlatform/sql-db/google//modules/mysql"
			db_collation = "utf8_bin"
		}
	`)
	{"severity": "HIGH", "msg": msg_db_collation2} in violation_db_collation2 with input as cfg
}

# db_collationの値が`utf8mb4_bin`である場合、ルールにパスする
test_violation_db_collation4 if {
	cfg := parse_config("hcl2", `
		module "sql_db" {
			source     = "GoogleCloudPlatform/sql-db/google//modules/mysql"
			db_collation = "utf8mb4_bin"
		}
	`)
	count(violation_db_collation1) == 0 with input as cfg
	count(violation_db_collation2) == 0 with input as cfg
}

# 同じattributeを持つ自作モジュールについてはチェックが行われない
test_violation_db_collation5 if {
	cfg := parse_config("hcl2", `
		module "sql_db" {
			source     = "../mysql"
			db_collation = "utf8_bin"
		}
	`)
	count(violation_db_collation1) == 0 with input as cfg
	count(violation_db_collation2) == 0 with input as cfg
}
