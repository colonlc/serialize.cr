require "yaml"
require "json"
require "msgpack"
require "./primitives.cr"

module Serializable
  def to_ser_hash
    hash = {% begin %} {
      "type" => {{ @type.id.stringify }},
    {% for ivar in @type.instance_vars %}
      "{{ivar.id}}" => @{{ ivar.id }}.to_ser_hash,
    {% end %} } {% end %}
  end

  def to_yaml
    to_ser_hash.to_yaml
  end

  def to_json
    to_ser_hash.to_json
  end

  def to_msgpack
    to_ser_hash.to_msgpack
  end

  def initialize(hash)
    {% for ivar in @type.instance_vars %}
      @{{ ivar.id }} = {{ ivar.type.id }}.from_ser_hash hash[{{ ivar.id.stringify }}]
    {% end %}
  end

  macro included
    def self.from_ser_hash(hash) : {{ @type.id }}
      instance = allocate
      instance.initialize(hash)

      GC.add_finalizer(instance) if instance.responds_to?(:finalize)
      instance
    end

    def self.from_yaml(string_or_io : String | IO)
      from_ser_hash YAML.parse(string_or_io)
    end

    def self.from_json(string_or_io : String | IO)
      from_yaml JSON.parse(string_or_io).as_h.to_yaml
    end

    def self.from_msgpack(string_or_io : String | IO)
      # puts Serializable.conv(MessagePack::Unpacker.new(string_or_io).read_hash["string"], Hash)["type"]
      from_yaml MessagePack::Unpacker.new(string_or_io).read_hash.to_yaml
    end

    def self.from_msgpack(bytes : Bytes)
      from_msgpack IO::Memory.new(bytes)
    end
  end # End macro included
end # End module Serializable
