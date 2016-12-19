class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :create_calendar
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
  has_one :profile
  has_one :calendar
  has_many :services
  acts_as_commontator
  acts_as_commontable

  def create_calendar
    Calendar.create user_id: self.id, preferences:
      '{"serving_start": "540", "break_start": "720", "break_finish": "780", "serving_finish": "1080"}'
  end

end