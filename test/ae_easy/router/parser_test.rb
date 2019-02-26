require 'test_helper'

describe 'parser' do
  describe 'unit test' do
    before do
      @context = Object.new
      class << @context
        define_method(:page){@page}
        define_method(:set_page){|value| @page = value}
      end
      @config = AeEasy::Config::Local.new file_path: './test/input/config.yaml'
      @router = AeEasy::Router::Parser.new config: @config
    end

    it 'should raise error on route when no context' do
      assert_raises(ArgumentError, 'Must send a context to the parser.') do
        @router.route
      end
    end

    it 'should raise error on route when class doesn\'t exists' do
      @context.set_page('page_type' => 'fake_type')
      router = AeEasy::Router::Parser.new config_file_path: './test/input/config_bad.yaml'
      assert_raises(NameError, "Class \"ABCDE\" doesn't exists, check your ae_easy config file.") do
        router.route context: @context
      end
    end

    it 'should raise error on route when no matching page_type' do
      @context.set_page('page_type' => 'abcde')
      assert_raises(ArgumentError, "Page type \"abcde\" is not routed, check your ae_easy config file.") do
        @router.route context: @context
      end
    end

    describe 'route' do
      it 'should route to parser A' do
        @context.set_page('page_type' => 'type_a')
        AeEasy::Router::Test::ParserBase.mock_clear_data
        @router.route context: @context
        data = AeEasy::Router::Test::ParserBase.mock_data
        expected = {
          init_opts: {
            context: @context
          },
          parse: true
        }
        assert_nil data['AeEasy::Router::Test::ParserB']
        assert_equal expected, data['AeEasy::Router::Test::ParserA']
      end

      it 'should route to parser B' do
        @context.set_page('page_type' => 'type_b')
        AeEasy::Router::Test::ParserBase.mock_clear_data
        @router.route context: @context
        data = AeEasy::Router::Test::ParserBase.mock_data
        expected = {
          init_opts: {
            context: @context
          },
          parse: true
        }
        assert_nil data['AeEasy::Router::Test::ParserA']
        assert_equal expected, data['AeEasy::Router::Test::ParserB']
      end
    end
  end
end
