package conftest.terraform.gcloud.google_storage_bucket

import rego.v1

resource_name := "sample"

# `public_access_prevention`がHCLファイルに定義されていない場合、ルール違反となることを確認
test_no_public_access_prevention if {
	cfg := parse_config("hcl2", sprintf(
		`
    resource "google_storage_bucket" "%v" {
    }`,
		[resource_name],
	))
	{
		"severity": "MEDIUM",
		"msg": msg_public_access_prevention1(resource_name),
	} in deny_public_access_prevention with input as cfg
}

# `#public_access_prevention = "enforced"`のようにコメントアウトされている場合、ルール違反となることを確認
test_comment_out_public_access_prevention if {
	cfg := parse_config("hcl2", sprintf(
		`
    resource "google_storage_bucket" "%v" {
      #public_access_prevention    = "enforced"
    }`,
		[resource_name],
	))
	{
		"severity": "MEDIUM",
		"msg": msg_public_access_prevention1(resource_name),
	} in deny_public_access_prevention with input as cfg
}

# `public_access_prevention = "inherited"`のように意図と違う値が設定されている場合、ルール違反となることを確認
test_public_access_prevention_inherited if {
	public_access_prevention := "inherited"
	cfg := parse_config("hcl2", sprintf(
		`
    resource "google_storage_bucket" "%v" {
      public_access_prevention    = "%v"
    }`,
		[resource_name, public_access_prevention],
	))
	{
		"severity": "MEDIUM",
		"msg": msg_public_access_prevention2(resource_name, public_access_prevention),
	} in deny_public_access_prevention with input as cfg
}

# `public_access_prevention = "enforced"`が設定されている場合、ルールにすべてパスする
test_public_access_prevention_enforced if {
	cfg := parse_config("hcl2", sprintf(
		`
    resource "google_storage_bucket" "%v" {
      public_access_prevention    = "enforced"
    }`,
		[resource_name],
	))
	count(deny_public_access_prevention) == 0 with input as cfg
}
