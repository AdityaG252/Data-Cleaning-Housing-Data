--Clensing Dim Product table--
SELECT  [ProductKey]
      ,[ProductAlternateKey] As ProductItemCode
      --,[ProductSubcategoryKey]
      --,[WeightUnitMeasureCode]
      --,[SizeUnitMeasureCode]
      ,[EnglishProductName] As ProductName
      --,[SpanishProductName]
      --,[FrenchProductName]
      --,[StandardCost]
      --,[FinishedGoodsFlag]
      ,[Color] As ProductColor
      --,[SafetyStockLevel]
      --,[ReorderPoint]
      --,[ListPrice]
      ,[Size] As ProductSize
      --,[SizeRange]
      --,[Weight]
      --,[DaysToManufacture]
      ,[ProductLine] As ProductLine
      --,[DealerPrice]
      --,[Class]
      --,[Style]
      ,[ModelName] As ProductModelName
      --,[LargePhoto]
      ,[EnglishDescription] as ProductDescription
      --,[FrenchDescription]
      --,[ChineseDescription]
      --,[ArabicDescription]
      --,[HebrewDescription]
      --,[ThaiDescription]
      --,[GermanDescription]
      --,[JapaneseDescription]
      --,[TurkishDescription]
      --,[StartDate]
      --,[EndDate]
      ,ISNULL(Status, 'Outdated') As ProductStatus
	  , EnglishProductSubcategoryName As SubCategory -- joined sub categoryname form Porductsubcategory table
	  ,EnglishProductCategoryName as Category --joined sub categoryname form Porductcategory table
  FROM [AdventureWorksDW2022].[dbo].[DimProduct] as p
  left join DimProductSubcategory as ps on p.ProductSubcategoryKey=ps.ProductSubcategoryKey
  left join DimProductCategory as pc on ps.ProductCategoryKey =pc.ProductCategoryKey
  order by ProductKey asc