package conftest.terraform.eol

import rego.v1

# terraform.required_versionが指定されていないファイルは、ルールチェックの対象外なのでルールをパスする
test_warn_required_version1 if {
	cfg := parse_config("hcl2", `
		resource "google_storage_bucket" "example" {
			name          = "example-bucket"
			location      = "ASIA"
			storage_class = "MULTI_REGIONAL"
			versioning {
				enabled = true
			}
			uniform_bucket_level_access = true
			public_access_prevention = "enforced"
		}
	`)
	count(warn_required_version1) == 0 with input as cfg
}

# terraform.required_versionがHashiCorpのサポートバージョン未満の場合、ルール違反
test_warn_required_version2 if {
	cfg := parse_config("hcl2", `
		terraform {
			required_version = "1.6.6"
		}
	`)
	{"severity": "LOW", "msg": msg_required_version1} in warn_required_version1 with input as cfg
}

# terraform.required_versionがHashiCorpのサポートバージョンと同じ場合、ルールをパスする
test_warn_required_version3 if {
	cfg := parse_config("hcl2", sprintf(
		`
		terraform {
			required_version = "%v"
		}
	`,
		[hashicorp_support_verion],
	))
	count(warn_required_version1) == 0 with input as cfg
}

# terraform.required_versionがHashiCorpのサポートバージョンより新しい場合、ルールをパスする
test_warn_required_version4 if {
	cfg := parse_config("hcl2", `
		terraform {
			required_version = "1.7.1"
		}
	`)
	count(warn_required_version1) == 0 with input as cfg
}
