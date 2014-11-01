require 'rubygems'
require 'sinatra'
require 'json'
require 'dbi'
require 'oci8'

get '/' do
  "Hello, World!"
end


  class String
  def is_json?
    begin
      !!JSON.parse(self)
    rescue
      false
    end
  end
end


put '/app', :provides => :json do 
  input_data = request.body.read
  
  
   if  input_data.is_json?
        data = JSON.parse input_data
        puts  data
        from_place=data['FROM_PLACE']
        to_place=data['TO_PLACE']
        start_time=data['START_TIME']
        current_time=data['CURRENT_TIME']
        begin
        dbh = DBI.connect('DBI:OCI8:MIGIDEV','SCMTOOLS', 'scm#wft00l')

        sth = dbh.prepare( "INSERT INTO user_table(FROM_PLACE,TO_PLACE,START_TIME,CURRENT_TIME) VALUES (?,?,?,?)" )
        sth.execute(from_place,to_place,start_time,current_time)
        sth.finish
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
        
         
        response_result = data
        response_status = "200"  
   else
        response_result = "Invalid JSON input"
        response_status = "400"
   end
    response_body = {:response => response_result }.to_json
    content_type :json 
    status response_status
    body response_body
  
end

