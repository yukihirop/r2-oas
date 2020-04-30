# frozen_string_literal: true

require 'digest/sha1'
require 'zlib'

require 'r2-oas/schema/manager/file_manager'

module R2OAS
  class Store
    attr_accessor :data

    def initialize(data = {})
      if data.empty?
        @data = {}
        @data['type'] = :schema
        @data['data'] = {}
      else
        @data = data
      end
    end

    def add(key, value, type = :schema)
      sha1 = calc_sha1(key, value)

      @data['data'][sha1] ||= {}
      @data['type'] = type
      @data['data'][sha1]['key'] = key
      @data['data'][sha1]['value'] = Zlib::Deflate.deflate(value)
    end

    def save
      type = @data['type']
      @data['data'].values.each do |value|
        case type
        when :schema
          save_path = value['key']
          save_data = Zlib::Inflate.inflate(value['value'])
          manager = Schema::FileManager.new(save_path, :full)
          manager.save(save_data)
          yield save_path
        end
      end
    end

    def delete
      type = @data['type']
      @data['data'].values.each do |value|
        case type
        when :schema
          delete_path = value['key']
          manager = Schema::FileManager.new(delete_path, :full)
          manager.delete
          yield delete_path
        end
      end
    end

    def dup_slice(*sha1s)
      dup_store = Store.new(@data.dup)
      dup_data = dup_store.data['data']
      dup_store.data['data'] = sha1s.each_with_object({}) { |sha1, data| data[sha1] = dup_data[sha1] if dup_store.key?(sha1) }
      dup_store
    end

    def checksum?
      @data['data'].each_with_object([]) do |(sha1, value), arr|
        child_key = value['key']
        child_value = Zlib::Inflate.inflate(value['value'])
        arr.push(sha1.eql? calc_sha1(child_key, child_value))
      end.all?
    end

    def key?(key)
      @data['data'].key?(key)
    end

    def exists?
      !@data['data'].empty?
    end

    private

    def calc_sha1(key, value)
      Digest::SHA1.hexdigest("#{key}\0#{value}")
    end

    class << self
      extend Forwardable

      def_delegators :instance, :data, :add, :slice, :checksum?, :exists?

      def create
        instance
      end

      private

      def instance
        @instance ||= new
      end
    end
  end
end
