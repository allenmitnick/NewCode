# 1.查找最晚入职员工的所有信息
select emp_no,
       birth_date,
       first_name,
       last_name,
       gender,
       hire_date
from `employees`
order by hire_date desc
limit 1;

# 2.查找入职员工时间排名倒数第三的员工所有信息
select emp_no,
       birth_date,
       first_name,
       last_name,
       gender,
       hire_date
from `employees`
order by hire_date desc
limit 2,1;

# 收获：
# limit一个参数时：指定返回条数
# limit两个参数时：第一个参数表示起点（从0开始），第二个参数表示偏移长度

# 3.查找各个部门当前(to_date='9999-01-01')领导当前薪水详情以及其对应部门编号
select salaries.*, dept_manager.dept_no
from salaries,
     dept_manager
where dept_manager.emp_no = salaries.emp_no
  and dept_manager.to_date = '9999-01-01'
  and salaries.to_date = '9999-01-01';

# 收获：多表连接查询（内连接）表的顺序问题
# from salaries, dept_manager与from dept_manager, salaries的区别
# 固定左表，对应右表中每一行，类似于左表为外循环右表为内循环
select *
from salaries,
     dept_manager
;
select *
from dept_manager,
     salaries
;
# 解析：查找各个部门当前(to_date='9999-01-01')领导当前薪水详情以及其对应部门编号
# ---->各个部门领导薪水详情以及其对应部门编号
# 1.该表是两表关联表，但是元素不能重复出现，需要去重
# 2.该表的字段顺序为，salaries表的所有字段，和部门编号
# 通过查看输出描述发现emp_no是按顺序递增的
# 3.该表的员工编号-emp_no是按顺序递增的，所以在此进行关联时，需要将salaries表置于前面
# 错误：
# from dept_manager,salaries
# 因为多表查询时顺序错误一直不通过

# 4.查找所有已经分配部门的员工的last_name和first_name

select employees.last_name, employees.first_name, dept_emp.dept_no
from dept_emp,
     employees
where dept_emp.emp_no = employees.emp_no;

# 解析：所有已经分配部门的员工
# 就是两边条件同时满足交集（内连接）--两边交集

# 5.查找所有员工的last_name和first_name以及对应部门编号dept_no，也包括展示没有分配具体部门的员工

select employees.last_name, employees.first_name, dept_emp.dept_no
from employees
       left join dept_emp
                 on dept_emp.emp_no = employees.emp_no;

# 解析：查找所有员工包括展示没有分配具体部门的员工
# 就是不需要两边同时满足条件（左外连接）---左表全部以及两边交集

# 6.查找所有员工入职时候的薪水情况，给出emp_no以及salary， 并按照emp_no进行逆序
select salaries.emp_no, salaries.salary
from employees,
     salaries
where employees.emp_no = salaries.emp_no
  and salaries.from_date = employees.hire_date
order by salaries.emp_no desc;

# 解析：员工入职时候的薪水情况
# 入职时候

# 7.查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t
select salaries.emp_no, count(salary) as t
from salaries
group by emp_no
having count(salary) > 15;


# select salaries.emp_no,count(salary) as t
# from salaries
# where salary > 50000
# group by emp_no;

# 收获：group by
# 			根据“By”指定的规则对数据进行分组，
#       所谓的分组就是将一个“数据集”划分成若干个“小区域”，然后针对若干个“小区域”进行数据处理。
# Having与Where的区别
# 1.where 子句的作用是在对查询结果进行分组前，将不符合where条件的行去掉，
# 		即在分组之前过滤数据，where条件中不能包含聚组函数，使用where条件过滤出特定的行。
# 2.having 子句的作用是筛选满足条件的组，
# 		即在分组之后过滤数据，条件中经常包含聚组函数，使用having 条件过滤出特定的组，也可以使用多个分组标准进行分组。
# Having和Where的联合使用方法
# select 类别, SUM(数量)from A
# where 数量 gt;8
# group by 类别
# having SUM(数量) gt; 10
# 总结：
# 当group by 与聚合函数配合使用时，功能为分组后计算
# 当group by 与having配合使用时，功能为分组后过滤
# 当group by 与where配合使用时，功能过滤后分组

# 8.找出所有员工当前(to_date='9999-01-01')具体的薪水salary情况，
# 对于相同的薪水只显示一次,并按照逆序显示
select distinct salary
from salaries
where to_date = '9999-01-01'
order by salary desc;

# 收获：select distinct去除重复数据

# 9.获取所有部门当前manager的当前薪水情况，
# 给出dept_no, emp_no以及salary，当前表示to_date='9999-01-01'

select dept_manager.dept_no, dept_manager.emp_no, salaries.salary
from salaries,
     dept_manager
where dept_manager.emp_no = salaries.emp_no
  and dept_manager.to_date = '9999-01-01'
  and salaries.to_date = '9999-01-01';

# 10.获取所有非manager的员工emp_no

select emp_no
from employees
where emp_no not in (select emp_no from dept_manager);

# employees包括所有员工
# 查询所有管理员no在，再在所有员工中通过where去除管理员

