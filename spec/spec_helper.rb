require "lita-bitbucket-pipelines"
require "lita/rspec"

# A compatibility mode is provided for older plugins upgrading from Lita 3. Since this plugin
# was generated with Lita 4, the compatibility mode should be left disabled.
Lita.version_3_compatibility_mode = false

def fixture(filename)
  File.read(File.join(__dir__, "fixtures", "#{filename}.json"))
end
