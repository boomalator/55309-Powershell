IF OBJECT_ID('dbo.Computers', 'U') IS NOT NULL 
  DROP TABLE  [dbo].[Computers];
go

create table [dbo].[Computers] (
    id integer identity,
    created_at datetime2 default getdate(),
    ComputerName varchar(40),
    Model varchar(40),
    Manufacturer varchar(40),
    osVersion varchar(22),
    spVersion varchar(22),
    PRIMARY KEY (id)
)
go

select * from [dbo].[Computers]


