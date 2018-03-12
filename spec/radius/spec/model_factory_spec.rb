# frozen_string_literal: true

require 'radius/spec/model_factory'

RSpec.describe Radius::Spec::ModelFactory do
  before do
    Radius::Spec::ModelFactory.templates.clear
  end

  describe "defining a factory", "through the module" do
    it "supports the explicit `define_factory` and shorter `factory` APIs" do
      expect {
        Radius::Spec::ModelFactory.define_factory("AnyClass")
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")

      expect {
        Radius::Spec::ModelFactory.factory("AnotherClass")
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnotherClass")
    end

    it "supports registering class names as strings" do
      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")
    end

    it "supports registering class names as symbols" do
      expect {
        Radius::Spec::ModelFactory.factory(
          :AnyClass,
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")
    end

    it "supports registering class constants" do
      stub_const "AnyClass", Struct.new(:arg1, :arg2, keyword_init: true)

      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to include("AnyClass")
    end

    it "registers the attributes to the class" do
      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Any Value",
          arg2: "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to(
        "AnyClass" => {
          arg1: "Any Value",
          arg2: "Any Other Value",
        }
      )
    end

    it "replaces any existing attributes for the class" do
      Radius::Spec::ModelFactory.factory(
        "AnyClass",
        arg1: "Any Value",
        arg2: "Any Other Value",
      )

      expect {
        Radius::Spec::ModelFactory.factory(
          "AnyClass",
          arg1: "Updated Value",
          arg2: "Updated Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.from(
        "AnyClass" => {
          arg1: "Any Value",
          arg2: "Any Other Value",
        }
      ).to(
        "AnyClass" => {
          arg1: "Updated Value",
          arg2: "Updated Other Value",
        }
      )
    end

    it "duplicates the registered attribute hash", :aggregate_failures do
      orig_attrs = {
        arg1: "Any Value",
        arg2: "Any Other Value",
      }
      Radius::Spec::ModelFactory.factory "AnyClass", orig_attrs

      registered_attrs = Radius::Spec::ModelFactory.templates["AnyClass"]
      expect(registered_attrs).to eq orig_attrs
      expect(registered_attrs).not_to be orig_attrs
      expect {
        orig_attrs[:arg1] = "Updated Value"
      }.not_to change {
        Radius::Spec::ModelFactory.templates["AnyClass"]
      }.from(
        arg1: "Any Value",
        arg2: "Any Other Value",
      )
    end

    it "freezes the registered attribute hash to prevent modification" do
      Radius::Spec::ModelFactory.factory "AnyClass", arg1: "Any Value"
      expect(Radius::Spec::ModelFactory.templates["AnyClass"]).to be_frozen
    end

    it "symbolizes attribute names" do
      expect {
        Radius::Spec::ModelFactory.factory(
          :AnyClass,
          "arg1" => "Any Value",
          "arg2" => "Any Other Value",
        )
      }.to change {
        Radius::Spec::ModelFactory.templates
      }.to(
        "AnyClass" => {
          arg1: "Any Value",
          arg2: "Any Other Value",
        }
      )
    end
  end

  describe "defining a factory", "via the catalog" do
    it "yields the catalog" do
      expect { |b|
        Radius::Spec::ModelFactory.catalog(&b)
      }.to yield_with_args(Radius::Spec::ModelFactory)
    end
  end
end
