set shell := ["bash", "-c"]

# デフォルトタスク
default:
	@just --list

# ドキュメントのリンク切れチェック (lychee を使用)
check-docs:
	@echo "Running document link checks..."
	lychee "./**/*.md" --offline --no-progress
