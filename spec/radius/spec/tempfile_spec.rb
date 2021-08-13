# frozen_string_literal: true

require 'radius/spec/tempfile'

RSpec.describe Radius::Spec::Tempfile do
  context "using the temp file helper in specs" do
    it "is not included by default" do
      expect {
        using_tempfile do
          # no-op
        end
      }.to raise_error NoMethodError
    end

    describe "via module inclusion" do
      include Radius::Spec::Tempfile

      it "includes the `using_tempfile` helper" do
        expect { |b| using_tempfile(&b) }.to yield_control
      end
    end

    describe "via matching metadata", ":tempfile", :tempfile do
      it "includes the `using_tempfile` helper" do
        expect { |b| using_tempfile(&b) }.to yield_control
      end
    end

    describe "via matching metadata", ":tmpfile", :tmpfile do
      it "includes the `using_tempfile` helper" do
        expect { |b| using_tempfile(&b) }.to yield_control
      end
    end
  end

  describe "using a tempfile" do
    it "requires a block" do
      expect {
        Radius::Spec::Tempfile.using_tempfile
      }.to raise_error LocalJumpError
    end

    it "yields a pathname to the provided block" do
      expect { |b|
        Radius::Spec::Tempfile.using_tempfile(&b)
      }.to yield_with_args(Pathname)
    end

    it "defaults to creating the tempfile in the OS tempdir" do
      expect { |b|
        Radius::Spec::Tempfile.using_tempfile(&b)
      }.to yield_with_args(
        be_a_file.and(
          be_readable
        ).and(
          be_writable
        ).and(
          have_attributes(to_path: start_with(Dir.tmpdir))
        )
      )
    end

    it "accepts a data string which is written to the file before yielding" do
      written_data = nil
      Radius::Spec::Tempfile.using_tempfile(data: <<~DATA) do |pathname|
        Any temp file data
      DATA

        written_data = pathname.read
      end

      expect(written_data).to eq "Any temp file data\n"
    end

    it "accepts optional options to provide when creating the `Tempfile`", :aggregate_failures do
      tmp_dir = Pathname(__dir__).join("..", "..", "..", "tmp").expand_path
      Dir.mkdir tmp_dir unless tmp_dir.exist?
      dirname = basename = written_data = nil

      Radius::Spec::Tempfile.using_tempfile(
        %w[custom_name .myext],
        tmp_dir,
        encoding: "ISO-8859-1",
        data: <<~DATA,
          Résumé
        DATA
      ) do |pathname|
        dirname, basename = pathname.split
        basename = basename.to_path
        written_data = pathname.read
      end

      expect(dirname).to eq tmp_dir
      expect(basename).to start_with("custom_name").and end_with(".myext")
      expect(written_data).not_to eq "Résumé\n"
      expect(written_data).to eq "R\xE9sum\xE9\n"
    end

    it "deletes the file after the block", :aggregate_failures do
      tmp_pathname = nil
      Radius::Spec::Tempfile.using_tempfile do |pathname|
        tmp_pathname = pathname
      end
      expect(tmp_pathname).not_to be_nil
      expect(tmp_pathname).not_to exist

      err_pathname = nil
      begin
        Radius::Spec::Tempfile.using_tempfile do |pathname|
          err_pathname = pathname
          raise "Any Error"
        end
      # TODO: Remove this disabling of the Lint/SuppressedException cop once we upgrade to rubocop 0.81.0,
      # where the `AllowComments` option is set to true by default.
      rescue # rubocop:disable Lint/SuppressedException
        # Ignore b/c we're testing behavior on raise so this is expected
      end
      expect(err_pathname).not_to be_nil
      expect(err_pathname).not_to exist
    end
  end
end
