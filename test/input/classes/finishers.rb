module AeEasy
  module Router
    module Test
      module FinisherBase
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
          AeEasy::Router::Test::FinisherBase.mock_data[class_name] ||= {}
          AeEasy::Router::Test::FinisherBase.mock_data[class_name][:init_opts] = opts
        end

        def finish
          AeEasy::Router::Test::FinisherBase.mock_data[class_name][:finish] = true
        end
      end

      class FinisherA
        include AeEasy::Router::Test::FinisherBase

        def class_name
          self.class.name
        end
      end

      class FinisherB
        include AeEasy::Router::Test::FinisherBase

        def class_name
          self.class.name
        end
      end
    end
  end
end
