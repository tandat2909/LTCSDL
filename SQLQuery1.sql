-- khong cho phep ddat qua 2 don hangf torng 1 ngay

create trigger trQuanLyDonDatHang on Orders
for insert,update
as
	begin
		declare @slKhCu int , @slKhMoi int
		if(update(customerID))
			begin
				-- dem so luong don hang khach cu
				Select @slKhCu = count(orderID) from orders
				where customerID = (select customerID from deleted)
				and orderDate = (select orderDate from deleted)
				
				-- dem so luong don hanh khach moi
				
				Select @slKhMoi = count(orderID) from orders
				where customerID = (select customerID from inserted)
				and orderDate = (select orderDate from inserted)
				
				if (@slKhMoi + @slKhCu > 3)
				begin
					Raiserror('Khong duoc them qua 2 don hang 1 ngay',15,1)
					Rollback tran
				end
			end
			if exists(select * from inserted)
				begin
					Select @slKhMoi = count(orderID) from orders
					where customerID = (select customerID from inserted)
					and orderDate = (select orderDate from inserted)
					if(@slKhMoi > 2)
						begin
							Raiserror('Khong duoc them qua 2 don hang 1 ngay',15,1)
							Rollback tran
						end
				end
				
	end
	
