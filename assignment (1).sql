create or replace procedure ADD_CUST_TO_DB(pcustid1 IN NUMBER, pcustname1 IN VARCHAR2) 
IS



hh varchar2(100);


v_sql LONG;


s number(10) := 0;

  
tab exception;
  
pragma exception_init(tab,-942);


begin



if(pcustid1>0 and pcustid1 <500)



then












hh:='ok';


execute immediate 'insert into customer values (:1, :2, :3, :4)'
 using pcustid1, pcustname1, 0,'ok';


commit;




END IF;


EXCEPTION 


when tab 
then

execute immediate 'create table customer (pcustid number not null primary key ,pcustname varchar2(100) not null,sales_ytd number not null ,status varchar2(10) not null)';


add_cust_to_db(pcustid1,pcustname1);

commit;
end;

/







-----------------------new proc----------------------------




create or replace procedure ADD_CUSTOMER_VIASQLDEV(pcustid1 IN NUMBER , pcustname IN VARCHAR2) 
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Adding '||pcustid1||' '||pcustname);
ADD_CUST_TO_DB(pcustid1,pcustname);
dbms_output.put_line('Added OK');
end;
/




-----------------------new proc-------------------------------


create or replace function DELETE_ALL_CUSTOMERS_FROM_DB 
return number
IS
non number;
tab exception;
pragma exception_init(tab,-942);
begin
execute immediate 'select count(*) into non from customer';
execute immediate 'truncate table customer';
return non;
exception
when tab
then
return 0;
when others 
then
raise_application_error(-20000,sqlerrm);
end;
/





-------------------------new proc----------------------------------



create or replace procedure DELETE_ALL_CUSTOMERS_VIASQLDEV 
IS
non number;
tab exception;
pragma exception_init(tab,-942);
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
non:=DELETE_ALL_CUSTOMERS_FROM_DB;
if(non=0)
then
raise tab;
end if;
dbms_output.put_line(non||' rows deleted');
exception 
when tab
then
dbms_output.put_line('0 rows deleted');
end;
/



---------------------------------new proc-----------------------------


create or replace procedure ADD_PROD_TO_DB(pprodid1 IN NUMBER, pprodname1 IN VARCHAR2,pprice1 IN NUMBER) 
IS



hh varchar2(100);


v_sql LONG;


s number(10) := 0;

  
tab exception;
 
id1 exception;
pr exception; 
pragma exception_init(tab,-942);


pragma exception_init(id1,-20012);


pragma exception_init(pr,-20013);

begin

if(pprodid1>1000 and pprodid1<2500 and pprice1>0 and pprice1<1000)



then










execute immediate 'insert into product values (:1, :2, :3, :4)'
 using pprodid1, pprodname1,0, pprice1;


commit;




else
if(pprodid1<1000 or pprodid1>2500)
then 
raise id1;
elsif(pprice1<0 or pprice1>=1000)
then
raise pr;
END IF;


end if;
EXCEPTION 


when tab 
then

execute immediate 'create table product (pprodid number not null primary key ,pprodname varchar2(100) not null,sales_ytd number not null ,pprice number(10) not null)';


add_prod_to_db(pprodid1,pprodname1,pprice1);

when id1
then
raise_application_error(-20012,'Error :Product ID out of range');
when pr
then 
raise_application_error(-20013,'Error :Price out of range');
when dup_val_on_index
then 
raise_application_error(-20010,'Duplicate product ID');
when others 
then
raise_application_error(-20001,sqlerrm);
end;

/



-----------------------------------------new proc------------------------------------



create or replace procedure ADD_PRODUCT_VIASQLDEV(pcustid1 IN NUMBER , pcustname IN VARCHAR2, pr in number) 
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Adding Product ID:'||pcustid1||' Name: '||pcustname||' Price: '||pr);
ADD_PROD_TO_DB(pcustid1,pcustname,pr);
dbms_output.put_line('Product Added OK');
end;
/



--------------------------------------------new proc--------------------------------------


create or replace function DELETE_ALL_PRODUCTS_FROM_DB 
return number
IS
non number;
tab exception;
pragma exception_init(tab,-942);
begin
execute immediate 'select count(*) into non from product';
execute immediate 'truncate table product';
commit;
return non;
exception
when tab
then
return 0;
when others 
then
raise_application_error(-20000,sqlerrm);
end;
/


