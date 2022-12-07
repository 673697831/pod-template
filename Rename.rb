$LOAD_PATH << '.'
require 'TemplateConfigurator.rb'
require 'ConfigureSwift.rb'
require 'MessageBank.rb'
require 'ProjectManipulator.rb'

include Pod

class Sample
   def hello
      puts "Hello Ruby!"
   end
end

puts ARGV[0]
 
# 使用上面的类来创建对象
object = Sample.new
object.hello
config = TemplateConfigurator.new("sdsdg")
config.run
