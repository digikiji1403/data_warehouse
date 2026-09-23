-- =========================================================
-- Loading silver.erp_cust_az12
-- =========================================================
DECLARE 
    @start_time DATETIME,
    @end_time DATETIME,
    @batch_start_time DATETIME,
    @batch_end_time DATETIME;
SET @start_time = GETDATE();

PRINT '>> Truncating Table: silver.erp_cust_az12';

TRUNCATE TABLE silver.erp_cust_az12;

PRINT '>> Inserting Data Into: silver.erp_cust_az12';

INSERT INTO silver.erp_cust_az12
(
    cid,
    bdate,
    gen
)

SELECT

    -- Remove NAS prefix
    CASE
        WHEN cid LIKE 'NAS%'
            THEN SUBSTRING(cid, 4, LEN(cid))

        ELSE cid
    END AS cid,

    -- Convert integer date YYYYMMDD into DATE
    CASE
        WHEN bdate IS NULL
            THEN NULL

        WHEN TRY_CONVERT(
                DATE,
                CONVERT(VARCHAR(8), bdate),
                112
             ) > CAST(GETDATE() AS DATE)
            THEN NULL

        ELSE TRY_CONVERT(
                DATE,
                CONVERT(VARCHAR(8), bdate),
                112
             )
    END AS bdate,

    -- Normalize Gender
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE')
            THEN 'Female'

        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')
            THEN 'Male'

        ELSE 'n/a'
    END AS gen

FROM bronze.erp_cust_az12;


SET @end_time = GETDATE();

PRINT '>> Load Duration: '
    + CAST(
        DATEDIFF(
            SECOND,
            @start_time,
            @end_time
        ) AS NVARCHAR
    )
    + ' seconds';

PRINT '>> -------------';
