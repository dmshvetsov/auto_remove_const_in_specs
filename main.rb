# frozen_string_literal: true

describe 'User view object' do
  around(:context) do |describe_block|
    # Fake class for Rails ActiveRecord model
    FakeUser = Struct.new(:name) do
      # Imitate ActiveRecord::base_class
      def self.base_class
        self.class
      end

      # Imitate ActiveRecord::primary_key
      def self.primary_key
        :id
      end

      # Imitate ActiveRecord#[]
      def [](_); end

      # Imitate Rails Object#present?
      def present?
        true
      end
    end

    # run specs
    describe_block.run

    # remove constant
    Object.send(:remove_const, :FakeUser)
    throw 'Fake constant not removed' if Object.constants.include?(:FakeUser)
  end

  it 'returns User name' do
    user = FakeUser.new('Dmitry')
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