-------------------------------------------new proc-------------------------------------




create or replace procedure DELETE_ALL_PRODUCTS_VIASQLDEV 
IS
non number;
begin
non:=DELETE_ALL_PRODUCTS_FROM_DB;
dbms_output.put_line(non||' rows deleted');
end;
/

-------------------------------------new proc------------------------------------------




create or replace function GET_CUST_STRING_FROM_DB (pcid IN NUMBER)
RETURN varchar2
IS
nae varchar2(100);
stat varchar2(10);
sales number(10);
vsql varchar2(200);
non number;
tab exception;
pragma exception_init(tab,-942);
begin
execute immediate 'select count(*),pcustname,status,sales_ytd into non,nae,stat,sales from customer where pcustid=pcid';
if(non>0)
then
vsql:= 'Custid: '||pcid||'Name: '||nae||'Status: '||stat||'SalesYTD: '||sales;
return vsql;
else 
raise tab;
end if;
exception
when tab 
then
raise_application_error(-20021,'Customer ID not found');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


---------------------------------------------new proc--------------------


create or replace procedure GET_CUST_STRING_VIASQLDEV(pcustid IN NUMBER)
IS
vsql varchar2(200);
BEGIN
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Getting Details for CustId '||pcustid);
vsql:=GET_CUST_STRING_FROM_DB(pcustid);
dbms_output.put_line(vsql);
end;
/


-----------------------------------------new proc-----------------------------



create or replace procedure UPD_CUST_SALESYTD_IN_DB(pcid in number, pamt in number)
IS
amt number;
non number;
tab exception;
vsql varchar2(100);
pr exception;
pragma exception_init(tab,-942);
pragma exception_init(pr,-20032);
begin
if(pamt<=-1000 or pamt>= 1000)
then
raise pr;
end if;
select sales_ytd into amt from customer where pcustid=pcid;
amt:=amt+pamt;
vsql :='update customer set sales_ytd='||amt||' where pcustid='||pcid||' ';
execute immediate vsql; 
exception
when no_data_found
then
raise tab; 
when tab
then
raise_application_error(-20032,'Error: Customer ID not found');
when pr
then 
raise_application_error(-20052,'Error: Amount out of range');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/



---------------------------------------new proc--------------------------


create or replace procedure UPD_CUST_SALESYTD_VIASQLDEV (pcustid IN NUMBER , pamt IN NUMBER)
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Updating SalesYTD. Customer Id: '||pcustid||' Amount: '||pamt);
UPD_CUST_SALESYTD_IN_DB(pcustid,pamt);
dbms_output.put_line('Update OK');
end;
/


------------------------------------new proc-----------------------------


create or replace function GET_PROD_STRING_FROM_DB (ppid in number)
return varchar2
IS
tab exception;
pragma exception_init(tab,-942);
nae varchar2(100);
vsql varchar2(200);
stat number(10);
pro number(10);
non number;
begin
execute immediate 'select count(*),pprodname,sales_ytd,pprice into non,nae,stat,pro from customer where pprodid=ppid';
if(non>0)
then
vsql:='Prodid: '||ppid||'Name: '||nae||'SalesYTD: '||stat||'Price: '||pro;
return vsql;
else 
raise tab;
end if;
exception
when tab 
then
raise_application_error(-20041,'Product ID not found');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


---------------------------------------------------new proc-----------------


create or replace procedure GET_PROD_STRING_VIASQLDEV(pcustid IN NUMBER)
IS
vsql varchar2(200);
BEGIN
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Getting Details for Prod Id '||pcustid);
vsql:=GET_PROD_STRING_FROM_DB(pcustid);
dbms_output.put_line(vsql);
end;
/


-------------------------------------------new proc ------------------------------



create or replace procedure UPD_PROD_SALESYTD_IN_DB(pcid in number, pamt in number)
IS
amt number;
non number;
tab exception;
vsql varchar2(100);
pr exception;
pragma exception_init(tab,-942);
pragma exception_init(pr,-20032);
begin

if(pamt<=-1000 or pamt>= 1000)
then
raise pr;
end if;

