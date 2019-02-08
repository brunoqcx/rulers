require "multi_json"
require 'json'

module Rulers
  module Model
    class FileModel
      attr_reader :hash

      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]

        @id = File.basename(basename, ".json").to_i

        obj = File.read("db/quotes/#{@id}.json")
        @hash = MultiJson.load(obj)  
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin 
          FileModel.new("db/quotes/#{id}.json")
        rescue
          return nil
        end
      end

      def self.all
        files = Dir['db/quotes/*.json']
        files.map { |file|  FileModel.new file }
      end

      def self.create(attrs)
        hash = attrs.slice("submitter", "quote", "attribution")

        files = Dir['db/quotes/*.json']
        names = files.map { |f| File.split(f)[-1] }
        highest = names.map { |b| b.to_i }.max
        new_id = highest + 1

        File.write("db/quotes/#{new_id}.json", hash.to_json)

        FileModel.new("db/quotes/#{new_id}.json")
      end

      def self.update(id)
        model = FileModel.find(id)
        model['submitter'] = 'outro_cara'

        File.write("db/quotes/#{id}.json", model.hash.to_json)
        
        FileModel.new("db/quotes/#{id}.json")
      end
    end
  end
end