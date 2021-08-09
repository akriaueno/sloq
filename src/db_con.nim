import db_mysql
import os
import strformat

let
  db_host = getEnv("DB_HOST", "localhost")
  db_user = getEnv("DB_USER", "user")
  db_password = getEnv("DB_PASSWORD", "password")
  db_name = getEnv("DB_NAME", "name")
  db = db_mysql.open(db_host, db_user, db_password, db_name)

proc run_explain(query: string): string =
  return db.getRow(sql(fmt"EXPLAIN {query}"))[0]

proc close() =
  db.close()
