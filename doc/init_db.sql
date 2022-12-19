--create schema claim_schema;

create table claim_schema.claim_status (
	id serial primary key,
	"name" varchar(64) not null,
	start_date date not null,
	end_date date
);
create table claim_schema.channel (
	id serial primary key,
	name varchar(128) not null,
	type varchar(128) not null,
	start_date date not null,
	end_date date
);
create table claim_schema.category (
	id serial primary key,
	name varchar(32) not null,
	type varchar(32) not null,
	start_date date not null,
	end_date date,
	max_duration int not null
);
create table claim_schema.priority(
	id serial primary key,
	name varchar(32) not null,
	start_date date not null,
	end_date date,
	rule text not null
);
create table claim_schema.role(
	id serial primary key,
	name varchar(128) not null,
	description text not null,
	start_date date not null,
	end_date date
);
create table claim_schema.employee (
	id bigserial primary key,
	last_name varchar(32) not null,
	first_name varchar(32) not null,
	middle_name varchar(32) not null,
	position varchar(32) not null,
	deartment varchar(64) not null,
	on_vacation boolean not null,
	is_active boolean not null	
);
create table claim_schema.role_employee (
	role_id int not null,
	employee_id int not null,
	CONSTRAINT "fk_role_employee_role" FOREIGN KEY ("role_id") REFERENCES claim_schema.role("id"),
	CONSTRAINT "fk_role_employee_employee" FOREIGN KEY ("employee_id") REFERENCES claim_schema.employee("id")
);
create table claim_schema.customer(
	id bigserial primary key,
	email varchar(64) not null,
	phone varchar(16) not null,
	employee_id bigint not null,
	type varchar(16) not null,
	CONSTRAINT "fk_customer_employee" FOREIGN KEY ("employee_id") REFERENCES claim_schema.employee("id")
);
create table claim_schema.customer_individual(
	id bigint not null,
	last_name varchar(32) not null,
	first_name varchar(32) not null,
	middle_name varchar(32) not null,
	doc_series varchar(16) not null,
	doc_number varchar(16) not null,
	CONSTRAINT "fk_customer_individual_customer" FOREIGN KEY ("id") REFERENCES claim_schema.customer("id")
);
create table claim_schema.customer_company(
	id bigint not null,
	name varchar(128) not null,
	legal_form varchar(32) not null,
	inn varchar(11) not null,
	CONSTRAINT "fk_customer_company_customer" FOREIGN KEY ("id") REFERENCES claim_schema.customer("id")
);
create table claim_schema.claim (
	id bigserial primary key,
	created timestamp not null,
	message text not null,
	customer_id bigint not null,
	claim_status_id int not null,
	channel_id int not null,
	category_id int not null,
	priority_id int not null,
	employee_id bigint not null,
	CONSTRAINT "fk_claim_customer" FOREIGN KEY ("customer_id") REFERENCES claim_schema.customer("id"),
	CONSTRAINT "fk_claim_claim_status" FOREIGN KEY ("claim_status_id") REFERENCES claim_schema.claim_status("id"),
	CONSTRAINT "fk_claim_channel" FOREIGN KEY ("channel_id") REFERENCES claim_schema.channel("id"),
	CONSTRAINT "fk_claim_categoryr" FOREIGN KEY ("category_id") REFERENCES claim_schema.category("id"),
	CONSTRAINT "fk_claim_priority" FOREIGN KEY ("priority_id") REFERENCES claim_schema.priority("id"),
	CONSTRAINT "fk_claim_employee" FOREIGN KEY ("employee_id") REFERENCES claim_schema.employee("id")
);
create table claim_schema.history(
	id bigserial primary key,
	created timestamp not null,
	changed_field varchar(32) not null,
	old_value text not null,
	new_value text not null,
	claim_id bigint not null,
	employee_id bigint not null,
	claim_status_id int not null,
	CONSTRAINT "fk_history_claim" FOREIGN KEY ("claim_id") REFERENCES claim_schema.claim("id"),
	CONSTRAINT "fk_history_employee" FOREIGN KEY ("employee_id") REFERENCES claim_schema.employee("id"),
	CONSTRAINT "fk_history_status" FOREIGN KEY ("claim_status_id") REFERENCES claim_schema.claim_status("id")
);
create table claim_schema.feedback(
	id bigserial primary key,
	message text not null,
	claim_id bigint not null,
	employee_id bigint not null,
	controller_id bigint not null,
	CONSTRAINT "fk_feedback_claim" FOREIGN KEY ("claim_id") REFERENCES claim_schema.claim("id"),
	CONSTRAINT "fk_feedback_employee" FOREIGN KEY ("employee_id") REFERENCES claim_schema.employee("id"),
	CONSTRAINT "fk_feedback_controller" FOREIGN KEY ("controller_id") REFERENCES claim_schema.employee("id")
);
create table claim_schema.mail(
	id bigserial primary key,
	type varchar(64) not null,
	address varchar(64) not null,
	message text not null,
	claim_id bigint not null,
	CONSTRAINT "fk_mail_claim" FOREIGN KEY ("claim_id") REFERENCES claim_schema.claim("id")
);
create table claim_schema.csi(
	id bigserial primary key,
	message text not null,
	claim_id bigint not null,
	controller_id bigint not null,
	CONSTRAINT "fk_csi_claim" FOREIGN KEY ("claim_id") REFERENCES claim_schema.claim("id"),
	CONSTRAINT "fk_csi_controller" FOREIGN KEY ("controller_id") REFERENCES claim_schema.employee("id")
);
create table claim_schema.result_committee(
	id bigserial primary key,
	amount decimal not null,
	committee text not null,
	claim_id bigint not null,
	CONSTRAINT "fk_result_committee_claim" FOREIGN KEY ("claim_id") REFERENCES claim_schema.claim("id")
);
create table claim_schema.reason(
	id bigserial primary key,
	message text not null,
	claim_id bigint not null,
	CONSTRAINT "fk_reason_claim" FOREIGN KEY ("claim_id") REFERENCES claim_schema.claim("id")
);
create table claim_schema.sd_req_res(
	id bigserial primary key,
	request_message text not null,
	response_message text not null,
	inchedent_num varchar(32) not null,
	status varchar(64) not null,
	employee_id bigint not null,
	CONSTRAINT "fk_sd_req_res_employee" FOREIGN KEY ("employee_id") REFERENCES claim_schema.employee("id")
);
create table claim_schema.mail_req_res(
	id bigserial primary key,
	request_message text not null,
	response_message text not null,
	employee_id bigint not null,
	CONSTRAINT "fk_sd_request_employee" FOREIGN KEY ("employee_id") REFERENCES claim_schema.employee("id")
);
