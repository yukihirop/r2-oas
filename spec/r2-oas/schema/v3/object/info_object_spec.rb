# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::InfoObject do
  let(:object) { R2OAS.use_object_classes[:info_object].new }

  describe '#to_doc' do
    context 'when use before_create && after_create' do
      before do
        class TestInfoObject < R2OAS::Schema::V3::InfoObject
          before_create do |doc|
            doc.merge!(
              'before_key' => 'before_value'
            )
          end

          after_create do |doc|
            doc.merge!(
              'after_key' => 'after_value'
            )
          end
        end

        R2OAS.configure do |config|
          config.use_object_classes.merge!(
            info_object: TestInfoObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end
  end

  describe '#create_doc' do
    it do
      expect(object.create_doc).to eq 'title' => 'OAS API Document Title',
                                      'description' =>
          "This is a sample server Petstore server.  You can find out more about\n            Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net,\n            #swagger](http://swagger.io/irc/).  For this sample, you can use the api key\n            `special-key` to test the authorization filters.",
                                      'termsOfService' => 'http://swagger.io/terms/',
                                      'contact' => { 'name' => '', 'url' => '' },
                                      'license' => { 'name' => '', 'url' => '' },
                                      'version' => '1.0.0'
    end
  end
end