# 11. 获取所有员工当前的manager，如果当前的manager是自己的话结果不显示，
# 		当前表示to_date='9999-01-01'。
# 	结果第一列给出当前员工的emp_no,第二列给出其manager对应的manager_no
select dept_emp.emp_no, dept_manager.emp_no as manager_no
from dept_emp
       left join dept_manager
                 on dept_emp.dept_no = dept_manager.dept_no
where dept_manager.to_date = '9999-01-01'
  and dept_emp.emp_no <> dept_manager.emp_no;

# 12.获取所有部门中当前员工薪水最高的相关信息，给出dept_no, emp_no以及其对应的salary
# 所有部门 员工薪水最高 相关信息dept_no, emp_no以及其对应的salary

select dept_no, dept_emp.emp_no, salary
from dept_emp,
     salaries
where dept_emp.emp_no = salaries.emp_no
  and dept_emp.to_date = '9999-01-01'
group by dept_emp.dept_no
having max(salaries.salary)
;

# 收获：（按部门）分组，分组前按条件当前员工与每位员工的薪水列表
# 分组后按条件过滤只留薪水最高的员工

# 13.从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
select title, count(titles.title) as t
from titles
group by titles.title
having count(titles.title) >= 2;

# 收获：一个列的总数函数是  count
# 求和是sum

# 14.从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
# 		注意对于重复的emp_no进行忽略。

select title, count(DISTINCT emp_no) as t
from titles
group by titles.title
having count(titles.title) >= 2;


select *
from titles
group by emp_no;

# 暂时无法理解

# 15.查找employees表所有emp_no为奇数，且last_name不为Mary的员工信息，并按照hire_date逆序排列
# emp_no为奇数  emp_no % 2 =1
# last_name不为Mary last_name <> 'Mary'
# hire_date逆序 order by hire_date desc;
select *
from employees
where last_name <> 'Mary'
  and emp_no % 2 = 1
order by hire_date desc;

# 16. 统计出当前各个title类型对应的员工当前薪水对应的平均工资。
# 结果给出title以及平均工资avg。
# 各个title对应的员工薪水

select title, avg(salary) as avg
from salaries,
     titles
where salaries.emp_no = titles.emp_no
  and salaries.to_date = '9999-01-01'
  and titles.to_date = '9999-01-01'
group by titles.title;

# 17.获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no以及其对应的薪水salary
select emp_no, salary
from salaries
where to_date = '9999-01-01'
order by salary desc
limit 1,1;

# 18.查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、薪水salary、
# last_name以及first_name，不准使用order by
select salaries.emp_no, salaries.salary, last_name, first_name
from salaries,
     employees
where salaries.emp_no = employees.emp_no
  and salaries.salary = (
  select max(salaries.salary)
  from salaries
  where salary <> (select max(salary) from salaries)
    and salaries.to_date = '9999-01-01'
)
;

# 辅助：
# 查询某列的最大值
select max(salary)
from salaries;

# 除去一个表中的最大值行
select *
from salaries
where salary <> (select max(salary) from salaries);

# 去掉一个最大值剩下的最大值就是第二大的值
select max(salaries.salary)
from salaries
where salary <> (select max(salary) from salaries)
  and salaries.to_date = '9999-01-01';


# 19.查找所有员工的last_name和first_name以及对应的dept_name，也包括暂时没有分配部门的员工
select employees.last_name, employees.first_name, departments.dept_name
from employees
       left join dept_emp on employees.emp_no = dept_emp.emp_no
       left join departments on dept_emp.dept_no = departments.dept_no;

# employees与departments是多对多的关系
# 靠dept_emp中间表维持多对多的关系，中间表里有两个外键分别指向左右表

# 包括暂时没有分配部门的员工表示不是三表交集而是还带有差集用左连接

# 20.查找员工编号emp_no为10001其自入职以来的薪水salary涨幅值growth

select max(salary) - min(salary) as growth
from salaries
where emp_no = 10001
;
#求某列的最大值与最小值差距

# 21.查找所有员工自入职以来的薪水涨幅情况，给出员工编号emp_no以及其对应的薪水涨幅growth，
# 并按照growth进行升序

#   错误写法，但是不知道错在哪里
select salaries.emp_no, max(salary) - min(salary) as growth
from employees,
     salaries
where salaries.emp_no = employees.emp_no
group by salaries.emp_no
order by growth asc;


select a.emp_no, (b.salary - c.salary) as growth
from employees as a
       inner join salaries as b
                  on a.emp_no = b.emp_no and b.to_date = '9999-01-01'
       inner join salaries as c
                  on a.emp_no = c.emp_no and a.hire_date = c.from_date
order by growth asc;


# 22.统计各个部门对应员工涨幅的次数总和，给出部门编码dept_no、部门名称dept_name以及次数sum

select dept_emp.dept_no, dept_name, count(dept_emp.dept_no) as sum
from departments,
     dept_emp,
     salaries
where departments.dept_no = dept_emp.dept_no
  and dept_emp.emp_no = salaries.emp_no
group by dept_emp.dept_no
;

#
# 收获：凡是有group by语句的要多关注select字段
# 因为使用group by 时，
# select 涉及的列要么是分组的依据，要么包含在聚合函数中。

# 思考题？
select *
from departments,
     dept_emp,
     salaries
where departments.dept_no = dept_emp.dept_no
  and dept_emp.emp_no = salaries.emp_no
