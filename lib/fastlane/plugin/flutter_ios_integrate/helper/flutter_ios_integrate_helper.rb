require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class FlutterIosIntegrateHelper
      # class methods that you define here become available in your action
      # as `Helper::FlutterIosIntegrateHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the flutter_ios_integrate plugin helper!")
      end
    end
  end
end
