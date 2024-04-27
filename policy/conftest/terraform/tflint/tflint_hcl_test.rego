package conftest.terraform.tflint

import rego.v1

# .tflint.hclにruleブロック自体定義されていない場合、terraform_naming_conventionのルールに違反
test_deny_terraform_naming_convention1 if {
	cfg := parse_config("hcl2", ``)
	{
		"severity": "MEDIUM",
		"msg": msg_terraform_naming_convention("terraform_naming_convention"),
	} in deny_terraform_naming_convention with input as cfg
		with data.conftest.file.name as ".tflint.hcl"
}

# .tflint.hclにterraform_naming_conventionルールは定義されているが値はfalseの場合、terraform_naming_conventionのルールに違反
test_deny_terraform_naming_convention2 if {
	cfg := parse_config("hcl2", `
		rule "terraform_naming_convention" {
			enabled = false
		}
	`)
	{
		"severity": "MEDIUM",
		"msg": msg_terraform_naming_convention("terraform_naming_convention"),
	} in deny_terraform_naming_convention with input as cfg
		with data.conftest.file.name as ".tflint.hcl"
}

# .tflint.hclにterraform_naming_conventionルールがコメントアウトされている場合、terraform_naming_conventionのルールに違反
test_deny_terraform_naming_convention3 if {
	cfg := parse_config("hcl2", `
		# rule "terraform_naming_convention" {
		#     enabled = true
		# }
	`)
	{
		"severity": "MEDIUM",
		"msg": msg_terraform_naming_convention("terraform_naming_convention"),
	} in deny_terraform_naming_convention with input as cfg
		with data.conftest.file.name as ".tflint.hcl"
}

# .tflint.hclにterraform_naming_conventionルールが定義されていてかつ値がtrueの場合、terraform_naming_conventionのルールにパスする
test_deny_terraform_naming_convention4 if {
	cfg := parse_config("hcl2", `
		rule "terraform_naming_convention" {
			enabled = true
		}
	`)
	count(deny_terraform_naming_convention) == 0 with input as cfg
		with data.conftest.file.name as ".tflint.hcl"
}

# .tflint.hclにruleブロック自体定義されていない場合、terraform_comment_syntaxのルールに違反
test_terraform_comment_syntax1 if {
	cfg := parse_config("hcl2", ``)
	{
		"severity": "MEDIUM",
		"msg": msg_terraform_naming_convention("terraform_comment_syntax"),
	} in deny_terraform_comment_syntax with input as cfg
		with data.conftest.file.name as ".tflint.hcl"
}

# .tflint.hclにterraform_comment_syntaxルールは定義されているが値はfalseの場合、terraform_comment_syntaxのルールに違反
test_terraform_comment_syntax2 if {
	cfg := parse_config("hcl2", `
		rule "terraform_comment_syntax" {
			enabled = false
		}
	`)
	{
		"severity": "MEDIUM",
		"msg": msg_terraform_naming_convention("terraform_comment_syntax"),
	} in deny_terraform_comment_syntax with input as cfg
		with data.conftest.file.name as ".tflint.hcl"
}

# .tflint.hclにterraform_comment_syntaxルールが定義されていてかつ値がtrueの場合、terraform_comment_syntaxのルールにパスする
test_terraform_comment_syntax3 if {
	cfg := parse_config("hcl2", `
		rule "terraform_comment_syntax" {
			enabled = true
		}
	`)
	count(deny_terraform_comment_syntax) == 0 with input as cfg
		with data.conftest.file.name as ".tflint.hcl"
}
