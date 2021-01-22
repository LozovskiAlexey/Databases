select id 
from dbo.fine where dbo.fine.cost > 2000;

select driver_id, SUM(cost) 
over (partition by ID) as SUM 
from dbo.driver AS d
join dbo.fd AS fd on d.id = fd.driver_id
join dbo.fine AS f on f.id = fd.fine_id


select full_name 
from dbo.driver AS d where automobile = 
(select id from dbo.automobile where model = 'model1')