select sales_ytd into amt from product where pprodid=pcid;
amt:=amt+pamt;
vsql:='update product set sales_ytd='||amt||' where pprodid='||pcid;
execute immediate vsql; 

exception 
when no_data_found
then
raise tab;
when tab
then
raise_application_error(-20041,'Error: Product ID not found');
when pr
then 
raise_application_error(-20052,'Error: Amount out of range');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


------------------------------------new proc------------------------------------


create or replace procedure UPD_PROD_SALESYTD_VIASQLDEV (pcustid IN NUMBER , pamt IN NUMBER)
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Updating SalesYTD. Product Id: '||pcustid||' Amount: '||pamt);
UPD_CUST_SALESYTD_IN_DB(pcustid,pamt);
dbms_output.put_line('Update OK');
end;
/


-------------------------------------new proc----------------------------------



create or replace procedure UPD_CUST_STATUS_IN_DB(pcustid1 IN NUMBER,pstatus1 IN VARCHAR2)
IS
tab exception;
iss exception;
pragma exception_init(iss,-20062);
non number;
pragma exception_init(tab,-942);
begin 
execute immediate 'select count(*) into non from customer where ppcustid=pcustid1';
if(non>0)
then
execute immediate 'update customer set status=pstatus1 where ppcustid=pcustid1';
else
raise tab;
end if;
exception
when tab
then
raise_application_error(-20061,'Error: Customer ID not found');
when iss
then
raise_application_error(-20062,'Error: Invalid Status value');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/

-----------------------------------new proc---------------------------------------


create or replace procedure UPD_CUST_STATUS_VIASQLDEV (pcustid IN NUMBER , pamt IN Varchar2)
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Updating Status. Id: '||pcustid||' New Status: '||pamt);
UPD_CUST_SALESYTD_IN_DB(pcustid,pamt);
dbms_output.put_line('Update OK');
end;
/

-----------------------------------new proc--------------------------------------



create or replace procedure ADD_SIMPLE_SALE_TO_DB (pcid IN NUMBER, ppid IN NUMBER,pqty IN NUMBER)
IS
stt varchar2(100);
totamt number;
non1 number;
non2 number;
kom1 number;
kom2 number;
tab exception;
pid exception;
sid1 exception;
qtt exception;
cid exception;
pragma exception_init(pid,-20076);
pragma exception_init(cid,-20073);
pragma exception_init(tab,-942);
pragma exception_init(qtt,-20071);
pragma exception_init(sid1,-20072);
begin
if(pqty<1 or pqty>999)
then 
raise qtt;
end if;
execute immediate 'select count(*),pprice,sales_ytd into non1,totamt,kom1 from product where pprodid=ppid';
execute immediate 'select count(*),sales_ytd,status into non2,kom2,stt from customer where pcustid=pcid';
if(non1<0)
then
raise pid;
elsif(non2<0)
then
raise cid;
elsif(stt!='ok')
then 
raise sid1;
end if;
totamt:=totamt*pqty;
UPD_PROD_SALESYTD_IN_DB(ppid,totamt);
UPD_CUST_SALESYTD_IN_DB(pcid,totamt);
exception
when pid
then
raise_application_error(-20076,'Error: Product ID not found');
when sid1
then
raise_application_error(-20072,'Error: Customer status is not OK');
when cid
then 
raise_application_error(-20072,'Error: Customer ID not found');
when qtt
then 
raise_application_error(-20071,'Error: Sale Quantity outside valid range');
when tab
then 
raise pid;
when others
then 
raise_application_error(-20000,sqlerrm);
end;
/


-----------------------------------------------new proc-----------------------

create or replace procedure ADD_SIMPLE_SALE_VIASQLDEV(pcid IN NUMBER,ppid IN NUMBER,pqty IN NUMBER)
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Adding Simple Sale. Cust Id: '||pcid||' Prod Id: '||ppid||' Qty: '||pqty);
ADD_SIMPLE_SALE_TO_DB(pcid,ppid,pqty);
dbms_output.put_line('Added Simple Sale OK');
end;
/


---------------------------------------new proc-------------------------------

create or replace function SUM_CUST_SALESYTD 
return NUMBER
IS
tab exception;
sss number;
pragma exception_init(tab,-942);
begin
execute immediate 'select sum(sales_ytd) into sss from customer';
return sss;
exception
when tab
then
return 0;
end;
/

