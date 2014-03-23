class User < ActiveRecord::Base
  def self.create_new_user(auth_data)
    @user = User.new(
      :uid => auth_data.uid,
      :username => auth_data.info.nickname,
      :profile_photo => auth_data.info.image,
      :access_token => auth_data.credentials.token,
      :access_token_secret => auth_data.credentials.secret
    )
    @user.save
    @user
  end
end