;

select *
       # select dept_emp.dept_no,dept_name,count(salaries.emp_no) as sum
from departments,
     dept_emp,
     salaries
where departments.dept_no = dept_emp.dept_no
  and dept_emp.emp_no = salaries.emp_no
group by salaries.emp_no;

select *
from departments,
     dept_emp,
     salaries
where departments.dept_no = dept_emp.dept_no
  and dept_emp.emp_no = salaries.emp_no
group by dept_emp.dept_no;

# 问题：一个部门可能有多个员工如果按员工分组并且还有在select中输出部门就会既按员工分组也会部门分组

# 23.对所有员工的当前(to_date='9999-01-01')薪水按照salary进行按照1-N的排名，
# 相同salary并列且按照emp_no升序排列


select *
from salaries as s1,
     salaries as s2
where s1.to_date = "9999-01-01"
  and s2.to_date = "9999-01-01";

select emp_no, salary
from salaries as s1,
     salaries as s2
where to_date = "9999-01-01"
order by salary desc
;

select s1.emp_no, s1.salary, count(distinct s2.salary)
from salaries as s1,
     salaries as s2
where s1.to_date = '9999-01-01'
  and s2.to_date = '9999-01-01'
  and s1.salary <= s2.salary
group by s1.emp_no
order by s1.salary desc, s1.emp_no asc;


# 24.获取所有非manager员工当前的薪水情况，给出dept_no、emp_no以及salary ，
# 当前表示to_date='9999-01-01'

select dept_emp.dept_no, employees.emp_no, salaries.salary
from dept_emp,
     employees,
     salaries
where employees.emp_no = dept_emp.emp_no
  and employees.emp_no = salaries.emp_no
  and employees.emp_no in (
  select emp_no
  from employees
  where emp_no not in (select emp_no from dept_manager))
  and salaries.to_date = '9999-01-01';

# 总结：差集（从一个集合中去除另一个集合）
select emp_no
from employees
where emp_no not in (select emp_no from dept_manager);

# 25.获取员工其当前的薪水比其manager当前薪水还高的相关信息，当前表示to_date='9999-01-01',
# 结果第一列给出员工的emp_no，
# 第二列给出其manager的manager_no，
# 第三列给出该员工当前的薪水emp_salary,
# 第四列给该员工对应的manager当前的薪水manager_salary

# 先查找所有员工及其管理者
select dept_emp.emp_no, dept_manager.emp_no as manager_no
from dept_manager,
     dept_emp
where dept_emp.dept_no = dept_manager.dept_no
  and dept_emp.emp_no <> dept_manager.emp_no;



select t2.emp_no, t2.manager_no, t2.salary, salaries.salary as manager_salary
from (select t1.emp_no, salary, t1.manager_no
      from (select dept_emp.emp_no, dept_manager.emp_no as manager_no
            from dept_manager,
                 dept_emp
            where dept_emp.dept_no = dept_manager.dept_no
              and dept_emp.emp_no <> dept_manager.emp_no) as t1,
           salaries

      where t1.emp_no = salaries.emp_no
        and salaries.to_date = '9999-01-01') as t2,
     salaries
where t2.manager_no = salaries.emp_no
  and salaries.to_date = '9999-01-01'
  and t2.salary > salaries.salary;

# 总结：把查出来的结果作为一个表再去查询
# 先找到所有员工及其管理然后再和工资表连接查询两次

# 26.汇总各个部门当前员工的title类型的分配数目，结果给出部门编号dept_no、dept_name、
# 其当前员工所有的title以及该类型title对应的数目count

select departments.dept_no, dept_name, title, count(title) as count
from departments,
     dept_emp,
     titles
where departments.dept_no = dept_emp.dept_no
  and dept_emp.emp_no = titles.emp_no
  and dept_emp.to_date = '9999-01-01'
  and titles.to_date = '9999-01-01'
group by dept_emp.dept_no, title;

# 总结：group by多个条件
#   分大组，再在里面分小组，依次再分
# 先对第一个条件进行分组分成大组，然后再在大组里对第二个条件进行分组，依次循环

# 27.*给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date以及
# 薪水涨幅值salary_growth，并按照salary_growth逆序排列。
# 提示：在sqlite中获取datetime时间对应的年份函数为strftime('%Y', to_date)

select emp_no, from_date, salary
from salaries
;

# 连表条件是no相同并且年份差别为1

select s1.emp_no, s1.from_date, (s1.salary - s2.salary) as salary_growth
from salaries as s1,
     salaries as s2
where s1.emp_no = s2.emp_no
  and ((strftime('%Y', s1.from_date) - strftime('%Y', s2.from_date) = 1) or
       (strftime('%Y', s1.to_date) - strftime('%Y', s2.to_date) = 1))
  and salary_growth > 5000
order by salary_growth desc;

# 通过格式化日期时间作为连表条件

# 28.查找描述信息中包括robot的电影对应的分类名称以及电影数目，
# # 而且还需要该分类对应电影数量>=5部
# 自己理解：
select category.name, count(category.category_id) as value
from film,
     category,
     film_category
where film.film_id = film_category.film_id
  and category.category_id = film_category.category_id
  and film.description like "%robot%"