---------------------------new proc--------------------------------


create or replace procedure SUM_CUST_SALES_VIASQLDEV
IS
non number;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Summing Customer SalesYTD');
non:=SUM_CUST_SALESYTD;
dbms_output.put_line(non);
end;
/


-----------------------------new proc-----------------------------------

create or replace function SUM_PROD_SALESYTD_FROM_DB
return NUMBER
IS
tab exception;
sss number;
pragma exception_init(tab,-942);
begin
execute immediate 'select sum(sales_ytd) into sss from product';
return sss;
exception
when tab
then
return 0;
end;
/

-------------------------------------new proc--------------------------------

create or replace procedure SUM_PROD_SALES_VIASQLDEV
IS
non number;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Summing Product SalesYTD');
non:=SUM_PROD_SALESYTD_FROM_DB;
dbms_output.put_line(non);
end;
/


---------------------------------new proc-------------------------------------





----------------------------------------------------------------------------------




create or replace function GET_ALLCUST
return SYS_REFCURSOR
IS
refc SYS_REFCURSOR;
begin
	OPEN refc FOR 'SELECT * from customer ';
	return refc;
exception
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


-----------------------------new proc-------------------------------




create or replace procedure GET_ALLCUST_VIASQLDEV
IS
cust_refcur SYS_REFCURSOR;
cid number(5);
cname varchar2(200);
stat varchar2(10);
sale number(10,4);
a1 number:=1;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Listing All Customer Details');
cust_refcur :=GET_ALLCUST;
LOOP
FETCH cust_refcur into cid,cname,sale,stat;
EXIT WHEN cust_refcur%NOTFOUND;
a1:=0;
dbms_output.put_line('Custid: '||cid||' Name: '||cname||' Status: '||stat||' SalesYTD: '||sale);
END LOOP;
if(a1=1)
then
dbms_output.put_line('No rows found');
end if;
end;
/



----------------------------------new proc-----------------------------------

create or replace function GET_ALLPROD_FROM_DB
return SYS_REFCURSOR
IS
refc SYS_REFCURSOR;
begin
	OPEN refc FOR 'SELECT * from product ';
	return refc;
exception
when others
then
raise_application_error(-20000,sqlerrm);
end;
/

---------------------------------------new proc-----------------------------



create or replace procedure GET_ALLPROD_VIASQLDEV
IS
cust_refcur SYS_REFCURSOR;
cid number(5);
cname varchar2(200);
pric number(10);
sale number(10,4);
a1 number:=1;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Listing All Product Details');
cust_refcur :=GET_ALLPROD_FROM_DB;
LOOP
FETCH cust_refcur into cid,cname,sale,pric;
EXIT WHEN cust_refcur%NOTFOUND;
a1:=0;
dbms_output.put_line('Prodid: '||cid||' Name: '||cname||' Price: '||pric||' SalesYTD: '||sale);
END LOOP;
if(a1=1)
then
dbms_output.put_line('No rows found');
end if;
end;
/



----------------------------------------------------------------------------------
-----------------------------------new proc--------------------------------------



-----------------------------------------------------------------------------------



create or replace function GET_ALLCUST
return SYS_REFCURSOR
IS
refc SYS_REFCURSOR;
begin
	OPEN refc FOR 'SELECT * from customer ';
	return refc;
exception
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


-----------------------------new proc-------------------------------




create or replace procedure GET_ALLCUST_VIASQLDEV
IS
cust_refcur SYS_REFCURSOR;
cid number(5);
cname varchar2(200);
stat varchar2(10);
sale number(10,4);
a1 number:=1;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Listing All Customer Details');
cust_refcur :=GET_ALLCUST;
LOOP
FETCH cust_refcur into cid,cname,sale,stat;
EXIT WHEN cust_refcur%NOTFOUND;
a1:=0;
dbms_output.put_line('Custid: '||cid||' Name: '||cname||' Status: '||stat||' SalesYTD: '||sale);
END LOOP;
if(a1=1)
then
dbms_output.put_line('No rows found');
end if;
end;
/



----------------------------------new proc-----------------------------------

