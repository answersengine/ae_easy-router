require 'test_helper'

describe 'finisher' do
  describe 'unit test' do
    before do
      @context = Object.new
      @config = AeEasy::Config::Local.new file_path: './test/input/config.yaml'
      @router = AeEasy::Router::Finisher.new config: @config
    end

    it 'should raise error on route when no context' do
      assert_raises(ArgumentError, 'Must send a context to the finisher.') do
        @router.route
      end
    end

    it 'should raise error on route when class doesn\'t exists' do
      router = AeEasy::Router::Finisher.new config_file_path: './test/input/config_bad.yaml'
      assert_raises(NameError, "Class \"LMNOP\" doesn't exists, check your ae_easy config file.") do
        router.route context: @context
      end
    end

    it 'should route to all finishers' do
      AeEasy::Router::Test::FinisherBase.mock_clear_data
      @router.route context: @context
      data = AeEasy::Router::Test::FinisherBase.mock_data
      expected = {
        init_opts: {
          context: @context
        },
        finish: true
      }
      assert_equal expected, data['AeEasy::Router::Test::FinisherA']
      assert_equal expected, data['AeEasy::Router::Test::FinisherB']
    end
  end
end
