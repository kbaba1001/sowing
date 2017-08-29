#  last_name   :string
#  first_name  :string
#
class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  has_one :profile
end
