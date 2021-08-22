# sloq
slow query analyzer

(under development (and support only MySQL slow query log))

## Features
- Show slow queries.
- Connect DBMS and execute `EXPLAIN` for slow queries.

## Installation
### Dependency
`libmysqlclient`

### Build
You need to install `nim` to build.([nim official](https://nim-lang.org/))
```bash
sudo apt install default-libmysqlclient-dev
make
```

## Usage
```bash
cat slow.log | DB_USER=root DB_PASSWORD=password DB_NAME=mysql ./bin/sloq
>>>>>> Query
select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no where salaries.salary > 1000;
sum:    6.35708
rate:   0.21049
ave:    6.35708
called        1 times
>>>>>>> Explain
EXPLAIN select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no where salaries.salary > 1000;
id      select_type         table       partitions      type    possible_keys       key key_len                        ref        rows  filtered              Extra
 1           SIMPLE     employees                        ALL          PRIMARY                                                   299290    100.00                   
 1           SIMPLE        titles                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           1    100.00                   
 1           SIMPLE      salaries                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           9     33.33        Using where
-------
>>>>>> Query
select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no  where salaries.salary > 1000;
sum:    6.24718
rate:   0.20685
ave:    6.24718
called        1 times
>>>>>>> Explain
EXPLAIN select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no  where salaries.salary > 1000;
id      select_type         table       partitions      type    possible_keys       key key_len                        ref        rows  filtered              Extra
 1           SIMPLE     employees                        ALL          PRIMARY                                                   299290    100.00                   
 1           SIMPLE        titles                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           1    100.00                   
 1           SIMPLE      salaries                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           9     33.33        Using where
-------
>>>>>> Query
select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no  where salaries.salary > 10000;
sum:    6.21612
rate:   0.20582
ave:    6.21612
called        1 times
>>>>>>> Explain
EXPLAIN select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no  where salaries.salary > 10000;
id      select_type         table       partitions      type    possible_keys       key key_len                        ref        rows  filtered              Extra
 1           SIMPLE     employees                        ALL          PRIMARY                                                   299290    100.00                   
 1           SIMPLE        titles                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           1    100.00                   
 1           SIMPLE      salaries                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           9     33.33        Using where
-------
...
>>>>>> Query
select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no  where salaries.salary > 100000;
sum:    3.25794
rate:   0.10787
ave:    3.25794
called        1 times
>>>>>>> Explain
EXPLAIN select * from employees join salaries on employees.emp_no = salaries.emp_no join titles on employees.emp_no = titles.emp_no  where salaries.salary > 100000;
id      select_type         table       partitions      type    possible_keys       key key_len                        ref        rows  filtered              Extra
 1           SIMPLE     employees                        ALL          PRIMARY                                                   299290    100.00                   
 1           SIMPLE        titles                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           1    100.00                   
 1           SIMPLE      salaries                        ref          PRIMARY   PRIMARY       4 employees.employees.emp_no           9     33.33        Using where
-------
...(Queries)...
>>>>> Query
show databases;
sum:    0.00027
rate:   0.00001
ave:    0.00027
called        1 times
>>>>>>> Explain
No Explain
-------
```