group by category.category_id
having count(category.category_id) > 5;

# 答案：
select c.name, count(f.film_id)
from film f,
     category c,
     film_category fc,
     (select category_id from film_category group by category_id having count(film_id) >= 5) as tmp
where f.description like '%robot%'
  and f.film_id = fc.film_id
  and c.category_id = fc.category_id
  and c.category_id = tmp.category_id;


# 29.使用join查询方式找出没有分类的电影id以及名称
# 判断NULL不能用= 而是用is
select film.film_id, film.title
from film
       left join film_category
                 on film.film_id = film_category.film_id
where film_category.film_id is null
;
# MYSQPAN判断是否NULL不能用= 而是用is
# is null

# 30.使用子查询的方式找出属于Action分类的所有电影对应的title,description
select film.title, film.description
from film,
     category,
     film_category
where film.film_id = film_category.film_id
  and category.category_id = film_category.category_id
  and category.category_id = (select category_id from category where name = 'Action');

# 31.获取select * from employees对应的执行计划
# 获取查询执行计划 只需要在查询的SELECT关键字之前增加EXPLAIN这个词。

# id：select查询的序列号，包含一组数字，表示查询中执行select子句或操作表的顺序
# （1）id相同：执行顺序由上至下  1 1 1
# （2）id不同：如果是子查询，id的序号会递增，id值越大优先级越高，越先被执行 1 2 3
# （3）id相同又不同（两种情况同时存在）：id如果相同，可以认为是一组，从上往下顺序执行；在所有组中，
# id值越大，优先级越高，越先执行  1 1 2

# select_type:询的类型，主要是用于区分普通查询、联合查询、子查询等复杂的查询
# 1、SIMPLE：简单的select查询，查询中不包含子查询或者union
# 2、PRIMARY：查询中包含任何复杂的子部分，最外层查询则被标记为primary
# 3、SUBQUERY：在select 或 where列表中包含了子查询
# 4、DERIVED：在from列表中包含的子查询被标记为derived（衍生），mysql或递归执行这些子查询，把结果放在零时表里
# 5、UNION：若第二个select出现在union之后，则被标记为union；若union包含在from子句的子查询中，外层select将被标记为derived
# 6、UNION RESULT：从union表获取结果的select

explain select *
        from employees;

# 32.将employees表的所有员工的last_name和first_name拼接起来作为Name，中间以一个空格区分
# 不知道为什么不对，结果是一样的
#  CONCAT(str1,str2,…)
#   返回结果为连接参数产生的字符串。如有任何一个参数为NULL ，则返回值为 NULL。
select concat(employees.last_name, ' ', employees.first_name) as Name
from employees;


# 运算符 ||
# ||	连接两个不同的字符串，得到一个新的字符串。
select employees.last_name || ' ' || employees.first_name as Name
from employees;

# 33.创建一个actor表，包含如下列信息
# 设置默认日期
# default (datetime('now','localtime'))
create table `actor`
(
  `actor_id`    smallint(5) not null,
  `first_name`  varchar(45) not null,
  `last_name`   varchar(45) not null,
  `last_update` timestamp   not null default now(),
  primary key (`actor_id`)
);

CREATE TABLE actor
(
  actor_id    smallint(5) NOT NULL PRIMARY KEY,
  first_name  varchar(45) NOT NULL,
  last_name   varchar(45) NOT NULL,
  last_update timestamp   NOT NULL default (datetime('now', 'localtime'))
);

# 34.对于表actor批量插入如下数据
CREATE TABLE IF NOT EXISTS actor
(
  actor_id    smallint(5) NOT NULL PRIMARY KEY,
  first_name  varchar(45) NOT NULL,
  last_name   varchar(45) NOT NULL,
  last_update timestamp   NOT NULL DEFAULT now()
);

INSERT INTO actor(actor_id, first_name, last_name, last_update)
VALUES (1, 'PENELOPE', 'GUINESS', '2006-02-15 12:34:33'),
       (2, 'NICK', 'WAHLBERG', '2006-02-15 12:34:33');

# 35.对于表actor批量插入如下数据,如果数据已经存在，请忽略，不使用replace操作
# 避免重复插入问题
# 1.ignore
# INSERT IGNORE INTO 主键值重复则代表记录重复，这样当有重复记录就会忽略,执行后返回数字0
# 2.Replace
# REPLACE INTO REPLACE的运行与INSERT很相像,但是如果旧记录与新记录有相同的值，则在新记录被插入之前，旧记录被删除
INSERT IGNORE INTO actor(actor_id, first_name, last_name, last_update)
VALUES (3, 'ED', 'CHASE', '2006-02-15 12:34:33');

# 有些需要加or
# insert or ignore into actor values (3,'ED','CHASE','2006-02-15 12:34:33');
insert ignore into actor
values (3, 'ED', 'CHASE', '2006-02-15 12:34:33');

# 36.创建一个actor_name表，将actor表中的所有first_name以及last_name导入改表
CREATE TABLE actor_name
(
  first_name VARCHAR(45) NOT NULL comment '名字',
  last_name  VARCHAR(45) NOT NULL comment '姓氏'
);

INSERT INTO actor_name(first_name, last_name)
SELECT first_name, last_name
FROM actor;

