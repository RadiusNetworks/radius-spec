# frozen_string_literal: true

require 'pathname'
require 'tempfile'

module Radius
  module Spec
    # Temporary file helpers
    #
    # These helpers are meant to ease the creation of temporary files to either
    # stub the data out or provide a location for data to be saved then
    # verified.
    #
    # In the case of file stubs, using these helpers allows you to co-locate
    # the file data with the specs. This makes it easy for someone to read the
    # spec and understand the test case; instead of having to find a fixture
    # file and look at its data. This also makes it easy to change the data
    # between specs, allowing them to focus on just what they need.
    #
    # To make these helpers available require them after the gem:
    #
    # ```ruby
    # require 'radius/spec'
    # require 'radius/spec/tempfile'
    # ```
    #
    # ### Including Helpers in Specs
    #
    # There are multiple ways you can use these helpers. Which method you
    # choose depends on how much perceived magic/syntactic sugar you want:
    #
    #   - call the helpers directly on the module
    #   - manually include the helper methods in the specs
    #   - use metadata to auto load this feature and include it in the specs
    #
    # When using the metadata option you do not need to explicitly require the
    # module. This gem registers metadata with the RSpec configuration when it
    # loads and `RSpec` is defined. When the matching metadata is first used it
    # will automatically require and include the helpers.
    #
    # Any of following metadata will include the factory helpers:
    #
    #   - `:tempfile`
    #   - `:tmpfile`
    #
    # @example use a helper directly in specs
    #   require 'radius/spec/tempfile'
    #
    #   RSpec.describe AnyClass do
    #     it "includes the file helpers" do
    #       Radius::Spec::Tempfile.using_tempfile do |pathname|
    #         code_under_test pathname
    #         expect(pathname.read).to eq "Any written data"
    #       end
    #     end
    #   end
    # @example manually include the helpers
    #   require 'radius/spec/tempfile'
    #
    #   RSpec.describe AnyClass do
    #     include Radius::Spec::Tempfile
    #     it "includes the file helpers" do
    #       using_tempfile do |pathname|
    #         code_under_test pathname
    #         expect(pathname.read).to eq "Any written data"
    #       end
    #     end
    #   end
    # @example use metadata to auto include the helpers
    #   RSpec.describe AnyClass do
    #     it "includes the file helpers", :tempfile do
    #       using_tempfile do |pathname|
    #         code_under_test pathname
    #         expect(pathname.read).to eq "Any written data"
    #       end
    #     end
    #   end
    # @since 0.5.0
    module Tempfile
    module_function

      # Convenience wrapper for managaing temporary files.
      #
      # This creates a temporary file and yields its path to the provided
      # block. When the block returns the temporary file is deleted.
      #
      # ### Optional Parameters
      #
      # The block is required. All other parameters are optional. All
      # parameters except `data` are Ruby version dependent and will be
      # forwarded directly to the stdlib's
      # {https://ruby-doc.org/stdlib/libdoc/tempfile/rdoc/Tempfile.html#method-c-create
      # `Tempfile.create`}. The when the `data` parameter is provided it's
      # contents will be written to the temporary file prior to yielding to the
      # block.
      #
      # @example creating a tempfile to pass to code
      #   def write_hello_world(filepath)
      #     File.write filepath, "Hello World"
      #   end
      #
      #   Radius::Spec::Tempfile.using_tempfile do |pathname|
      #     write_hello_world pathname
      #   end
      # @example creating a file stub
      #   stub_data = "Any file stub data text."
      #   Radius::Spec::Tempfile.using_tempfile(data: stub_data) do |stubpath|
      #     # File.read(stubpath)
      #     # => "Any file stub data text."
      #     code_under_test stubpath
      #   end
      # @example creating a file stub inline
      #   Radius::Spec::Tempfile.using_tempfile(data: <<~TEXT) do |stubpath|
      #     Any file stub data text.
      #   TEXT
      #     # File.read(stubpath)
      #     # => "Any file stub data text.\n"
      #     code_under_test stubpath
      #   end
      # @example creating a file stub inline without trailing newline
      #   Radius::Spec::Tempfile.using_tempfile(data: <<~TEXT.chomp) do |stubpath|
      #     Any file stub data text.
      #   TEXT
      #     # File.read(stubpath)
      #     # => "Any file stub data text."
      #     code_under_test stubpath
      #   end
      # @example writing binary data inline
      #   Radius::Spec::Tempfile.using_tempfile(encoding: Encoding::BINARY, data: <<~BIN.chomp) do |binpath|
      #     \xC8\x90\xC5\x9D\xE1\xB9\x95\xC4\x93\xC4\x89
      #   BIN
      #     # File.read(binpath)
      #     # => "Ȑŝṕēĉ"
      #     code_under_test binpath
      #   end
      # @param args [Object] addition file creation options
      #
      #   Passed directly to {https://ruby-doc.org/stdlib/libdoc/tempfile/rdoc/Tempfile.html#method-c-create
      #   `Tempfile.create`}; see the stdlib docs for details on available
      #   options.
      # @param data [String] stub data to write to the file before yielding
      # @param kwargs [Hash{Symbol => Object}] addition file creation options
      #
      #   Passed directly to {https://ruby-doc.org/stdlib/libdoc/tempfile/rdoc/Tempfile.html#method-c-create
      #   `Tempfile.create`}; see the stdlib docs for details on available
      #   options.
      # @yieldparam pathname [Pathname] {https://ruby-doc.org/stdlib/libdoc/pathname/rdoc/Pathname.html path}
      #   of the created temporary file
      # @note A block must be provided
      # @see https://ruby-doc.org/stdlib/libdoc/pathname/rdoc/Pathname.html Pathname
      # @see https://ruby-doc.org/stdlib/libdoc/tempfile/rdoc/Tempfile.html Tempfile
      def using_tempfile(*args, data: nil, **kwargs)
        args << 'tmpfile' if args.empty?
        ::Tempfile.create(*args, **kwargs) do |f|
          f.write(data)
          f.close
          yield Pathname(f.path)
        end
      end
    end
  end
end
