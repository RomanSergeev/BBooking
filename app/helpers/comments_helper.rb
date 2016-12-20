module CommentsHelper

  def self.commontator_name(user)
    user.profile.personaldata['name']
  end

end