create or replace function GET_ALLPROD_FROM_DB
return SYS_REFCURSOR
IS
refc SYS_REFCURSOR;
begin
	OPEN refc FOR 'SELECT * from product ';
	return refc;
exception
when others
then
raise_application_error(-20000,sqlerrm);
end;
/

---------------------------------------new proc-----------------------------



create or replace procedure GET_ALLPROD_VIASQLDEV
IS
cust_refcur SYS_REFCURSOR;
cid number(5);
cname varchar2(200);
pric number(10);
sale number(10,4);
a1 number:=1;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Listing All Product Details');
cust_refcur :=GET_ALLPROD_FROM_DB;
LOOP
FETCH cust_refcur into cid,cname,sale,pric;
EXIT WHEN cust_refcur%NOTFOUND;
a1:=0;
dbms_output.put_line('Prodid: '||cid||' Name: '||cname||' Price: '||pric||' SalesYTD: '||sale);
END LOOP;
if(a1=1)
then
dbms_output.put_line('No rows found');
end if;
end;
/




---------------------------------------new proc-----------------------------






create or replace procedure ADD_LOCATION_TO_DB(pioccode1 IN varchar2, pminqty1 IN number, pmaxqty1 in number) 
IS


tab exception;
  
pragma exception_init(tab,-942);


loclen exception;
pragma exception_init(loclen,-20082);
minrange exception;
pragma exception_init(minrange,-20083);
maxrange exception;
pragma exception_init(maxrange,-20084);
minmax exception;
pragma exception_init(minmax,-20086);

begin




if(length(pioccode1)!=5)



then





raise loclen;
elsif(pminqty1>pmaxqty1)
then
raise minmax;
elsif(pminqty1<0 or pminqty1>10)
then 
raise minrange;
elsif(pmaxqty1<0 or pmaxqty1>900)
then 
raise maxrange;
end if;
execute immediate 'insert into location values (:1, :2, :3)'
 using pioccode1, pminqty1,pmaxqty1;


commit;







EXCEPTION 


when tab 
then

execute immediate 'create table location(ploccode varchar2(10) not null primary key ,pminqty number(10) not null,pmaxqty number(10) not null)';


add_location_to_db(pioccode1,pminqty1,pmaxqty1);

commit;
when loclen 
then 
raise_application_error(-20082,'Error: Location Code length invalid');
when minrange
then 
raise_application_error(-20083,'Error: Minimum Qty out of range');
when maxrange
then
raise_application_error(-20084,'Error: Maximum Qty out of range');
when minmax
then
raise_application_error(-20086,'Error: Minimum Qty larger than Maximum Qty');
when DUP_VAL_ON_INDEX
then
raise_application_error(-20081,'Error: Duplicate location ID');
when others
then
raise_application_error(-20000,sqlerrm);
 
end;

/










---------------------------------------new proc-----------------------------






create or replace procedure ADD_LOCATION_VIASQLDEV(ploccode in varchar2, pminqty in number, pmaxqty number)
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Adding Location LocCode: '||ploccode||' MinQty: '||pminqty||' MaxQty '||pmaxqty);
ADD_LOCATION_TO_DB(ploccode,pminqty,pmaxqty);
dbms_output.put_line('Location Added OK');
end;
/



-------------------------------------------------------------------------------
------------------------------new proc-----------------------------------------

------------------------------------------------------------------------------------
create or replace procedure ADD_COMPLEX_SALE_TO_DB (pcustid1 IN NUMBER, pprodid1 IN NUMBER,pqty1 IN NUMBER, pdate1 IN varchar2)

IS 

pric number;

statu varchar2(20):='saa$aas';

todd date;

errdate exception;

pragma exception_init(errdate,-01839);

tab exception;
 

pragma exception_init(tab,-942);



erqty exception;

pragma exception_init(erqty,-20092);

erstat exception;

pragma exception_init(erstat,-20093);

nocust exception;

pragma exception_init(nocust,-20094);

noprod exception;

pragma exception_init(noprod,-20095);

begin



todd :=TO_DATE(pdate1,'yyyymmdd');


if(pqty1<1 or pqty1 >999)

then

raise erqty;

end if;

 
select status into statu from customer where pcustid=pcustid1;


select pprice into pric from product where pprodid=pprodid1;


if(statu!='ok')

then 

raise erstat;





