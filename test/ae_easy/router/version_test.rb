require 'test_helper'

describe 'version' do
  it "has a version number" do
    refute_nil AeEasy::Router::VERSION
  end
end
