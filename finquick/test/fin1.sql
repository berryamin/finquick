PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE gnclock ( Hostname varchar(255), PID int );
INSERT INTO "gnclock" VALUES('pav',13268);
CREATE TABLE versions (table_name text(50) PRIMARY KEY NOT NULL, table_version integer NOT NULL);
INSERT INTO "versions" VALUES('Gnucash',2041000);
INSERT INTO "versions" VALUES('Gnucash-Resave',19920);
INSERT INTO "versions" VALUES('accounts',1);
INSERT INTO "versions" VALUES('books',1);
INSERT INTO "versions" VALUES('budgets',1);
INSERT INTO "versions" VALUES('budget_amounts',1);
INSERT INTO "versions" VALUES('commodities',1);
INSERT INTO "versions" VALUES('lots',2);
INSERT INTO "versions" VALUES('prices',2);
INSERT INTO "versions" VALUES('schedxactions',1);
INSERT INTO "versions" VALUES('transactions',3);
INSERT INTO "versions" VALUES('splits',4);
INSERT INTO "versions" VALUES('billterms',2);
INSERT INTO "versions" VALUES('customers',2);
INSERT INTO "versions" VALUES('employees',2);
INSERT INTO "versions" VALUES('entries',3);
INSERT INTO "versions" VALUES('invoices',3);
INSERT INTO "versions" VALUES('jobs',1);
INSERT INTO "versions" VALUES('orders',1);
INSERT INTO "versions" VALUES('taxtables',2);
INSERT INTO "versions" VALUES('taxtable_entries',3);
INSERT INTO "versions" VALUES('vendors',1);
INSERT INTO "versions" VALUES('recurrences',1);
INSERT INTO "versions" VALUES('slots',3);
CREATE TABLE accounts (guid text(32) PRIMARY KEY NOT NULL, name text(2048) NOT NULL, account_type text(2048) NOT NULL, commodity_guid text(32), commodity_scu integer NOT NULL, non_std_scu integer NOT NULL, parent_guid text(32), code text(2048), description text(2048), hidden integer, placeholder integer);
INSERT INTO "accounts" VALUES('4b1541673b2df412263bf6888043a6f8','Root Account','ROOT',NULL,0,0,NULL,'','',0,0);
INSERT INTO "accounts" VALUES('6520e1fa04f2ab7fcdcfac74bc828d70','Assets','ASSET','0236753a3aa761d1a8b7d04b76e8fcae',100,0,'4b1541673b2df412263bf6888043a6f8','','Assets',0,1);
INSERT INTO "accounts" VALUES('8e14dd0122d7603d321cbdc27ad1a61e','Current Assets','ASSET','0236753a3aa761d1a8b7d04b76e8fcae',100,0,'6520e1fa04f2ab7fcdcfac74bc828d70','','Current Assets',0,1);
INSERT INTO "accounts" VALUES('b49249296b4e626e15e3e9dc26e134ee','Checking Account','BANK','0236753a3aa761d1a8b7d04b76e8fcae',100,0,'8e14dd0122d7603d321cbdc27ad1a61e','','Checking Account',0,0);
INSERT INTO "accounts" VALUES('23ca6fa1197ab20234270904aefbe1b6','Income','INCOME','0236753a3aa761d1a8b7d04b76e8fcae',100,0,'4b1541673b2df412263bf6888043a6f8','','Income',0,0);
INSERT INTO "accounts" VALUES('42be2b8f2f42233383dae2d790f4bfcb','Expenses','EXPENSE','0236753a3aa761d1a8b7d04b76e8fcae',100,0,'4b1541673b2df412263bf6888043a6f8','','Expenses',0,0);
INSERT INTO "accounts" VALUES('4c27e7cd1fbc45075635e1cba4d13363','Equity','EQUITY','0236753a3aa761d1a8b7d04b76e8fcae',100,0,'4b1541673b2df412263bf6888043a6f8','','Equity',0,1);
INSERT INTO "accounts" VALUES('10af233a6bda8c9333dfc1de3f4f46e0','Opening Balances','EQUITY','0236753a3aa761d1a8b7d04b76e8fcae',100,0,'4c27e7cd1fbc45075635e1cba4d13363','','Opening Balances',0,0);
INSERT INTO "accounts" VALUES('c3ad15d48a1a5790bf1b8418956a7249','Template Root','ROOT',NULL,0,0,NULL,'','',0,0);
CREATE TABLE books (guid text(32) PRIMARY KEY NOT NULL, root_account_guid text(32) NOT NULL, root_template_guid text(32) NOT NULL);
INSERT INTO "books" VALUES('8981a0b78c63b5986c9f267769cb0364','4b1541673b2df412263bf6888043a6f8','c3ad15d48a1a5790bf1b8418956a7249');
CREATE TABLE budgets (guid text(32) PRIMARY KEY NOT NULL, name text(2048) NOT NULL, description text(2048), num_periods integer NOT NULL);
CREATE TABLE budget_amounts (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, budget_guid text(32) NOT NULL, account_guid text(32) NOT NULL, period_num integer NOT NULL, amount_num bigint NOT NULL, amount_denom bigint NOT NULL);
CREATE TABLE commodities (guid text(32) PRIMARY KEY NOT NULL, namespace text(2048) NOT NULL, mnemonic text(2048) NOT NULL, fullname text(2048), cusip text(2048), fraction integer NOT NULL, quote_flag integer NOT NULL, quote_source text(2048), quote_tz text(2048));
INSERT INTO "commodities" VALUES('0236753a3aa761d1a8b7d04b76e8fcae','CURRENCY','USD','US Dollar','840',100,1,'currency','');
CREATE TABLE lots (guid text(32) PRIMARY KEY NOT NULL, account_guid text(32), is_closed integer NOT NULL);
CREATE TABLE prices (guid text(32) PRIMARY KEY NOT NULL, commodity_guid text(32) NOT NULL, currency_guid text(32) NOT NULL, date text(14) NOT NULL, source text(2048), type text(2048), value_num bigint NOT NULL, value_denom bigint NOT NULL);
CREATE TABLE schedxactions (guid text(32) PRIMARY KEY NOT NULL, name text(2048), enabled integer NOT NULL, start_date text(8), end_date text(8), last_occur text(8), num_occur integer NOT NULL, rem_occur integer NOT NULL, auto_create integer NOT NULL, auto_notify integer NOT NULL, adv_creation integer NOT NULL, adv_notify integer NOT NULL, instance_count integer NOT NULL, template_act_guid text(32) NOT NULL);
CREATE TABLE transactions (guid text(32) PRIMARY KEY NOT NULL, currency_guid text(32) NOT NULL, num text(2048) NOT NULL, post_date text(14), enter_date text(14), description text(2048));
INSERT INTO "transactions" VALUES('192f9b4f554696782ff2bf51e482e1a1','0236753a3aa761d1a8b7d04b76e8fcae','','20110118022742','20120512170245','90853');
INSERT INTO "transactions" VALUES('4469fae8a92d093313fa3f156eb130cb','0236753a3aa761d1a8b7d04b76e8fcae','','20110118031215','20120512170245','90853');
CREATE TABLE splits (guid text(32) PRIMARY KEY NOT NULL, tx_guid text(32) NOT NULL, account_guid text(32) NOT NULL, memo text(2048) NOT NULL, action text(2048) NOT NULL, reconcile_state text(1) NOT NULL, reconcile_date text(14), value_num bigint NOT NULL, value_denom bigint NOT NULL, quantity_num bigint NOT NULL, quantity_denom bigint NOT NULL, lot_guid text(32));
INSERT INTO "splits" VALUES('d0cf8eae96402daced7e4a55870878f4','192f9b4f554696782ff2bf51e482e1a1','b49249296b4e626e15e3e9dc26e134ee','90853','','c','20120512170315',6000,100,6000,100,NULL);
INSERT INTO "splits" VALUES('32498ba380a05f98abdda143d9be4080','192f9b4f554696782ff2bf51e482e1a1','42be2b8f2f42233383dae2d790f4bfcb','','','n',NULL,-6000,100,-6000,100,NULL);
INSERT INTO "splits" VALUES('dc227176700e4e46b9bab972831c5112','4469fae8a92d093313fa3f156eb130cb','b49249296b4e626e15e3e9dc26e134ee','90853','','c','20120512170315',6000,100,6000,100,NULL);
INSERT INTO "splits" VALUES('9fb6cf2159b734ed9e6e227ad031612c','4469fae8a92d093313fa3f156eb130cb','42be2b8f2f42233383dae2d790f4bfcb','','','n',NULL,-6000,100,-6000,100,NULL);
CREATE TABLE billterms (guid text(32) PRIMARY KEY NOT NULL, name text(2048) NOT NULL, description text(2048) NOT NULL, refcount integer NOT NULL, invisible integer NOT NULL, parent text(32), type text(2048) NOT NULL, duedays integer, discountdays integer, discount_num bigint, discount_denom bigint, cutoff integer);
CREATE TABLE customers (guid text(32) PRIMARY KEY NOT NULL, name text(2048) NOT NULL, id text(2048) NOT NULL, notes text(2048) NOT NULL, active integer NOT NULL, discount_num bigint NOT NULL, discount_denom bigint NOT NULL, credit_num bigint NOT NULL, credit_denom bigint NOT NULL, currency text(32) NOT NULL, tax_override integer NOT NULL, addr_name text(1024), addr_addr1 text(1024), addr_addr2 text(1024), addr_addr3 text(1024), addr_addr4 text(1024), addr_phone text(128), addr_fax text(128), addr_email text(256), shipaddr_name text(1024), shipaddr_addr1 text(1024), shipaddr_addr2 text(1024), shipaddr_addr3 text(1024), shipaddr_addr4 text(1024), shipaddr_phone text(128), shipaddr_fax text(128), shipaddr_email text(256), terms text(32), tax_included integer, taxtable text(32));
CREATE TABLE employees (guid text(32) PRIMARY KEY NOT NULL, username text(2048) NOT NULL, id text(2048) NOT NULL, language text(2048) NOT NULL, acl text(2048) NOT NULL, active integer NOT NULL, currency text(32) NOT NULL, ccard_guid text(32), workday_num bigint NOT NULL, workday_denom bigint NOT NULL, rate_num bigint NOT NULL, rate_denom bigint NOT NULL, addr_name text(1024), addr_addr1 text(1024), addr_addr2 text(1024), addr_addr3 text(1024), addr_addr4 text(1024), addr_phone text(128), addr_fax text(128), addr_email text(256));
CREATE TABLE entries (guid text(32) PRIMARY KEY NOT NULL, date text(14) NOT NULL, date_entered text(14), description text(2048), action text(2048), notes text(2048), quantity_num bigint, quantity_denom bigint, i_acct text(32), i_price_num bigint, i_price_denom bigint, i_discount_num bigint, i_discount_denom bigint, invoice text(32), i_disc_type text(2048), i_disc_how text(2048), i_taxable integer, i_taxincluded integer, i_taxtable text(32), b_acct text(32), b_price_num bigint, b_price_denom bigint, bill text(32), b_taxable integer, b_taxincluded integer, b_taxtable text(32), b_paytype integer, billable integer, billto_type integer, billto_guid text(32), order_guid text(32));
CREATE TABLE invoices (guid text(32) PRIMARY KEY NOT NULL, id text(2048) NOT NULL, date_opened text(14), date_posted text(14), notes text(2048) NOT NULL, active integer NOT NULL, currency text(32) NOT NULL, owner_type integer, owner_guid text(32), terms text(32), billing_id text(2048), post_txn text(32), post_lot text(32), post_acc text(32), billto_type integer, billto_guid text(32), charge_amt_num bigint, charge_amt_denom bigint);
CREATE TABLE jobs (guid text(32) PRIMARY KEY NOT NULL, id text(2048) NOT NULL, name text(2048) NOT NULL, reference text(2048) NOT NULL, active integer NOT NULL, owner_type integer, owner_guid text(32));
CREATE TABLE orders (guid text(32) PRIMARY KEY NOT NULL, id text(2048) NOT NULL, notes text(2048) NOT NULL, reference text(2048) NOT NULL, active integer NOT NULL, date_opened text(14) NOT NULL, date_closed text(14) NOT NULL, owner_type integer NOT NULL, owner_guid text(32) NOT NULL);
CREATE TABLE taxtables (guid text(32) PRIMARY KEY NOT NULL, name text(50) NOT NULL, refcount bigint NOT NULL, invisible integer NOT NULL, parent text(32));
CREATE TABLE taxtable_entries (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, taxtable text(32) NOT NULL, account text(32) NOT NULL, amount_num bigint NOT NULL, amount_denom bigint NOT NULL, type integer NOT NULL);
CREATE TABLE vendors (guid text(32) PRIMARY KEY NOT NULL, name text(2048) NOT NULL, id text(2048) NOT NULL, notes text(2048) NOT NULL, currency text(32) NOT NULL, active integer NOT NULL, tax_override integer NOT NULL, addr_name text(1024), addr_addr1 text(1024), addr_addr2 text(1024), addr_addr3 text(1024), addr_addr4 text(1024), addr_phone text(128), addr_fax text(128), addr_email text(256), terms text(32), tax_inc text(2048), tax_table text(32));
CREATE TABLE recurrences (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, obj_guid text(32) NOT NULL, recurrence_mult integer NOT NULL, recurrence_period_type text(2048) NOT NULL, recurrence_period_start text(8) NOT NULL);
CREATE TABLE slots (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, obj_guid text(32) NOT NULL, name text(4096) NOT NULL, slot_type integer NOT NULL, int64_val bigint, string_val text(4096), double_val float8, timespec_val text(14), guid_val text(32), numeric_val_num bigint, numeric_val_denom bigint, gdate_val text(8));
INSERT INTO "slots" VALUES(1,'6520e1fa04f2ab7fcdcfac74bc828d70','placeholder',4,0,'true',0.0,NULL,NULL,0,1,NULL);
INSERT INTO "slots" VALUES(2,'8e14dd0122d7603d321cbdc27ad1a61e','placeholder',4,0,'true',0.0,NULL,NULL,0,1,NULL);
INSERT INTO "slots" VALUES(3,'4c27e7cd1fbc45075635e1cba4d13363','placeholder',4,0,'true',0.0,NULL,NULL,0,1,NULL);
INSERT INTO "slots" VALUES(21,'b49249296b4e626e15e3e9dc26e134ee','import-map',9,0,NULL,0.0,NULL,'b2d93ba1153a1565c1615e65e4d9fd79',0,1,NULL);
INSERT INTO "slots" VALUES(22,'b2d93ba1153a1565c1615e65e4d9fd79','import-map/desc',9,0,NULL,0.0,NULL,'7447b0f61ab37b759914e8edb9491b72',0,1,NULL);
INSERT INTO "slots" VALUES(23,'7447b0f61ab37b759914e8edb9491b72','import-map/desc/90853',5,0,NULL,0.0,NULL,'42be2b8f2f42233383dae2d790f4bfcb',0,1,NULL);
INSERT INTO "slots" VALUES(24,'b2d93ba1153a1565c1615e65e4d9fd79','import-map/memo',9,0,NULL,0.0,NULL,'0a26d14ca5d9423ec042743da3d66bc0',0,1,NULL);
INSERT INTO "slots" VALUES(25,'0a26d14ca5d9423ec042743da3d66bc0','import-map/memo/90853',5,0,NULL,0.0,NULL,'42be2b8f2f42233383dae2d790f4bfcb',0,1,NULL);
INSERT INTO "slots" VALUES(26,'b49249296b4e626e15e3e9dc26e134ee','online_id',4,0,'123456789  123456789',0.0,NULL,NULL,0,1,NULL);
INSERT INTO "slots" VALUES(27,'192f9b4f554696782ff2bf51e482e1a1','notes',4,0,'OFX ext. info: |Trans type:Generic credit|Payee ID:2',0.0,NULL,NULL,0,1,NULL);
INSERT INTO "slots" VALUES(28,'d0cf8eae96402daced7e4a55870878f4','online_id',4,0,'2-6',0.0,NULL,NULL,0,1,NULL);
INSERT INTO "slots" VALUES(29,'4469fae8a92d093313fa3f156eb130cb','notes',4,0,'OFX ext. info: |Trans type:Generic credit|Payee ID:2',0.0,NULL,NULL,0,1,NULL);
INSERT INTO "slots" VALUES(30,'dc227176700e4e46b9bab972831c5112','online_id',4,0,'2-9',0.0,NULL,NULL,0,1,NULL);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('slots',30);
CREATE INDEX tx_post_date_index ON transactions (post_date);
CREATE INDEX splits_tx_guid_index ON splits (tx_guid);
CREATE INDEX splits_account_guid_index ON splits (account_guid);
CREATE INDEX slots_guid_index ON slots (obj_guid);
COMMIT;