end if;  




pric:=pric*pqty1;
execute immediate 'insert into sale values (sale_seq.nextval, :2, :3, :4,:5)'
 using pprodid1,pcustid1, pric,todd;

commit;
UPD_CUST_SALESYTD_IN_DB(pcustid1,pric); 
UPD_PROD_SALESYTD_IN_DB(pprodid1,pric);
EXCEPTION
when 


no_data_found
then
if(statu='saa$aas')
then
raise_application_error(-20094,'Error: Customer ID not found');

else
raise_application_error(-20095,'Error: Product ID not found');

end if;
when tab 

then


execute immediate 'CREATE SEQUENCE sale_seq 
MINVALUE 1 
START WITH 1 
INCREMENT BY 1 
CACHE 10';


commit;
execute immediate 'create table sale (psaleid number not null primary key ,pprodid number not null,pcustid number not null ,price number not null,pdate date not null)'; 
ADD_COMPLEX_SALE_TO_DB(pcustid1,pprodid1,pqty1,pdate1);


commit;
when nocust

then

raise_application_error(-20094,'Error: Customer ID not found');

when noprod

then

raise_application_error(-20095,'Error: Product ID not found');

when erstat

then

raise_application_error(-20092,'Error: Customer status not OK');

when errdate

then

raise_application_error(-20093,'Error: Date not valid');

end;


/









------------------------------------new proc------------------------------






create or replace procedure ADD_COMPLEX_SALE_VIASQLDEV(pcustid IN NUMBER,pprodid1 IN NUMBER,pqty IN NUMBER ,pdate IN varchar2)
IS
pric NUMBER;
tab exception;
 

pragma exception_init(tab,-942);



begin
select pprice into pric from product where pprodid=pprodid1;
pric:=pric*pqty;
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Adding Complex Sale Cust Id: '||pcustid||' Prod ID :'|| pprodid1||' Date: '||pdate||' Amt: '||pric);
ADD_COMPLEX_SALE_TO_DB(pcustid,pprodid1,pqty,pdate);
exception
when 


no_data_found
then
raise_application_error(-20095,'Error: Product ID not found');

when tab
then
raise_application_error(-20095,'Error: Product ID not found');

when others
then 
raise_application_error(-20000,sqlerrm);
end;
/


---------------------------------------------new proc--------------------------


create or replace function GET_ALLSALES_FROM_DB
return SYS_REFCURSOR
IS
refc SYS_REFCURSOR;
begin
	OPEN refc FOR 'SELECT * from sale ';
	return refc;
exception
when others
then
raise_application_error(-20000,sqlerrm);
end;
/






---------------------------new proc------------------------------------



create or replace procedure GET_ALLSALES_VIASQLDEV
IS
cust_refcur SYS_REFCURSOR;
cid number(5);
pid number(5);
date1 date;
pric number;
sale number(10);
a1 number:=1;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Listing All Complex Sales Details');
cust_refcur :=GET_ALLSALES_FROM_DB;
LOOP
FETCH cust_refcur into sale,pid,cid,pric,date1;
EXIT WHEN cust_refcur%NOTFOUND;
a1:=0;
dbms_output.put_line('Saleid: '||sale||' Custid: '||cid||' Prodid: '||pid||' Date: '||date1||' Amount: '||pric);
END LOOP;
if(a1=1)
then
dbms_output.put_line('No rows found');
end if;
end;
/

----------------------------------------new proc---------------------------------------

create or replace function COUNT_PRODUCT_SALES_FROM_DB (pdays IN NUMBER)
return NUMBER
is
a1 number;
tot number:=0;
tt number;
v_date date;
begin
SELECT SYSDATE INTO v_date FROM dual;
select count(*) into tt from sale where pdate between (v_date-pdays) and v_date; 
return tt;
exception
when others
then
raise_application_error(-20000,sqlerrm);
end;
/




----------------------------------------new proc-------------------------------

create or replace procedure COUNT_PRODUCT_SALES_VIASQLDEV (pdays IN NUMBER)
IS
nq number;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Counting sales within '||pdays||' days ');
nq:=COUNT_PRODUCT_SALES_FROM_DB(pdays);
dbms_output.put_line('Total number of sales: '||nq);
exception
when others 
then
raise_application_error(-20000,sqlerrm);
end;
/ 




