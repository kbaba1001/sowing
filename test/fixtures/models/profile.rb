# user_id  :integer
# address  :string
# phone    :string
#
class Profile < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :phone
end
