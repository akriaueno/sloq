import db_mysql
import os
import strformat
import strutils
import nre
import sugar

let
  db_host = getEnv("DB_HOST", "localhost")
  db_user = getEnv("DB_USER", "user")
  db_password = getEnv("DB_PASSWORD", "password")
  db_name = getEnv("DB_NAME", "name")
  db = db_mysql.open(db_host, db_user, db_password, db_name)

proc format_result(explain_query: string, col_names: seq[string],
    explain_results: seq[Row]): string =
  var
    formated_col_names: seq[string]
    formated_res_values: seq[seq[string]] = newSeq[seq[string]](explain_results.len)
  for i in 0..explain_results[0].len-1:
    let
      col_name = col_names[i]
    var
      col_width = col_name.len
    for explain_result in explain_results:
      col_width = max(@[col_width, explain_result[i].len])
    formated_col_names.add(col_name.align(col_width))
    for j, explain_result in explain_results:
      formated_res_values[j].add(explain_result[i].align(col_width))
  let
    str_col_names = formated_col_names.join("\t")
    str_res_values_list = collect(newSeq):
      for res_value in formated_res_values:
        res_value.join("\t")
    str_res_values = str_res_values_list.join("\n")
  return @[explain_query, str_col_names, str_res_values].join("\n")


proc run_explain(query: string): string =
  let
    select_query_regex: Regex = re"(SELECT|select) .*"
  if query.match(select_query_regex).isNone():
    return "No Explain"
  let
    str_explain_query: string = fmt"EXPLAIN {query}"
    explain_query: SqlQuery = sql(str_explain_query)
    explain_results: seq[Row] = db.getAllRows(explain_query)
  var
    cols: DbColumns = @[]
    col_names: seq[string]
  for row in db.instantRows(cols, explain_query):
    for col in cols:
      col_names.add(col.name)
  return format_result(str_explain_query, col_names, explain_results)

proc close() =
  db.close()
