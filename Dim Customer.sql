--Cleaning Dim Customer table--
SELECT [CustomerKey] 
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      ,[FirstName]
      --,[MiddleName]
      ,[LastName]
	  ,FirstName+' ' + LastName As Fullname
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
      ,[Gender]
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      ----,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
      ,[DateFirstPurchase]
      ,[CommuteDistance]
	  , City as Customercity -- joined city from dim geography table
  FROM [dbo].[DimCustomer]as c
  left join [DimGeography] as g
  on g.GeographyKey = c.GeographyKey
  order by CustomerKey asc -- ordered list by Customerkey
