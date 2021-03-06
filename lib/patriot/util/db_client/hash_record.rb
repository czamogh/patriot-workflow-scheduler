
module Patriot
  module Util
    module DBClient

      # a record implementation based on Hash
      class HashRecord < Patriot::Util::DBClient::Record

        # @param record [Hash]
        def initialize(record)
          @record = {}
          # ignore fixnum which is not column name
          record.each{|k,v| @record[k.to_sym] =  v unless k.is_a?(Fixnum)}
        end

        # @see Patriot::Util::DBClient::Record#get_id
        def get_id
          return @record[:id]
        end

        # @see Patriot::Util::DBClient::Record#to_mash
        def to_hash(keys = @record.keys)
          hash = {}
          keys.each{|k| hash[k] = @record[k]}
          return hash
        end

        # used as accessors
        def method_missing(mth, *args, &blk)
          key = mth
          type = :get
          if key.to_s.end_with?("=")
            key = key.to_s.slice(0..-2).to_sym
            type = :set
          end

          if type == :get
            if @record.has_key?(mth)
              return @record[mth] 
            else
              return nil
            end
          elsif type == :set
            @record[key] = args[0]
            return
          end
          super
        end

      end
    end
  end
end