# 将一个表中的值插入到另一个表
#insert into b(col1,col2,col3,...) select col1,col2,col3,,... from a where...
# # 正常插入    INSERT INTO table VALUES();
# # 查出值插入  INSERT INTO table SELECT * FROM *;

# 37.对first_name创建唯一索引uniq_idx_firstname，对last_name创建普通索引idx_lastname
CREATE TABLE IF NOT EXISTS actor
(
  actor_id    smallint(5) NOT NULL PRIMARY KEY,
  first_name  varchar(45) NOT NULL,
  last_name   varchar(45) NOT NULL,
  last_update timestamp   NOT NULL DEFAULT NOW()
);

# 第一种创建时添加索引
CREATE TABLE IF NOT EXISTS actor
(
  actor_id    smallint(5) NOT NULL PRIMARY KEY,
  first_name  varchar(45) NOT NULL,
  last_name   varchar(45) NOT NULL,
  last_update timestamp   NOT NULL DEFAULT NOW(),
  #创建唯一性索引
  UNIQUE INDEX `uniq_idx_firstname` (`first_name`),
  #创建普通索引
  INDEX `idx_lastname` (`last_name`)
);

# 创建索引：
# 创建唯一索引：
# UNIQUE INDEX `uniq_idx_firstname`(`first_name`)
# 创建普通索引
# INDEX `idx_lastname`(`last_name`)

# 完整创建表
# CREATE TABLE 表名(字段名 数据类型 [完整性约束条件],
#                   [UNIQUE | FULLTEXT | SPATIAL] INDEX | KEY
#                   [索引名](字段名1 [(长度)] [ASC | DESC])
# );

# 第二种修改表添加索引
ALTER TABLE actor
  ADD UNIQUE INDEX uniq_idx_firstname (first_name);
ALTER TABLE actor
  ADD INDEX idx_lastname (last_name);

#第三种直接创建索引
CREATE UNIQUE INDEX uniq_idx_firstname ON actor (first_name);
CREATE INDEX idx_lastname ON actor (last_name);

# 第二种与第三种创建索引的区别：
# 1、alter table一次可以添加多个索引，create index一次只能创建一个。
# 创建多个索引时，alter table只对表扫描一次，效率较高。
# 2、alter table可以不指定索引名，此时将使用索引列的第一列的列名；
# create index必须指定索引名。


# 38.针对actor表创建视图actor_name_view，只包含first_name以及last_name两列，并对这两列
# 重新命名，first_name为first_name_v，last_name修改为last_name_v：

#   视图
# 视图可以说是一种虚拟表，建立在基本表的基础上，通过关联一个表或者多个表来获取多个表中需要的
# 字段，视图只是用来查询数据并不能用来存储数据信息。
# (1).第一类：create view v as select * from table;
#
# (2).第二类：create view v as select id,name,age from table;
#
# (3).第三类：create view v[vid,vname,vage] as select id,name,age from table;
CREATE TABLE IF NOT EXISTS actor
(
  actor_id    smallint(5) NOT NULL PRIMARY KEY,
  first_name  varchar(45) NOT NULL,
  last_name   varchar(45) NOT NULL,
  last_update timestamp   NOT NULL DEFAULT now()
);

# 创建视图并重命名列
create view actor_name_view as
select first_name as first_name_v, last_name as last_name_v
from actor;

# 查看视图的数据
select *
from actor_name_view;
# 删除视图  drop view actior_name_view;
drop view if exists actior_name_view;

# 39.针对salaries表emp_no字段创建索引idx_emp_no，查询emp_no为10005, 使用强制索引

CREATE TABLE `salaries`
(
  `emp_no`    int(11) NOT NULL,
  `salary`    int(11) NOT NULL,
  `from_date` date    NOT NULL,
  `to_date`   date    NOT NULL,
  PRIMARY KEY (`emp_no`, `from_date`)
);
create index idx_emp_no on salaries (emp_no);
# 强制索引和禁止索引
# force index(索引名或者主键PRI)
# ignore index(索引名或者主键PRI)
# select * from table force index(ziduan1_index);
# sqlLite 使用 indexed by 进行强制索引
# mysql 使用 force index 进行强制索引

select *
from salaries force index (idx_emp_no)
where emp_no = 10005;

# 40.现在在last_update后面新增加一列名字为create_date,
# 类型为datetime, NOT NULL，默认值为'0000 00:00:00'
CREATE TABLE IF NOT EXISTS actor
(
  actor_id    smallint(5) NOT NULL PRIMARY KEY,
  first_name  varchar(45) NOT NULL,
  last_name   varchar(45) NOT NULL,
  last_update timestamp   NOT NULL DEFAULT (datetime('now', 'localtime'))
);

alter table actor
  add column `create_date` datetime not null default '0000-00-00 00:00:00';

# 41. 构造一个触发器audit_log，在向employees_test表中插入一条数据的时候，
# 触发插入相关的数据到audit中。
CREATE TABLE IF NOT EXISTS employees_test
(
  ID      INT PRIMARY KEY NOT NULL,
  NAME    TEXT            NOT NULL,
  AGE     INT             NOT NULL,
  ADDRESS CHAR(50),
  SALARY  REAL
);
CREATE TABLE audit
(
  EMP_no INT  NOT NULL,
  NAME   TEXT NOT NULL
);

