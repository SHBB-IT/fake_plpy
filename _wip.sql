DO $$
    # set python environment
    CALL public.p_activate_venv_venv();
    # PL/Python code
	from csv import QUOTE_NONE
    from ftplib import FTP
    from io import BytesIO
    from urllib.request import urlopen

    import numpy as np
    import pandas as pd

	# ftp
	file_path = r"ftp://shwh1:{ADU40oD@sincerelyhers.synology.me/IT/AmazonReports"
	ftp = FTP('sincerelyhers.synology.me')
	ftp.login('shwh1', '{ADU40oD')
	# 
	dtype_map = {'character varying': 'object',
				 'text': 'object',
				 'integer': 'int',
				 'double precision': 'float',
				 'timestamp without time zone': 'datetime64',
				 'uuid': 'object',
				 'boolean': 'bool'}
	plpy.info('Process the active report types')
	report_types = plpy.execute('SELECT * FROM reporting.report_types WHERE odoo_ftp_active = True LIMIT 1;')
	for rtype in report_types:
		# create a string value of the enum for a table name
		table_name = f"_{rtype['enumeration'].lower()}_"
		# plpy.info(f"Report {rtype['report_type']}/{rtype['enumeration']}/{table_name}")
		model_info = plpy.execute(f"SELECT column_name, data_type FROM information_schema.columns where table_schema = %s"  
								  "AND table_name = %s " % (plpy.quote_literal("reporting"), plpy.quote_literal(table_name)))
		# prepare the ftp stream
		ftp_dir = str(rtype["enumeration"])
		ftp.cwd(f"/IT/AmazonReports{ftp_dir}")
		# which ftp file to use
		files = []
		ftp.retrlines('NLST', files.append)
		if files:
			files.sort(reverse=True)
			# expect most recent
			filename = files[0].strip()
			plpy.notice("Process report dataframe")
			request = urlopen(f"{file_path}/{ftp_dir}/{filename}")
			stream = BytesIO(request.read())
			# pandas
			df = pd.read_table(
				stream,
				delimiter="\t",
				encoding="latin1",
				low_memory=False,
				quoting=QUOTE_NONE,
				)
			if not df.empty:
				for _head in list(df.columns.values):
					_data_type = model_info[_head]['data_type']
					plpy.info(f"column: {model_info[_head]} ----> {_data_type}")

				# for row in model_info:
					# col_type = plpy.execute(f"SELECT pg_typeof(\"{col_name}\") FROM reporting.{table_name} LIMIT 1;")
					# plpy.info(f"column: {row['column_name']} ----> {dtype_map[row['data_type']]}")
				# plpy.info(f"Columns: {report_info.colnames()}")
				# plpy.info(f"Types: {report_info.coltypes()}")
$$
LANGUAGE plpython3u;