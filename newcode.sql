select *
from `employees`;
# 查找最晚入职员工的所有信息
select emp_no,
       birth_date,
       first_name,
       last_name,
       gender,
       hire_date
from `employees`
order by hire_date desc
limit 1;

# 1.查找入职员工时间排名倒数第三的员工所有信息
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

# 2.查找各个部门当前(to_date='9999-01-01')领导当前薪水详情以及其对应部门编号
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

# 3.查找所有已经分配部门的员工的last_name和first_name

select employees.last_name, employees.first_name, dept_emp.dept_no
from dept_emp,
     employees
where dept_emp.emp_no = employees.emp_no;

# 解析：所有已经分配部门的员工
# 就是两边条件同时满足交集（内连接）--两边交集

# 4.查找所有员工的last_name和first_name以及对应部门编号dept_no，也包括展示没有分配具体部门的员工

select employees.last_name, employees.first_name, dept_emp.dept_no
from employees
       left join dept_emp
                 on dept_emp.emp_no = employees.emp_no;

# 解析：查找所有员工包括展示没有分配具体部门的员工
# 就是不需要两边同时满足条件（左外连接）---左表全部以及两边交集

# 5.查找所有员工入职时候的薪水情况，给出emp_no以及salary， 并按照emp_no进行逆序
select salaries.emp_no, salaries.salary
from employees,
     salaries
where employees.emp_no = salaries.emp_no
  and salaries.from_date = employees.hire_date
order by salaries.emp_no desc;

# 解析：员工入职时候的薪水情况
# 入职时候

# 6.查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t
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

# 7.找出所有员工当前(to_date='9999-01-01')具体的薪水salary情况，
# 对于相同的薪水只显示一次,并按照逆序显示
select distinct salary
from salaries
where to_date = '9999-01-01'
order by salary desc;

# 收获：select distinct去除重复数据

# 8.获取所有部门当前manager的当前薪水情况，
# 给出dept_no, emp_no以及salary，当前表示to_date='9999-01-01'

select dept_manager.dept_no, dept_manager.emp_no, salaries.salary
from salaries,
     dept_manager
where dept_manager.emp_no = salaries.emp_no
  and dept_manager.to_date = '9999-01-01'
  and salaries.to_date = '9999-01-01';

# 9.获取所有非manager的员工emp_no

select emp_no
from employees
where emp_no not in (select emp_no from dept_manager);

# employees包括所有员工
# 查询所有管理员no在，再在所有员工中通过where去除管理员

# 10. 获取所有员工当前的manager，如果当前的manager是自己的话结果不显示，
# 		当前表示to_date='9999-01-01'。
# 	结果第一列给出当前员工的emp_no,第二列给出其manager对应的manager_no
select dept_emp.emp_no, dept_manager.emp_no as manager_no
from dept_emp
       left join dept_manager
                 on dept_emp.dept_no = dept_manager.dept_no
where dept_manager.to_date = '9999-01-01'
  and dept_emp.emp_no <> dept_manager.emp_no;

# 11.获取所有部门中当前员工薪水最高的相关信息，给出dept_no, emp_no以及其对应的salary
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

# 12.从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
select title, count(titles.title) as t
from titles
group by titles.title
having count(titles.title) >= 2;

# 收获：一个列的总数函数是  count
# 求和是sum

# 13.从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
# 		注意对于重复的emp_no进行忽略。

select title, count(DISTINCT emp_no) as t
from titles
group by titles.title
having count(titles.title) >= 2;


select *
from titles
group by emp_no;

# 暂时无法理解

# 14.查找employees表所有emp_no为奇数，且last_name不为Mary的员工信息，并按照hire_date逆序排列
# emp_no为奇数  emp_no % 2 =1
# last_name不为Mary last_name <> 'Mary'
# hire_date逆序 order by hire_date desc;
select *
from employees
where last_name <> 'Mary'
  and emp_no % 2 = 1
order by hire_date desc;

# 15. 统计出当前各个title类型对应的员工当前薪水对应的平均工资。
# 结果给出title以及平均工资avg。
# 各个title对应的员工薪水

select title, avg(salary) as avg
from salaries,
     titles
where salaries.emp_no = titles.emp_no
  and salaries.to_date = '9999-01-01'
  and titles.to_date = '9999-01-01'
group by titles.title;

# 16.获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no以及其对应的薪水salary
select emp_no, salary
from salaries
where to_date = '9999-01-01'
order by salary desc
limit 1,1;

# 17.查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、薪水salary、
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
where salary <> (select max(salary) from salaries)

# 去掉一个最大值剩下的最大值就是第二大的值
select max(salaries.salary)
from salaries
where salary <> (select max(salary) from salaries)
  and salaries.to_date = '9999-01-01'


# 18.查找所有员工的last_name和first_name以及对应的dept_name，也包括暂时没有分配部门的员工
select employees.last_name, employees.first_name, departments.dept_name
from employees
       left join dept_emp on employees.emp_no = dept_emp.emp_no
       left join departments on dept_emp.dept_no = departments.dept_no;

# employees与departments是多对多的关系
# 靠dept_emp中间表维持多对多的关系，中间表里有两个外键分别指向左右表

# 包括暂时没有分配部门的员工表示不是三表交集而是还带有差集用左连接

# 19.查找员工编号emp_no为10001其自入职以来的薪水salary涨幅值growth

select max(salary) - min(salary) as growth
from salaries
where emp_no =10001
;
#求某列的最大值与最小值差距

# 20.查找所有员工自入职以来的薪水涨幅情况，给出员工编号emp_no以及其对应的薪水涨幅growth，
# 并按照growth进行升序

#   错误写法，但是不知道错在哪里
select salaries.emp_no, max(salary) - min(salary) as growth
from employees,salaries
where salaries.emp_no = employees.emp_no
group by salaries.emp_no
order by growth asc;




