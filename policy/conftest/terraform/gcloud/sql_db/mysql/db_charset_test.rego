package conftest.terraform.gcloud.sql_db.mysql

import rego.v1

# db_charsetが定義されていない場合、ルール違反
test_violation_db_charset1 if {
	cfg := parse_config("hcl2", `
    module "sql_db" {
      source = "GoogleCloudPlatform/sql-db/google//modules/mysql"
    }
  `)
	{"severity": "HIGH", "msg": msg_db_charset1} in violation_db_charset1 with input as cfg
}

# db_charsetの値が`utf8mb4`でない場合、ルール違反
test_violation_db_charset2 if {
	cfg := parse_config("hcl2", `
    module "sql_db" {
      source     = "GoogleCloudPlatform/sql-db/google//modules/mysql"
      db_charset = "utf8"
    }
  `)
	{"severity": "HIGH", "msg": msg_db_charset2} in violation_db_charset2 with input as cfg
}

# moduleの名前はルール判定に影響しない(ルールの汎用性をテスト)
test_violation_db_charset3 if {
	cfg := parse_config("hcl2", `
    module "foo_bar" {
      source     = "GoogleCloudPlatform/sql-db/google//modules/mysql"
      db_charset = "utf8"
    }
  `)
	{"severity": "HIGH", "msg": msg_db_charset2} in violation_db_charset2 with input as cfg
}

# db_charsetの値が`utf8mb4`である場合、ルールにパスする
test_violation_db_charset4 if {
	cfg := parse_config("hcl2", `
    module "sql_db" {
      source     = "GoogleCloudPlatform/sql-db/google//modules/mysql"
      db_charset = "utf8mb4"
    }
  `)
	count(violation_db_charset1) == 0 with input as cfg
	count(violation_db_charset2) == 0 with input as cfg
}

# 同じattributeを持つ自作モジュールについてはチェックが行われない
test_violation_db_charset5 if {
	cfg := parse_config("hcl2", `
    module "sql_db" {
      source     = "../mysql"
      db_charset = "utf8"
    }
  `)
	count(violation_db_charset1) == 0 with input as cfg
	count(violation_db_charset2) == 0 with input as cfg
}
