-- все обращения за 2020 год
select *
from claim_schema.claim c
where extract(year from c.created) =2020;


--Кол-во обращений, которые прошли аудит качества
select count(c.id) 
from claim_schema.claim c 
join claim_schema.csi cs on cs.claim_id = c.id ;


--Запрос физиков с кол-вом обращений более 1 и отсортированы по убыванию
select customer_individual.last_name || ' ' || customer_individual.first_name || ' ' || customer_individual.middle_name as "ФИО", count(claim.id) as "Кол-во обращений"
from claim_schema.claim
join claim_schema.customer ON customer.id = claim.customer_id 
join claim_schema.customer_individual on customer_individual.id = customer.id 
group by 1
having count(claim.id) >= 2
order by 2 desc;


--Запрос сотрудников с ролью "ответственный" в разрезе кол-ва обращений 
select e.last_name || ' ' || e.first_name || ' ' || e.middle_name as "ФИО", count(c.id) as "кол-во обращений"
from claim_schema.employee e 
join claim_schema.role_employee re on re.employee_id = e.id 
join claim_schema."role" r on r.id = re.role_id 
join claim_schema.claim c on c.employee_id = e.id
where r.id = 2
group by 1;


--Колличество обращений во всех статусах за последний год
select cs."name", count(c.id)
from claim_schema.claim c
join claim_schema.claim_status cs on cs.id = c.claim_status_id 
where extract(year from c.created) = extract(year from now())
group by 1;


--Обращение с максимальным кол-вом обращений в SD
select e.last_name || ' ' || e.first_name || ' ' || e.middle_name as "ФИО", count(c.id) as "кол-во обращений"
from claim_schema.claim c 
join claim_schema.employee e on c.employee_id = e.id 
join claim_schema.sd_req_res srr on srr.employee_id = e.id
group by 1
order by 2;


--максимальная сумма выплаты возмещения в разрере физ, юр лиц
with max_individ as (
	select ci.id as id, rc.amount 
	from claim_schema.claim c
	join claim_schema.result_committee rc on c.id = rc.claim_id
	join claim_schema.customer cus on cus.id = c.customer_id 
	join claim_schema.customer_individual ci on ci.id = cus.id 
	order by 2 desc
	limit 1
),
max_comp as (
	select cc.id as id, rc.amount 
	from claim_schema.claim c
	join claim_schema.result_committee rc on c.id = rc.claim_id
	join claim_schema.customer cus on cus.id = c.customer_id 
	join claim_schema.customer_company cc on cc.id = cus.id
	order by 2 desc
	limit 1
)
select 
	c.id as "id обращение", 
	cat.name as"категория",
	cus."type" as "Тип клиента",
	case
		when cus.type = 'individual' then ci.last_name || ' ' || ci.first_name || ' ' || ci.middle_name
		when cus.type = 'company' then cc.name
	end as "ФИО/Компания",
	rc.amount as "Сумма возмещения"
from claim_schema.claim c
join claim_schema.result_committee rc on c.id = rc.claim_id
join claim_schema.category cat on cat.id = c.category_id
join claim_schema.customer cus on cus.id = c.customer_id 
left join claim_schema.customer_individual ci on ci.id = cus.id 
left join claim_schema.customer_company cc on cc.id = cus.id 
where cus.id in (select id from max_individ)
or cus.id in (select id from max_comp);
