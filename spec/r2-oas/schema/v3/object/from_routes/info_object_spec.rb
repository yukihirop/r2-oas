# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::InfoObject do
  let(:opts) { {} }
  let(:object) { described_class.new(opts) }

  describe '#create_doc (private)' do
    it do
      expect(object.send(:create_doc)).to eq 'title' => 'OAS API Document Title',
                                             'description' =>
          "This is a sample server Petstore server.  You can find out more about\n            Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net,\n            #swagger](http://swagger.io/irc/).  For this sample, you can use the api key\n            `special-key` to test the authorization filters.",
                                             'termsOfService' => 'http://swagger.io/terms/',
                                             'contact' => { 'name' => '', 'url' => '' },
                                             'license' => { 'name' => '', 'url' => '' },
                                             'version' => '1.0.0'
    end
  end
end
