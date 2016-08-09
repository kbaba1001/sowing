require_relative '../db_setup'

#  last_name   :string
#  first_name  :string
#
class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
end
