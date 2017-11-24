# frozen_string_literal: true

RSpec.configure do |conf|
  conf.around(:example, remove_const: true) do |example|
    const_before = Object.constants

    example.run

    const_after = Object.constants
    (const_after - const_before).each do |const|
      Object.send(:remove_const, const)
    end
  end
end

RSpec.describe 'Auto remove declared in spec constants' do
  it 'have no declared classes and structs in previous test' do
    expect(Object.constants).to_not include(:FakeUser)
    expect(Object.constants).to_not include(:Greeter)
  end

  it 'without the type flag do nothing' do
    FakeThing = Struct.new(:name)
    expect(Object.constants).to include(:FakeThing)
  end

  it 'allow to test declared in spec const', remove_const: true do
    FakeUser = Struct.new(:name)

    class Greeter
      def initialize(object)
        @object = object
      end

      def hello
        "Hello, my name is #{@object.name}"
      end
    end

    expect(Object.constants).to include(:FakeUser)
    expect(Object.constants).to include(:Greeter)
    expect(
      Greeter.new(FakeUser.new('Dmitry')).hello
    ).to eq('Hello, my name is Dmitry')
  end

  it 'have no declared classes and structs in next test' do
    expect(Object.constants).to_not include(:FakeUser)
    expect(Object.constants).to_not include(:Greeter)
  end

  it 'do not affect other constants' do
    expect(Object.constants).to include(:FakeThing)
  end
end

RSpec.describe 'Auto remove modules declared in spec' do
  it 'have no declared modules in previous test' do
    expect(Object.constants).to_not include(:Fake)
  end

  it 'without the type flag do nothing' do
    module Whatever
    end
    expect(Object.constants).to include(:Whatever)
  end

  it 'allow to test declared in spec const', remove_const: true do
    module Fake
      class User
        def initialize(name)
          @name = name
        end

        def hello
          "Hello, my name is #{@name}"
        end
      end
    end

    expect(Object.constants).to include(:Fake)
    expect(Fake.constants).to include(:User)
    expect(
      Fake::User.new('Dmitry').hello
    ).to eq('Hello, my name is Dmitry')
  end

  it 'have no declared modules in next test' do
    expect(Object.constants).to_not include(:Fake)
  end

  it 'do not affect other modules' do
    expect(Object.constants).to include(:Whatever)
  end
end
