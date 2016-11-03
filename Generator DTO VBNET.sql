declare @nomeClass varchar(100)
				
set @nomeClass = 'BASOperacoes'

select campo from(
select 1 ordem, 
		'Imports System' + CHAR(13) +
		'Imports CFI' + CHAR(13) +
		 CHAR(13) + '<Serializable()> _' + 
		 CHAR(13) + 'Public Class DTO' + 
		o.name + CHAR(13) +  char(9) + 'Inherits DTO' + CHAR(13)   as campo
from sysobjects o
where o.name = @nomeClass 

 

union

select 2 ordem, 
	char(9)+ 'Private _' +
	c.COLUMN_NAME + ' As ' +
	case convert(varchar,isnull(c.DATA_TYPE,'')) 
	when 'varchar' then 'string'
	when 'text' then 'string'
	when 'char' then case when c.CHARACTER_MAXIMUM_LENGTH > 1 then 'string' else 'char' end
	when 'date' then 'Nullable(Of DateTime)'
	when 'smallint' then 'Nullable(Of integer)'
	when 'float' then 'Nullable(Of Decimal)'
	when 'money' then 'Nullable(Of Decimal)'
	when 'int' then 'Nullable(Of integer)'
	when 'bit' then 'Short'
	when 'varbinary' then 'Byte'
	else 'Nullable(Of ' + convert(varchar,isnull(c.DATA_TYPE,'')) + ')'
	end	
from INFORMATION_SCHEMA.TABLES t	
		JOIN INFORMATION_SCHEMA.COLUMNS c ON
			t.TABLE_NAME = c.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk on
			c.COLUMN_NAME = pk.COLUMN_NAME
			and t.TABLE_NAME = pk.TABLE_NAME
			and pk.CONSTRAINT_NAME like 'PK_%'
where 	t.TABLE_NAME = @nomeClass


union 

select 3 ordem,  char(13) as campo

union

select  ROW_NUMBER() OVER (ORDER BY COLUMN_NAME) + 4 AS  ordem, campo 
from 
(
	SELECT 
		distinct c.COLUMN_NAME, 
		char(9)+ '<ParametersAttribute(' +
		case when not pk.COLUMN_NAME is null then 'Chave:=true,' else '' end + 
	
		(select case when COUNT(*) = 0 then '' else 
			'ChaveEstrangeira:="' + t.TABLE_NAME + '.' + c.COLUMN_NAME  + ' = ' + Max(pk.TABLE_NAME) + '.' + Max(pk.COLUMN_NAME)  + '",' end 
		from INFORMATION_SCHEMA.KEY_COLUMN_USAGE fk
			inner join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rel on 
				fk.CONSTRAINT_NAME = rel.CONSTRAINT_NAME
			inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk on
				rel.UNIQUE_CONSTRAINT_NAME = pk.CONSTRAINT_NAME 
		where fk.CONSTRAINT_NAME like 'FK_%' 
			and fk.COLUMN_NAME =c.COLUMN_NAME 
			and t.TABLE_NAME = fk.TABLE_NAME) +
	
		'Type:=DTOType.' +
		case convert(varchar,isnull(c.DATA_TYPE,'')) 
		when 'varchar' then 'dbVarchar,Length:=' + CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH) 
		when 'text' then 'dbVarchar'
		when 'int' then 'dbInteger' 
		when 'date' then 'dbDate' 
		when 'datetime' then 'dbDate' 
		when 'decimal' then 'dbDecimal'
		when 'float' then 'dbDecimal'
		when 'money' then 'dbCurrency'
		when 'Smallint' then 'dbSmallInt'
		when 'bit' then 'dbSmallInt'
		when 'varbinary' then 'dbSmallInt'
		when 'char' then case when c.CHARACTER_MAXIMUM_LENGTH > 1 then 'dbVarchar' else 'dbChar' end +
						',Length:=' + CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH) end
		 + ')> _' + CHAR(13) + CHAR(9) +
		'Public Property ' +
		c.COLUMN_NAME + ' As ' +
		case convert(varchar,isnull(c.DATA_TYPE,'')) 
		when 'varchar' then 'string'
		when 'text' then 'string'
		when 'char' then case when c.CHARACTER_MAXIMUM_LENGTH > 1 then 'string' else 'char' end
		when 'date' then 'Nullable(Of DateTime)'
		when 'smallint' then 'Nullable(Of integer)'
		when 'float' then 'Nullable(Of Decimal)'
		when 'money' then 'Nullable(Of Decimal)'
		when 'int' then 'Nullable(Of integer)'
		when 'bit' then 'Short'
		when 'varbinary' then 'Byte'
		else 'Nullable(Of ' + convert(varchar,isnull(c.DATA_TYPE,'')) + ')'
		end	+ ' ' +	 CHAR(13) + char(9)+ char(9)+
		'	Get' + CHAR(13) + char(9)+ char(9)+
		'		return _' + c.COLUMN_NAME + CHAR(13) + char(9)+ char(9)+
		'	End Get' 
		campo
	from INFORMATION_SCHEMA.TABLES t	
			JOIN INFORMATION_SCHEMA.COLUMNS c ON
				t.TABLE_NAME = c.TABLE_NAME
			LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk on
				c.COLUMN_NAME = pk.COLUMN_NAME
				and t.TABLE_NAME = pk.TABLE_NAME
				and pk.CONSTRAINT_NAME like 'PK_%'
	where 	t.TABLE_NAME = @nomeClass
) AS T

union

select ROW_NUMBER() OVER (ORDER BY c.COLUMN_NAME) + 4 AS  ordem, 
	CHAR(13) + char(9)+ char(9)+
	'	Set(ByVal value As ' +
	case convert(varchar,isnull(c.DATA_TYPE,'')) 
	when 'varchar' then 'string'
	when 'text' then 'string'
	when 'char' then case when c.CHARACTER_MAXIMUM_LENGTH > 1 then 'string' else 'char' end
	when 'date' then 'Nullable(Of DateTime)'
	when 'smallint' then 'Nullable(Of integer)'
	when 'float' then 'Nullable(Of Decimal)'
	when 'money' then 'Nullable(Of Decimal)'
	when 'int' then 'Nullable(Of integer)'
	when 'bit' then 'Short'
	when 'varbinary' then 'Byte'
	else 'Nullable(Of ' + convert(varchar,isnull(c.DATA_TYPE,'')) + ')'
	end	+
	+ ')' + CHAR(13) + char(9)+ char(9)+
	case convert(varchar,isnull(c.DATA_TYPE,'')) 
	when 'varchar' then
		'		if value.Length > ' +  CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH) + ' then _' + c.COLUMN_NAME + ' = value.Substring(0,' +  CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH ) + ') else _' + c.COLUMN_NAME +  ' = value' + CHAR(13) + char(9)+ char(9)
	else
		'		_' + c.COLUMN_NAME + ' = value ' + CHAR(13) + char(9)+ char(9)
	end +
	'	End Set' + CHAR(13) + char(9)+
	'End Property' + CHAR(13) + CHAR(13) campo
from INFORMATION_SCHEMA.TABLES t	
		JOIN INFORMATION_SCHEMA.COLUMNS c ON
			t.TABLE_NAME = c.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk on
			c.COLUMN_NAME = pk.COLUMN_NAME
			and t.TABLE_NAME = pk.TABLE_NAME
			and pk.CONSTRAINT_NAME like 'PK_%'
where 	t.TABLE_NAME = @nomeClass


union

select 10000000,'End Class' 
) as tab
order by ordem

--select * from syscolumns where name = 'id'

