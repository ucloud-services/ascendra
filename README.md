# ascendra

SEMPRE utilize um workspace para trabalhar.

```bash
tofu workspace new [WORKSPACE]
tofu workspace list
tofu workspace select [WORKSPACE]
tofu workspace show
```

Ex.:

```bash
tofu workspace new feat/ABC-123
tofu workspace list
tofu workspace select feat/ABC-123
tofu workspace show
```

O arquivo terraform.tfvars precisa conter as seguintes informações:

```text
AWS_AKA="..."
AWS_SKA="..."
```