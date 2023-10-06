DROP MATERIALIZED VIEW IF EXISTS public.amz_sku_economics;
DROP VIEW IF EXISTS public.demdaco_fba_inventory;
DROP VIEW IF EXISTS public.demdaco_cat_stat_mat;
DROP MATERIALIZED VIEW IF EXISTS public.cat_stat_asin_mat;

DROP MATERIALIZED VIEW IF EXISTS public.cat_stat_mat;
DROP VIEW IF EXISTS public.us_fulfillable;
DROP VIEW IF EXISTS public.canada_fulfillable;
DROP VIEW IF EXISTS public.mx_fulfillable;

-- for table _get_merchant_listings_all_data_ 

DROP VIEW IF EXISTS public.canada_vendor_sku_info
DROP VIEW IF EXISTS public.mx_vendor_sku_info
DROP VIEW IF EXISTS public.us_vendor_sku_info
DROP MATERIALIZED VIEW IF EXISTS public.monthly_order_history_mat;

DROP VIEW IF EXISTS public.all_skus;
DROP VIEW IF EXISTS public.canada_all_skus;
DROP VIEW IF EXISTS public.mx_all_skus;
DROP VIEW IF EXISTS public.us_all_skus;
DROP VIEW IF EXISTS public.us_product_names;
DROP VIEW IF EXISTS public.mx_product_names;
DROP VIEW IF EXISTS public.canada_product_names;


-----------------------------------
--- SHdb
-----------------------------------
ALTER TABLE reporting.report_types ADD COLUMN odoo_ftp_active BOOLEAN;

COMMENT ON COLUMN reporting.report_types.odoo_ftp_active
    IS 'FTP from Odoo is Active?';
	
UPDATE reporting.report_types SET odoo_ftp_active = 'f';
ALTER TABLE reporting.report_types ALTER COLUMN odoo_ftp_active SET NOT NULL;
ALTER TABLE reporting.report_types ALTER COLUMN odoo_ftp_active SET DEFAULT FALSE;

UPDATE reporting.report_types SET odoo_ftp_active = 't'
 WHERE enumeration IN ('GET_AFN_INVENTORY_DATA_BY_COUNTRY', 'GET_FBA_ESTIMATED_FBA_FEES_TXT_DATA',
					  'GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA', 'GET_MERCHANT_LISTINGS_ALL_DATA',
					  'GET_MERCHANT_LISTINGS_DATA');
					  

IMPORT FOREIGN SCHEMA public LIMIT TO (
	_get_afn_inventory_data_by_country_,
	_get_fba_estimated_fba_fees_txt_data_,
	_get_fba_inventory_planning_data_,
	_get_fba_myi_unsuppressed_inventory_data_,
	_get_merchant_listings_all_data_,
	_get_merchant_listings_data_
	) FROM SERVER advertising_server INTO reporting;


