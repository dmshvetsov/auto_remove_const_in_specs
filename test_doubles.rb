# frozen_string_literal: true

describe 'User view object' do
  it 'returns User name' do
    user = double('User', name: 'Dmitry')
    view_object = UserView.new(user)
    expect(view_object.to_s).to eq('Username: Dmitry')
  end
end

# User model view object
class UserView
  def initialize(user)
    @user = user
  end

  def to_s
    "Username: #{@user.name}"
  end
end
