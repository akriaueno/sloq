import db_mysql
import os
import strformat
import strutils
import nre

let
  db_host = getEnv("DB_HOST", "localhost")
  db_user = getEnv("DB_USER", "user")
  db_password = getEnv("DB_PASSWORD", "password")
  db_name = getEnv("DB_NAME", "name")
  db = db_mysql.open(db_host, db_user, db_password, db_name)

func format_result(explain_query: string, col_names: seq[string], explain_results: seq[string]): string =
  var
    str_col_names: seq[string]
    str_res_values: seq[string]
  for i in 0..col_names.len-1:
    let
      col_name = col_names[i]
      explain_result = explain_results[i]
      max_len = max(@[col_name.len, explain_result.len])
    str_col_names.add(col_name.align(max_len))
    str_res_values.add(explain_result.align(max_len))
  return @[explain_query, str_col_names.join("\t"), str_res_values.join("\t")].join("\n")


proc run_explain(query: string): string =
  let
    select_query_regex = re"SELECT .*"
    str_explain_query = fmt"EXPLAIN {query}"
  if query.match(select_query_regex).isNone():
    return ""
  let
    explain_query = sql(str_explain_query)
    explain_result = db.getRow(explain_query)
  var
    cols: DbColumns  = @[]
    col_names: seq[string]
  for row in db.instantRows(cols, explain_query):
    for col in cols:
      col_names.add(col.name)
  return format_result(str_explain_query, col_names, explain_result)

proc close() =
  db.close()
