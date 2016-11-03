declare @nomeClass varchar(100)
				
set @nomeClass = 'Perfil'

select campo from(
select 1 ordem, 
		'using System;' + CHAR(13) +
		'using MyArchitecture;' + CHAR(13) +
		 CHAR(13) + '[Serializable()] ' + 
		 CHAR(13) + 'public class DTO' + 
		o.name + ' : DTO' + CHAR(13) + '{' as campo
from sysobjects o
where o.name = @nomeClass 

 

union

select 2 ordem, 
	char(9)+ 'private ' +
	case convert(varchar,isnull(c.DATA_TYPE,'')) 
	when 'varchar' then 'string'
	when 'text' then 'string'
	when 'char' then case when c.CHARACTER_MAXIMUM_LENGTH > 1 then 'string' else 'char' end
	when 'date' then 'DateTime?'
	when 'datetime' then 'DateTime?'
	when 'smallint' then 'int?'
	when 'float' then 'decimal?'
	when 'money' then 'decimal?'
	when 'int' then 'int?'
	when 'bit' then 'bool'
	when 'varbinary' then 'byte'
	else '' + convert(varchar,isnull(c.DATA_TYPE,'')) + '?'
	end	+
	' _' + c.COLUMN_NAME + ';'
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
		char(9)+ '[ParametersAttribute(' +
		case when not pk.COLUMN_NAME is null then 'Key=true,' else '' end + 
	
		(select case when COUNT(*) = 0 then '' else 
			'ForeignKey="' + t.TABLE_NAME + '.' + c.COLUMN_NAME  + ' = ' + Max(pk.TABLE_NAME) + '.' + Max(pk.COLUMN_NAME)  + '",' end 
		from INFORMATION_SCHEMA.KEY_COLUMN_USAGE fk
			inner join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rel on 
				fk.CONSTRAINT_NAME = rel.CONSTRAINT_NAME
			inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk on
				rel.UNIQUE_CONSTRAINT_NAME = pk.CONSTRAINT_NAME 
		where fk.CONSTRAINT_NAME like 'FK_%' 
			and fk.COLUMN_NAME =c.COLUMN_NAME 
			and t.TABLE_NAME = fk.TABLE_NAME) +
	
		'Type=DTOType.' +
		case convert(varchar,isnull(c.DATA_TYPE,'')) 
		when 'varchar' then 'dbVarchar,Length=' + CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH) 
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
						',Length=' + CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH) end
		 + ')] ' + CHAR(13) + CHAR(9) +
		'public ' +
		case convert(varchar,isnull(c.DATA_TYPE,'')) 
		when 'varchar' then 'string'
		when 'text' then 'string'
		when 'char' then case when c.CHARACTER_MAXIMUM_LENGTH > 1 then 'string' else 'char' end
		when 'date' then 'DateTime?'
		when 'datetime' then 'DateTime?'
		when 'smallint' then 'int?'
		when 'float' then 'decimal?'
		when 'money' then 'decimal?'
		when 'int' then 'int?'
		when 'bit' then 'bool'
		when 'varbinary' then 'Byte'
		else convert(varchar,isnull(c.DATA_TYPE,'')) + '?'
		end	+ ' '  +	
		c.COLUMN_NAME + '{  ' +
		 CHAR(13) + char(9)+ 
		'	get{' + CHAR(13) + char(9)+ 
		'		return _' + c.COLUMN_NAME + ';' +CHAR(13) + char(9)+ char(9)+
		'}' 
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
	CHAR(13) + char(9)+ 
	'	set{' + CHAR(13) + char(9)+ 
	case convert(varchar,isnull(c.DATA_TYPE,'')) 
	when 'varchar' then
		'		if(value.Length > ' +  CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH) + ') _' + c.COLUMN_NAME + ' = value.Substring(0,' +  CONVERT(varchar,c.CHARACTER_MAXIMUM_LENGTH ) + '); else _' + c.COLUMN_NAME +  ' = value;' + CHAR(13) + char(9)+ char(9)
	else
		'		_' + c.COLUMN_NAME + ' = value; ' + CHAR(13) + char(9)+ char(9)
	end +
	'}' + CHAR(13) + char(9)+
	'}' + CHAR(13) + CHAR(13) campo
from INFORMATION_SCHEMA.TABLES t	
		JOIN INFORMATION_SCHEMA.COLUMNS c ON
			t.TABLE_NAME = c.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE pk on
			c.COLUMN_NAME = pk.COLUMN_NAME
			and t.TABLE_NAME = pk.TABLE_NAME
			and pk.CONSTRAINT_NAME like 'PK_%'
where 	t.TABLE_NAME = @nomeClass


union

select 10000000,'}' 
) as tab
order by ordem

--select * from syscolumns where name = 'id'

