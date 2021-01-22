from datetime import time

import psycopg2
from py_linq import Enumerable
from psycopg2.extras import DictConnection, DictCursor

conn = psycopg2.connect(dbname="postgres",
                        user="kotyarich",
                        password="1234",
                        host="localhost",
                        connection_factory=DictConnection,
                        cursor_factory=DictCursor)
cursor = conn.cursor(cursor_factory=DictCursor)

cursor.execute("select * from bd_labs.airports limit 5")
results = cursor.fetchall()

cursor.close()


def task1_way1():
    subquery = "select distinct t1.worker_id " \
               "from times as t1 " \
               "join times as t2 on " \
               "    extract(year from t1.date) = extract(year from t2.date)" \
               "    and extract(week from t1.date) = extract(week from t2.date)" \
               "    and t2.time > '08:00:00' and t2.type = 1 and t1.worker_id = t2.worker_id " \
               "    and t2.date != t1.date " \
               "    and t2.time = (" \
               "        select min(t2in.time) " \
               "        from times as t2in " \
               "        where t2in.worker_id = t2.worker_id and t2in.date = t2.date" \
               "    ) " \
               "join times as t3 on " \
               "    extract(year from t3.date) = extract(year from t2.date)" \
               "    and extract(week from t3.date) = extract(week from t2.date)" \
               "    and t3.time > '08:00:00' and t2.type = 1 and t3.worker_id = t2.worker_id" \
               "    and t3.date != t1.date and t3.date != t2.date" \
               "    and t3.time = (" \
               "        select min(t3in.time) " \
               "        from times as t3in " \
               "        where t3in.worker_id = t3.worker_id and t3in.date = t3.date" \
               "    ) " \
               "where t1.time > '08:00:00' and t1.type = 1 and t1.time = (" \
               "        select min(t1in.time) " \
               "        from times as t1in " \
               "        where t1in.worker_id = t1.worker_id and t1in.date = t1.date" \
               "    ) "

    query = "select distinct department " \
            "from worker " \
            "where id in ({})".format(subquery)

    cursor = conn.cursor(cursor_factory=DictCursor)
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()

    return result


def min_arrival_time(all_t, t):
    return Enumerable(all_t) \
        .where(lambda x: x['worker_id'] == t['worker_id']
                         and x['date'] == t['date']) \
        .min(lambda x: x['time'])


def task1_way2():
    cursor = conn.cursor(cursor_factory=DictCursor)
    cursor.execute("select * from worker")
    workers = Enumerable(cursor.fetchall())

    cursor.execute("select * from times")
    times = cursor.fetchall()
    cursor.close()

    late_rows = [t1['worker_id'] for t1 in times for t2 in times for t3 in times
                 if (t1['worker_id'] == t2['worker_id'] == t3['worker_id']
                     and t1['type'] == t2['type'] == t3['type'] == 1   # если приход на работу
                     and t1['date'] != t2['date'] and t1['date'] != t3['date'] and t2['date'] != t3['date'] # если разные дни
                     and t1['time'] > time(hour=8) and t2['time'] > time(hour=8) and t3['time'] > time(hour=8) # если пришли позже 8
                     and t1['time'] == min_arrival_time(times, t1) 
                     and t2['time'] == min_arrival_time(times, t2)
                     and t3['time'] == min_arrival_time(times, t3))]

    return workers.where(lambda w: w['id'] in late_rows) \
        .select(lambda w: w['department'])


if __name__ == '__main__':
    print(task1_way1())
    print(task1_way2())
