import db_mysql
import os
import strformat
import strutils

let
  db_host = getEnv("DB_HOST", "localhost")
  db_user = getEnv("DB_USER", "user")
  db_password = getEnv("DB_PASSWORD", "password")
  db_name = getEnv("DB_NAME", "name")
  db = db_mysql.open(db_host, db_user, db_password, db_name)

func format_result(explain_query: string, col_names: seq[string], res_values: seq[string]): string =
  var
    str_col_names: seq[string]
    str_res_values: seq[string]
  for i in 0..col_names.len-1:
    let
      col_name = col_names[i]
      res_value = res_values[i]
      max_len = max(@[col_name.len, res_value.len])
    str_col_names.add(col_name.align(max_len))
    str_res_values.add(res_value.align(max_len))
  return @[explain_query, str_col_names.join("\t"), str_res_values.join("\t")].join("\n")


proc run_explain(query: string): string =
  let
    str_explain_query = fmt"EXPLAIN {query}"
    explain_query = sql(str_explain_query)
    res_values = db.getRow(explain_query)
  var
    cols: DbColumns  = @[]
    col_names: seq[string]
  for row in db.instantRows(cols, explain_query):
    for col in cols:
      col_names.add(col.name)
  return format_result(str_explain_query, col_names, res_values)

proc close() =
  db.close()
