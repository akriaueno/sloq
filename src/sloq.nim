import math
import md5
import nre
import strformat
import strutils
import sugar
import tables
include ./db_con

type
  Querydetail = ref object
    id: string
    query: string
    times: seq[Timedetail]
    sum_time: float
    sum_time_rate: float
    avg_time: float
  Timedetail = object
    query_time: float
    lock_time: float
  QueryTable = OrderedTable[string, Querydetail]
var
  lines = newSeq[string]()
  i = 0
  queryTable: QueryTable
let
  timeRegex = re"# Time:"
  userHostRegex = re"# User@Host:"
  queryTimeRegex = re".*Query_time:.*(\d+\.\d+).*Lock_time:.*(\d+\.\d+).*"
  queryTimeStampRegex = re"SET timestamp="

while not endOfFile(stdin):
  lines.add(readLine(stdin).strip)

while i < lines.len:
  var
    line = lines[i]
    query: string
  if line.contains(timeRegex):
    discard
  elif line.contains(userHostRegex):
    discard
  elif line.contains(queryTimeRegex):
    let
      q_time = parseFloat(line.match(queryTimeRegex).get.captures[0])
      l_time = parseFloat(line.match(queryTimeRegex).get.captures[1])
    var queries = newSeq[string]()
    while true:
      i += 1
      # TODO: ひどいので修正する
      if i >= lines.len:
        break
      line = lines[i]
      if line.contains(timeRegex): # next query
        i -= 1
        break
      if not line.contains(queryTimeStampRegex):
        queries.add(line)
    query = queries.join(" ")
    let
      id = getMD5(query)
      timeDetail = Timedetail(query_time: q_time, lock_time: l_time)
    if not(id in queryTable):
      let queryDetail = Querydetail(
        id: id,
        query: query,
        times: @[timeDetail],
      )
      queryTable[id] = queryDetail
    else:
      queryTable[id].times.add(timeDetail)
  i += 1
var all_sum_query_times: float = 0
for id, v in queryTable.pairs:
  let
    the_item = queryTable[id]
    query_times = collect(newSeq):
      for timedetail in the_item.times: timedetail.query_time
    sum_query_times = sum(query_times)
    avg_query_times = sum_query_times / float(query_times.len)
  the_item.sum_time = sum_query_times
  the_item.avg_time = avg_query_times
  all_sum_query_times += sum_query_times
for id, v in queryTable.pairs:
  let the_item = queryTable[id]
  the_item.sum_time_rate = the_item.sum_time / all_sum_query_times

queryTable.sort(proc (x, y: (string, Querydetail)): int = cmp(x[1].sum_time, y[1].sum_time))
let sorted_queries = collect(newSeq):
  for key, val in queryTable.pairs: val

proc printQueryDetail(queryDetail: Querydetail): void =
  let
    query = "\e[32m" & queryDetail.query & "\e[m"
    sum_time = fmt"{queryDetail.sum_time: 9.5f}"
    sum_time_rate = fmt"{queryDetail.sum_time_rate: 9.5f}"
    avg_time = fmt"{queryDetail.avg_time: 9.5f}"
    called_times = fmt"{queryDetail.times.len: 8}"
  echo query
  echo fmt"sum:  {sum_time}"
  echo fmt"rate: {sum_time_rate}"
  echo fmt"ave:  {avg_time}"
  echo fmt"called {called_times} times"
  echo "-------"
  echo run_explain(queryDetail.query)
  echo "-------"

printQueryDetail(sorted_queries[sorted_queries.len-1])
printQueryDetail(sorted_queries[sorted_queries.len-2])
printQueryDetail(sorted_queries[sorted_queries.len-3])
printQueryDetail(sorted_queries[0])

close()