# 向employees_test表中插入一条数据的时候，触发插入相关的数据到audit中
CREATE TRIGGER `audit`
  AFTER INSERT
  ON `employees_test`
  FOR EACH ROW
begin
  insert into audit(EMP_no, NAME) VALUES (NEW.ID, NEW.NAME);
end;

# 触发器：
# CREATE TRIGGER trigger_name
# trigger_time
# trigger_event ON tbl_name
# FOR EACH ROW
# trigger_stmt

# 其中：
# trigger_name：标识触发器名称，用户自行指定；
# trigger_time：标识触发时机，取值为 BEFORE 或 AFTER；
# trigger_event：标识触发事件，取值为 INSERT、UPDATE 或 DELETE；
# tbl_name：标识建立触发器的表名，即在哪张表上建立触发器；
# trigger_stmt：触发器程序体，可以是一句SQL语句，或者用 BEGIN 和 END 包含的多条语句。
# 由此可见，可以建立6种触发器，即：BEFORE INSERT、BEFORE UPDATE、BEFORE DELETE、AFTER INSERT、AFTER UPDATE、AFTER DELETE。
# 另外有一个限制是不能同时在一个表上建立2个相同类型的触发器，因此在一个表上最多建立6个触发器。

# 42.删除emp_no重复的记录，只保留最小的id对应的记录。

CREATE TABLE IF NOT EXISTS titles_test
(
  id        int(11)     not null primary key,
  emp_no    int(11)     NOT NULL,
  title     varchar(50) NOT NULL,
  from_date date        NOT NULL,
  to_date   date DEFAULT NULL
);
insert into titles_test
values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
       ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
       ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
       ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
       ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
       ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
       ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

DELETE
FROM titles_test
WHERE id not in
      (SELECT MIN(id) FROM titles_test GROUP BY emp_no);

# 先查出同emp_no条件下最小的一条记录
# SELECT MIN(id) FROM titles_test GROUP BY emp_no
# 然后用not in排查

# where子句 可以包含以下运算符
# =，!=，>，<，>=，<=，BETWEEN … AND …，NOT BETWEEN …AND …，%
# IN，NOT IN，LIKE，NOT LIKE，IS NULL，IS NOT NULL，NOT，AND，OR
# !=  值        等不等于
# not in 集合   属不属于 not in的结果集中出现null则查询结果为null;

# 43.将所有to_date为9999-01-01的全部更新为NULL,且 from_date更新为2001-01-01。
CREATE TABLE IF NOT EXISTS titles_test
(
  id        int(11)     not null primary key,
  emp_no    int(11)     NOT NULL,
  title     varchar(50) NOT NULL,
  from_date date        NOT NULL,
  to_date   date DEFAULT NULL
);
insert into titles_test
values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
       ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
       ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
       ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
       ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
       ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
       ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

UPDATE titles_test
SET to_date   = NULL,
    from_date = '2001-01-01'
WHERE to_date = '9999-01-01';

# 注意：update同时更新多个条件是用,隔开而不是and运算符
# UPDATE [LOW_PRIORITY] [IGNORE] tbl_name
#     SET col_name1=expr1 [, col_name2=expr2 ...]
#     [WHERE where_definition]
#     [ORDER BY ...]
#     [LIMIT row_count]

# 44.将id=5以及emp_no=10001的行数据替换成id=5以及emp_no=10005,其他数据保持不变，使用replace实现。
CREATE TABLE IF NOT EXISTS titles_test
(
  id        int(11)     not null primary key,
  emp_no    int(11)     NOT NULL,
  title     varchar(50) NOT NULL,
  from_date date        NOT NULL,
  to_date   date DEFAULT NULL
);

