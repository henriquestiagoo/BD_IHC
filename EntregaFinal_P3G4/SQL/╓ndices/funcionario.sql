
use p3g4;

GO
CREATE NONCLUSTERED INDEX idxSalaryFunc ON gestaoHotel.Funcionario(salario)
WITH (FILLFACTOR=75,pad_index=ON);

GO
CREATE NONCLUSTERED INDEX idxHotelFunc ON gestaoHotel.Funcionario(hotel)
WITH (FILLFACTOR=75,pad_index=ON);

