# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class DeviseMailerPreview < ActionMailer::Preview
  @user = Factory.create(:user)
  User.create(email: 'test_preview@example.com', password: 'password', password_confirmation: 'password')
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.last, "faketoken")
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(User.last, "faketoken")
  end

  def email_changed
    Devise::Mailer.email_changed(@user)
  end

  def password_changed
    Devise::Mailer.password_change(User.last)
  end
end
