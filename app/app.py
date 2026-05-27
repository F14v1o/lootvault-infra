import os
import sys

print("=== LootVault Game Server Booting Up ===")

# Simulate reading configuration values from the environment variables
db_host = os.getenv("DB_HOST", "NOT_CONFIGURED")
s3_bucket = os.getenv("S3_BUCKET", "NOT_CONFIGURED")

if db_host == "NOT_CONFIGURED" or s3_bucket == "NOT_CONFIGURED":
    print("ERROR: Application environment variables are missing!")
    sys.exit(1)

print("#1")
print("#2")
print("=== LootVault System Status: READY AND ONLINE ===")
