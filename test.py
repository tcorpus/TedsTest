import pyodbc
import logging

# Configure logging
logging.basicConfig(filename='application_transfer.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Connection strings (update with actual server and credentials)
source_conn_str = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=your_source_server;DATABASE=BLApplication;Trusted_Connection=yes;'
dest_conn_str = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=your_dest_server;DATABASE=CVEngine;Trusted_Connection=yes;'

try:
    # Connect to source and destination databases
    source_conn = pyodbc.connect(source_conn_str)
    dest_conn = pyodbc.connect(dest_conn_str)
    source_cursor = source_conn.cursor()
    dest_cursor = dest_conn.cursor()
    logging.info("Connected to both databases successfully.")

    # Execute stored procedure to get latest applications
    source_cursor.execute("EXEC dbo.sp_GetLatestApplications")
    rows = source_cursor.fetchall()
    logging.info(f"Retrieved {len(rows)} applications from source database.")

    # Process each application
    for row in rows:
        submission_id = row.SubmissionID
        application_json = row.ApplicationJSON
        logging.info(f"Processing SubmissionID: {submission_id}")

        # Call destination stored procedure to insert JSON
        dest_cursor.execute("EXEC obus.sp_InsertJSONBLApplicationToCV ?", application_json)
        result = dest_cursor.fetchone()
        success = result.Success
        message = result.Message
        logging.info(f"Insert result for {submission_id}: Success={success}, Message={message}")

        # Log result back to source database
        source_cursor.execute("EXEC dbo.sp_logApplicationExport ?, ?, ?", submission_id, success, message)
        source_conn.commit()
        logging.info(f"Logged export result for {submission_id} to source database.")

except Exception as e:
    logging.error(f"An error occurred: {e}")

finally:
    # Close all connections
    if 'source_cursor' in locals(): source_cursor.close()
    if 'dest_cursor' in locals(): dest_cursor.close()
    if 'source_conn' in locals(): source_conn.close()
    if 'dest_conn' in locals(): dest_conn.close()
    logging.info("Database connections closed.")