insert into titles_test
values ('1', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
       ('2', '10002', 'Staff', '1996-08-03', '9999-01-01'),
       ('3', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01'),
       ('4', '10004', 'Senior Engineer', '1995-12-03', '9999-01-01'),
       ('5', '10001', 'Senior Engineer', '1986-06-26', '9999-01-01'),
       ('6', '10002', 'Staff', '1996-08-03', '9999-01-01'),
       ('7', '10003', 'Senior Engineer', '1995-12-03', '9999-01-01');

# 替换某列的值（前提知道某列也知道值是多少）
# replace()函数
# REPLACE(str,from_str,to_str)
# 案例：将表 tb1里面的 f1字段的abc替换为def
# UPDATE tb1 SET f1=REPLACE(f1, 'abc', 'def');

update titles_test
set emp_no=replace(emp_no, '10001', '10005')
where id = 5;

# 45.将titles_test表名修改为titles_2017
# 修改表名
alter table titles_test rename titles_2017;
alter table titles_test rename to titles_2017;

# 修改表常见操作：
# CREATE TABLE `person` (
#   `number` int(11) DEFAULT NULL,
#   `name` varchar(255) DEFAULT NULL,
#   `birthday` date DEFAULT NULL
# );
# 删除列：ALTER TABLE person DROP COLUMN birthday;
# 添加列：ALTER TABLE person ADD COLUMN birthday datetime;
# 修改列,把number修改为bigint：
#   ALTER TABLE person MODIFY number BIGINT NOT NULL;
# 把number修改为id,类型为bigint:
#   ALTER TABLE person CHANGE number id BIGINT;
# 修改表名：alter table tb1 rename  <to> tb2;
# 移动表到其他数据库：RENAME TABLE current_db.tbl_name TO other_db.tbl_name;
# 改变一个表的默认字符集：ALTER TABLE person DEFAULT CHARACTER SET utf8;

# 46.在audit表上创建外键约束，其emp_no对应employees_test表的主键id。
CREATE TABLE employees_test
(
  ID      INT PRIMARY KEY NOT NULL,
  NAME    TEXT            NOT NULL,
  AGE     INT             NOT NULL,
  ADDRESS CHAR(50),
  SALARY  REAL
);

CREATE TABLE audit
(
  EMP_no      INT      NOT NULL,
  create_date datetime NOT NULL
);

# 修改表添加外键约束(指定外键名)：
alter table audit
  add constraint fk_audit foreign key (`EMP_no`) references `employees_test` (`id`);

# 修改表解除外键约束：
alter table audit
  drop foreign key fk_audit;

# 修改表添加外键约束(不指定外键名会自动添加默认名字)：
alter table audit
  add foreign key (`EMP_no`) references `employees_test` (`id`);

drop table audit;
create table audit
(
  emp_no      int      not null,
  create_date datetime not null,
  foreign key (emp_no) references employees_test (id)
);

# 一般列名要加括号

# 47.存在如下的视图：
# create view emp_v as select * from employees where emp_no >10005;
# 如何获取emp_v和employees有相同的数据？

create view emp_v as
select *
from employees
where emp_no > 10005;


# 数据库对两个或多个结果集进行合并、取重、剔除操作
#  使用前提条件
# 所有查询中的列数和列的顺序必须相同.
# 数据类型必须兼容.
# 并且它们都是处理于多个结果集中有重复数据的问题

# [SQL语句 1]
# INTERSECT |UNION |EXCEPT
# [SQL语句 2];

# 交集 INTERSECT：删除两个集合中的重复行，返回只有在两个集合中都出现的行
#   --先将其中完全重复的数据行删除，再对两个查询结果集取其交集
# select tName,tSex from teacher
# intersect
# select sName,sSex from student
# 并集 UNION
#   --UNION合并两个查询结果集，并且将其中完全重复的数据行合并为一条
# select tName,tSex from teacher
# union
# select sName,sSex from student
#   --UNION ALL合并两个查询结果集，返回所有数据，不会去掉重复的数据
# select tName,tSex from teacher
# union all
# select sName,sSex from student


#差集EXCEPT：先将其中完全重复的数据行删除，再返回只在第一个集合中出现，在第二个集合中不出现的所有行。
# select tName,tSex from teacher
# except
# select sName,sSex from student
create view emp_v as
select *
from employees
where emp_no > 10005;

select *
from emp_v INTERSECT
select *
from employees
where emp_no > 10005;

# 48.将所有获取奖金的员工当前的薪水增加10%。
create table emp_bonus
(
  emp_no   int      not null,
  recevied datetime not null,
  btype    smallint not null
);

CREATE TABLE `salaries`
(
  `emp_no`    int(11) NOT NULL,
  `salary`    int(11) NOT NULL,
  `from_date` date    NOT NULL,
  `to_date`   date    NOT NULL,
  PRIMARY KEY (`emp_no`, `from_date`)
);

update salaries
set salary = salary * 1.1
where emp_no in (select emp_no from emp_bonus)
  and to_date = '9999-01-01';

# 49.针对库中的所有表生成select count(*)对应的SQL语句
SELECT "select count(*) from " || NAME || ";" AS cnts
FROM sqlite_master
WHERE type = 'table';

# 50.将employees表中的所有员工的last_name和first_name通过(')连接起来。

# 不用函数
select last_name || "'" || first_name as name
from employees;

# 使用函数
select concat_ws('\'', last_name, first_name) as name
from employees;

select concat(last_name, '\'', first_name) as name
from employees;

# CONCAT_WS() 代表 CONCAT With Separator ，是CONCAT()的特殊形式。
# 第一个参数是其它参数的分隔符。

# 51.查找字符串'10,A,B' 中逗号','出现的次数cnt。

select length('1,2,3'); #5

SELECT (length("10,A,B") - length(replace("10,A,B", ",", ""))) / length(",") AS cnt;

# 字符串常见函数：
# 【sql的字符串下标从1-length(str)】
select left('17826076212', 3); #取字符转左边几位
select right('17826076212', 3); #取字符转右边几位
select concat('178', '***', '6212'); #拼接字符串
select format('2.3424', 2); #格式化字符串,可以用来限定小数位。最后一位四舍五入
SELECT LOWER('RUNOOB'); #转化为小写
select UPPER('hyt'); #转化为大写
SELECT TRIM("    RUNOOB  "); #去除字符串前后空格
SELECT LPAD('abc', 6, 'xx'); #用xx填充字符串abc，使其长度为6（在字符串开头填充）
SELECT MID("RUNOOB", 2, 3); #从字符串 RUNOOB 中的第 2 个位置截取 3个 字符(从1开始)
SELECT REPLACE('abc', 'a', 'x'); #将字符串 abc 中的字符 a 替换为字符 x
SELECT REVERSE('abc');
#将字符串 abc 的顺序反过来

# substr(X,Y,Z) x是字符串，y是起始位置，z是长度
# substr(X,Y) x是字符窜，y是起始位置，选择的是从y向后的字符串(默认到最后)
# 52.获取Employees中的first_name，查询按照first_name最后两个字母，按照升序进行排列

select employees.first_name
from employees
order by right(first_name, 2) asc;

select employees.first_name
from employees
order by substr(first_name, length(first_name) - 1) asc;

# 53.按照dept_no进行汇总，属于同一个部门的emp_no按照逗号进行连接，结果给出dept_no以及连接出
# 的结果employees

# 分组后拼接：group_concat
# group_concat([DISTINCT] 要连接的字段 [Order BY ASC/DESC 排序字段] [Separator ‘分隔符’])
# 不写分隔符默认是逗号 ,

select dept_no, group_concat(emp_no)
from dept_emp
group by dept_no;

# 54.查找排除当前最大、最小salary之后的员工的平均工资avg_salary
# 去除最大值，最小值求平均值
# avg() 求平均值函数
# 排除某个（些）值，可以用not in

select (sum(salary) - max(salary) - min(salary)) / count(salary) as avg_salary
from salaries
where to_date = '9999-01-01';

select avg(salary) as avg_salary
from salaries
where salary not in (select max(salary) from salaries)
  and salary not in (select min(salary) from salaries)
  and to_date = '9999-01-01';

# 55.分页查询employees表，每5行一页，返回第2页的数据
select *
from employees
limit 5,5;

# limit用法：
# LIMIT [offset,] rows | rows OFFSET offset
# 两个参数：第一个参数指定第一个返回记录行的偏移量，第二个参数指定返回记录行的最大数目。
# 初始记录行的偏移量是 0(而不是 1)
# 一个参数：返回记录的数目

# 56.获取所有员工的emp_no、部门编号dept_no以及对应的emp_bonus类型btype和recevied，
# 没有分配具体的员工不显示

select t1.emp_no, t1.dept_no, btype, recevied
from (select dept_emp.emp_no, dept_emp.dept_no
      from dept_emp,
           employees
      where dept_emp.emp_no = employees.emp_no) as t1
       left join emp_bonus
                 on t1.emp_no = emp_bonus.emp_no;

# 先查询出所有已经分配部门的员工，然后再查询

# 57.使用含有关键字exists查找未分配具体部门的员工的所有信息。
select *
from employees
where not exists(select emp_no from dept_emp where employees.emp_no = dept_emp.emp_no);

# exists
# exists语句是对外表作loop循环，每次loop循环再对内表进行查询。
# 使用存在量词EXISTS后，若内层查询结果为非空，则外层的WHERE子句返回值为真，否则返回值为假。

# 58.存在如下的视图：
# create view emp_v as select * from employees where emp_no >10005;
# 获取employees中的行数据，且这些行也存在于emp_v中。注意不能使用intersect关键字。
select emp_v.*
from emp_v,
     employees
where emp_v.emp_no = employees.emp_no;

# 视图和表可以连表查询

# 59.获取有奖金的员工相关信息。
# 给出emp_no、first_name、last_name、奖金类型btype、对应的当前薪水情况salary以及
# 奖金金额bonus。 bonus类型btype为1其奖金为薪水salary的10%，btype为2其奖金为薪水
# 的20%，其他类型均为薪水的30%。 当前薪水表示to_date='9999-01-01'

select emp_bonus.emp_no,
       employees.first_name,
       employees.last_name,
       emp_bonus.btype,
       salaries.salary,
       salary * btype * 0.1 as bonus
from salaries,
     emp_bonus,
     employees
where salaries.emp_no = emp_bonus.emp_no
  and employees.emp_no = salaries.emp_no
  and salaries.to_date = '9999-01-01';


select e.emp_no,
       e.first_name,
       e.last_name,
       eb.btype,
       s.salary,
       (case eb.btype
          when 1 then s.salary * 0.1
          when 2 then s.salary * 0.2
          else s.salary * 0.3 end) as bonus
from employees e
       inner join emp_bonus eb on e.emp_no = eb.emp_no
       inner join salaries s on e.emp_no = s.emp_no
where s.to_date = '9999-01-01';

# (case eb.btype
#           when 1 then s.salary * 0.1
#           when 2 then s.salary * 0.2
#           else s.salary * 0.3 end)

# 60.按照salary的累计和running_total，其中running_total为前两个员工的salary累计和，
# 其他以此类推。
select a.emp_no, a.salary, sum(b.salary) running_total
from salaries as a,
     salaries as b
where b.emp_no <= a.emp_no
  and a.to_date = '9999-01-01'
  and b.to_date = '9999-01-01'
group by a.emp_no
order by a.emp_no asc;

# 61.对于employees表中，给出奇数行的first_name


SELECT e1.first_name
FROM employees e1
WHERE (SELECT count(*)
       FROM employees e2
       WHERE e1.first_name <= e2.first_name) % 2 = 1;
# 计算行号的方法 : 有多少个小于等于e2.first_name的记录的个数就是e2.first_name的行号
