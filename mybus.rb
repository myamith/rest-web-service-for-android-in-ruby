require 'dbi'
require 'oci8'

begin
dbh = DBI.connect('DBI:OCI8:MIGIDEV','user', 'password')
dbh.do( "INSERT INTO user_table(FROM_PLACE,TO_PLACE,START_TIME,CURRENT_TIME) VALUES ('app', 'amith', '11:30','12')" )
     puts "Record has been inserted"
     dbh.commit
rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
     dbh.rollback
ensure
     # disconnect from server
     dbh.disconnect if dbh
end
