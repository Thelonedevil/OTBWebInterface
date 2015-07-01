class Command < ActiveRecord::Base
  self.primary_key='name'
  self.table_name ='tblCommands'
end
