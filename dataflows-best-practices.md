# Dataflows Best Practices
- folder structure
  - extract
  - transform
  - load
- parameterize the queries for better testing against non-production environments
- load queries schema matches the destination table schema
- alternate keys are properly set (even if not used)
- delete refresh history