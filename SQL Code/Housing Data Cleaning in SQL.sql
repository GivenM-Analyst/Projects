SELECT *
FROM NashvilleHousing

--Standardize Date format

Select SaleDate , CONVERT(Date,SaleDate)
From NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT (Date, SaleDate)

--Alter Date since it didnt update properly
ALTER TABLE NashvilleHousing
 Add SaleConvertedDate Date;

 Update NashvilleHousing
SET SaleConvertedDate = CONVERT(Date,SaleDate)

--Populate Property Address Data

Select *
From NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress ,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is null

 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 From NashvilleHousing a
JOIN NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is null


 --Breaking down Address into individual columns (Address, City, State)

 Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address


SELECT*
From PortfolioProject.dbo.NashvilleHousing


SELECT OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT*
From PortfolioProject.dbo.NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() over (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
		
		From PortfolioProject.dbo.NashvilleHousing
		--order by ParcelID
		)

		SELECT*
		FROM RowNumCTE
		Where row_num > 1
		--order by PropertyAddress

		--Delete unused columns
				
SELECT*
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

























