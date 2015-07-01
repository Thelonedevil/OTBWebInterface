
class Alias < ActiveRecord::Base
  self.primary_key='name'
  self.table_name ='tblAliases'
end