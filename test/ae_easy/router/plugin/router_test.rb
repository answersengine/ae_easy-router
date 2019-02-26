require 'test_helper'

describe 'plugin router' do
  before do
    @object = Object.new
    class << @object
      include AeEasy::Router::Plugin::Router
    end
    @expected_orig = {
      'aaa' => 111,
      'router' => {
        'parser' => {
          'routes' => [
            {
              'page_type' => 'type_a',
              'class' => 'AeEasy::Router::Test::ParserA'
            },
            {
              'page_type' => 'type_b',
              'class' => 'AeEasy::Router::Test::ParserB'
            }
          ]
        },
        'seeder' => {
          'routes' => [
            {'class' => 'AeEasy::Router::Test::SeederA'},
            {'class' => 'AeEasy::Router::Test::SeederB'}
          ]
        }
      },
      'bbb' => 222
    }
  end

  describe 'unit test' do
    it 'should validate when a class is defined' do
      refute @object.class_defined?('ABCDE')
      assert @object.class_defined?('AeEasy::Router::Test::ParserA')
    end

    it 'should get a class by name' do
      data = @object.get_class 'AeEasy::Router::Test::ParserA'
      assert_equal AeEasy::Router::Test::ParserA, data
    end

    it 'should give null when get an unexisting class by name' do
      data = @object.get_class 'ABCDE'
      assert_nil data
    end

    it 'should initialize with config object' do
      config = AeEasy::Config::Local.new file_path: './test/input/config.yaml'
      @object.initialize_hook_router_plugin_router config: config
      assert_equal @expected_orig, @object.local_config.local
      refute_nil config
      assert_equal config, @object.local_config
    end

    it 'should initialize with config file' do
      config = AeEasy::Config::Local.new file_path: './test/input/config.yaml'
      @object.initialize_hook_router_plugin_router config: config
      assert_equal @expected_orig['router'], @object.config
    end
  end
end
