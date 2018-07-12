CREATE PROCEDURE SPPhanTrang_Table (@PageNumber int, @PageSize int) 
	AS DECLARE @start int, @end int
	BEGIN TRANSACTION GetDataSet
		SET @start = (((@PageNumber - 1) * @PageSize) + 1)
		IF @@ERROR <> 0
			GOTO ErrorHandler
		
		SET @end = (@start + @PageSize - 1)
		IF @@ERROR <> 0
			GOTO ErrorHandler
		
		CREATE TABLE #TemporaryTable (
			Row int IDENTITY (1, 1) PRIMARY KEY,
			CustomerID nchar(5),
			CompanyName nvarchar(40)
		)
		IF @@ERROR <> 0
			GOTO ErrorHandler

		INSERT INTO #TemporaryTable
			SELECT CustomerID, CompanyName
			FROM Customers
		IF @@ERROR <> 0
			GOTO ErrorHandler
		
		SELECT CustomerID, CompanyName
		FROM #TemporaryTable
		WHERE (Row >= @start) AND (Row <= @end)
		IF @@ERROR <> 0
			GOTO ErrorHandler
		
	DROP TABLE #TemporaryTable
	COMMIT TRANSACTION GetDataSet
	RETURN 0

ErrorHandler:
	ROLLBACK TRANSACTION GetDataSet
	RETURN @@ERROR

EXEC SPPhanTrang_Table 2, 20

Select * from Customers