-----------------------------------new proc------------------------

create or replace function DELETE_SALE_FROM_DB
return number
IS
sid number;
pri number;
cid number;
pid number;
vsql varchar2(100);
begin
select MIN(PSALEID) into sid from sale;
select pqty,pprodid,pcustid into pri,pid,cid from sale where PSALEID=sid;
pri:=pri*-1;
UPD_CUST_SALESYTD_IN_DB(cid,pri);
UPD_PROD_SALESYTD_IN_DB(pid,pri);
vsql := 'delete from sale where psaleid ='||sid;
execute immediate vsql;
return sid;
exception
when no_data_found
then
raise_application_error(-20101,'Error: No Sale Rows Found');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


--------------------------------new proc-------------------------------

create or replace procedure delete_sale_viasqldev
is
sid number;
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('Deleting Sale with smallest SaleId value');
sid :=DELETE_SALE_FROM_DB;
dbms_output.put_line('Deleted Sale OK. SaleID: '||sid);
exception
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


-----------------------------------new proc---------------------------------




create or replace procedure DELETE_CUSTOMER(pcid in number)
is
non number:=0;
ccid exception;
pragma exception_init(ccid,-20201);
mcid exception;
v_sql varchar2(100);
pragma exception_init(mcid,-20202);
tab exception;
pragma exception_init(tab,-942);
begin
select count(*) into non from sale where pcustid=pcid;
if(non>0)
then 
raise ccid;
end if;
select count(*) into non from customer where pcustid=pcid;
if(non=0)
then 
raise mcid;
end if;
v_sql := 'delete from customer where pcustid ='||pcid;
execute immediate v_sql;
exception
when tab
then 
if(non=0)
then
raise_application_error(-20201,'Error: Cutomer ID not found');
else
select count(*) into non from customer where pcustid=pcid;
if(non=0)
then 
raise_application_error(-20201,'Error: Cutomer ID not found');
else
v_sql := 'delete from customer where pcustid ='||pcid;
execute immediate v_sql;
end if;
end if;
when mcid
then
raise_application_error(-20201,'Error: Cutomer ID not found');
when ccid
then
raise_application_error(-20202,'Error: Customer cannot be deleted as sales exist');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/



--------------------------new proc------------------------------------


create or replace procedure DELETE_CUSTOMER_VIASQLDEV (pcid in number)
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('"Deleting Customer. Cust Id: '||pcid);
DELETE_CUSTOMER(pcid);
dbms_output.put_line('Deleted Customer OK.');
end;
/


---------------------------------new proc--------------------------------

create or replace procedure DELETE_PROD_FROM_DB(ppid in NUMBER)
is
non number:=0;
ccid exception;
pragma exception_init(ccid,-20301);
mcid exception;
v_sql varchar2(100);
pragma exception_init(mcid,-20302);
tab exception;
pragma exception_init(tab,-942);
begin
select count(*) into non from sale where pprodid=ppid;
if(non>0)
then 
raise ccid;
end if;
select count(*) into non from customer where pcustid=ppid;
if(non=0)
then 
raise mcid;
end if;
v_sql := 'delete from product where pprodid ='||ppid;
execute immediate v_sql;
exception
when tab
then 
if(non=0)
then
raise_application_error(-20201,'Error: Product ID not found');
else
select count(*) into non from product where pprodid=ppid;
if(non=0)
then 
raise_application_error(-20201,'Error: Product ID not found');
else
v_sql := 'delete from product where pprodid ='||ppid;
execute immediate v_sql;
end if;
end if;
when mcid
then
raise_application_error(-20301,'Error: Product ID not found');
when ccid
then
raise_application_error(-20302,'Error: Product cannot be deleted as sales exist');
when others
then
raise_application_error(-20000,sqlerrm);
end;
/


--------------------------new proc------------------------------------


create or replace procedure DELETE_PROD_VIASQLDEV (pcid in number)
IS
begin
dbms_output.put_line('-----------------------------------------------------------------------------------------');
dbms_output.put_line('"Deleting Customer. Prod Id: '||pcid);
DELETE_PROD_FROM_DB(pcid);
dbms_output.put_line('Deleted Product OK.');
end;
/
