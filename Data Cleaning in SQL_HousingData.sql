/*

Data Cleaning in SQL

*/

SELECT *
  FROM [HousingData].[dbo].[NashvilleHousing$]


  -------------------------------------------------------------------------------
--Srandardize data format

Select SaleDate , Convert(Date, SaleDate)
From [HousingData].[dbo].[NashvilleHousing$]

Update NashvilleHousing$
Set SaleDate = Convert(Date, SaleDate)

Alter Table NashvilleHousing$ 
Add SaleDateConverted Date;

Update NashvilleHousing$ 
Set SaleDateConverted = Convert(Date, SaleDate);

Select SaleDateConverted , Convert(Date, SaleDate)
From  [HousingData].[dbo].[NashvilleHousing$]


-------------------------------------------------------------------------------
--Populate Property Adress Date

Select PropertyAddress
From [HousingData].[dbo].[NashvilleHousing$]
Where PropertyAddress is null

Select *
From [HousingData].[dbo].[NashvilleHousing$]
order by ParcelID

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress
From [HousingData].[dbo].[NashvilleHousing$] a
join [HousingData].[dbo].[NashvilleHousing$] b
 on a.ParcelID=b.ParcelID
  And a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null

  Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From [HousingData].[dbo].[NashvilleHousing$] a
join [HousingData].[dbo].[NashvilleHousing$] b
 on a.ParcelID=b.ParcelID
  And a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null

  Update a
  Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
  From [HousingData].[dbo].[NashvilleHousing$] a
join [HousingData].[dbo].[NashvilleHousing$] b
 on a.ParcelID=b.ParcelID
  And a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null


  -------------------------------------------------------------------------------
-- Breakind out Adress into individual column (Adress,City,State)

--1)PropertyAdress

Select PropertyAddress
From [HousingData].[dbo].[NashvilleHousing$]

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Adress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))As City

From [HousingData].[dbo].[NashvilleHousing$]

Alter Table NashvilleHousing$ 
Add PropertySplitAdress Nvarchar(255);

Update NashvilleHousing$ 
Set PropertySplitAdress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

Alter Table NashvilleHousing$ 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing$ 
Set PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress));

Select *
From [HousingData].[dbo].[NashvilleHousing$]

--2) OwnerAdress

Select OwnerAddress
From [HousingData].[dbo].[NashvilleHousing$]

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From [HousingData].[dbo].[NashvilleHousing$]

Alter Table NashvilleHousing$ 
Add OwnerSplitAdress Nvarchar(255);

Update NashvilleHousing$ 
Set OwnerSplitAdress  = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

Alter Table NashvilleHousing$ 
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing$ 
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

Alter Table NashvilleHousing$ 
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing$ 
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

Select *
From [HousingData].[dbo].[NashvilleHousing$]



 -------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [HousingData].[dbo].[NashvilleHousing$]
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From [HousingData].[dbo].[NashvilleHousing$]

Update NashvilleHousing$
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End


-------------------------------------------------------------------------------
--Remove Duplicates


Select *,
	ROW_NUMBER() Over(
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) Row_no
From [HousingData].[dbo].[NashvilleHousing$]
Order By ParcelID


With RowNumCTE As(
	Select *,
	ROW_NUMBER() Over(
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) Row_no
From [HousingData].[dbo].[NashvilleHousing$]
)
Select *
From RowNumCTE
Where Row_no >1
Order By PropertyAddress


With RowNumCTE As(
	Select *,
	ROW_NUMBER() Over(
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) Row_no
From [HousingData].[dbo].[NashvilleHousing$]
)
Delete
From RowNumCTE
Where Row_no >1
--Order By PropertyAddress



-------------------------------------------------------------------------------
--Delete Unused Columns

Alter Table [HousingData].[dbo].[NashvilleHousing$]
Drop Column PropertyAddress,  OwnerAddress,TaxDistrict

Alter Table [HousingData].[dbo].[NashvilleHousing$]
Drop Column SaleDate

SELECT *
  FROM [HousingData].[dbo].[NashvilleHousing$]











