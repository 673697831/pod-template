module Pod

  class ConfigureSwift
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform
      keep_demo = :yes

      #configurator.set_test_framework "xctest", "swift", "swift"

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :xcodeproj_path => "PROJECT/PROJECT.xcodeproj",
        :platform => :ios,
        :remove_demo_project => (keep_demo == :no),
        :prefix => ""
      }).run

      # There has to be a single file in the Classes dir
      # or a framework won't be created
      #`touch Pod/Classes/ReplaceMe.swift`

      #`mv ./templates/swift/* ./`

      # remove podspec for osx
      #`rm ./NAME-osx.podspec`
    end
  end

end
