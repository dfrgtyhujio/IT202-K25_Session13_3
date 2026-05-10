USE RikkeiClinicDB;

create table price_changes_log (
    log_id int auto_increment primary key,
    medicine_id int,
    old_price decimal(18,2),
    new_price decimal(18,2),
    status varchar(20),
    price_difference decimal(18,2),
    changed_at datetime default current_timestamp
);

delimiter //
create trigger changeprice
	before update on medicines
	for each row
begin
    if new.price <= 0 then
        signal sqlstate '45000'
        set message_text = 'lỗi: giá thuốc mới không hợp lệ';
    end if;

    if new.price > old.price then
        insert into price_changes_log (medicine_id, old_price, new_price, status, price_difference)
        values (new.medicine_id, old.price, new.price, 'tăng giá', new.price - old.price);
        
    elseif new.price < old.price then
        insert into price_changes_log (medicine_id, old_price, new_price, status, price_difference)
        values (new.medicine_id, old.price, new.price, 'giảm giá', old.price - new.price);
    end if;
end //
delimiter ;

update medicines set price = 10000 where medicine_id = 1;

update medicines set price = 4000 where medicine_id = 2;

update medicines set price = -5000 where medicine_id = 1;


select * from price_changes_log;


