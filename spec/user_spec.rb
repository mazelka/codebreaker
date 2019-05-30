require 'codebreaker/user'
require 'bundler/setup'
require 'spec_helper'

RSpec.describe User do
  context '#set_name' do
    let(:user) { User.new }

    it 'outputs message with name' do
      allow(user).to receive(:gets).and_return('Mary')
      expect { user.set_name }.to output(/Nice to meet you Mary!/).to_stdout
    end

    it 'prompts to enter name again' do
      allow(user).to receive(:gets).and_return('Ma', 'Mary')
      expect { user.set_name }.to output(/Name is not valid, try again/).to_stdout
    end
  end

  context '#name_valid?' do
    let(:user) { User.new }

    it 'is not valid if less then 3 symbols' do
      name = 'fo'
      expect(user.name_valid?(name)).to be_falsey
    end

    it 'is valid if from 3 to 20 symbols' do
      name = 'foo'
      expect(user.name_valid?(name)).to be_truthy
      name = 'fooooooooooooooooooo'
      expect(user.name_valid?(name)).to be_truthy
    end

    it 'is not valid if more then 20 symbols' do
      name = 'foooooooooooooooooooo'
      expect(user.name_valid?(name)).to be_falsey
    end
  end
end
