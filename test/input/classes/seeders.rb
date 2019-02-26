module AeEasy
  module Router
    module Test
      module SeederBase
        attr_reader :mock_init_options

        def self.mock_data
          @@mock_data ||= Concurrent::Hash.new
          @@mock_data[Thread.current.object_id] ||= {}
        end

        def self.mock_clear_data
          mock_data.clear
        end

        def class_name
          self.class.name
        end

        def initialize opts = {}
          AeEasy::Router::Test::SeederBase.mock_data[class_name] ||= {}
          AeEasy::Router::Test::SeederBase.mock_data[class_name][:init_opts] = opts
        end

        def seed
          AeEasy::Router::Test::SeederBase.mock_data[class_name][:seed] = true
        end
      end

      class SeederA
        include AeEasy::Router::Test::SeederBase

        def class_name
          self.class.name
        end
      end

      class SeederB
        include AeEasy::Router::Test::SeederBase

        def class_name
          self.class.name
        end
      end
    end
  end
end