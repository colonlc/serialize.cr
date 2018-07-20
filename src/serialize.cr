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

  def ser_yaml
    to_ser_hash.to_yaml
  end

  # def ser_json
  #   to_ser_hash.to_json
  # end

  def ser_msgpack
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

    def self.deser_yaml(string_or_io : String | IO)
      from_ser_hash YAML.parse(string_or_io)
    end

    # def self.deser_json(string_or_io : String | IO)
    #   deser_yaml JSON.parse(string_or_io).to_yaml # IDN, cannot convert the JSON Hash to YAML..
    # end

    def self.deser_msgpack(string_or_io : String | IO)
      deser_yaml MessagePack::Unpacker.new(string_or_io).read_hash.to_yaml
    end

    def self.deser_msgpack(bytes : Bytes)
      deser_msgpack IO::Memory.new(bytes)
    end

    #############
    # Classvars #
    #############

    # def to_class_ser_hash
    #   hash = {% begin %} {
    #     "type" => "CLASS_" + {{ @type.id.stringify }},
    #   {% for cvar in @type.class.instance_vars %}
    #     "{{cvar.id}}" => @{{ cvar.id }}.to_ser_hash,
    #   {% end %} } {% end %}
    # end
    
    # def ser_class_yaml
    #   to_class_ser_hash.to_yaml
    # end

    # # def ser_class_json
    # #   to_class_ser_hash.to_json
    # # end

    # def ser_class_msgpack
    #   to_class_ser_hash.to_msgpack
    # end

    ################################
    # Loading serialized classvars #
    ################################

    # def self.load_class_ser_hash(hash)
    #   {% for cvar in @type.class.instance_vars %}
    #     @{{ cvar.id }} = {{ cvar.type.id }}.from_ser_hash hash[{{ cvar.id.stringify }}]
    #   {% end %}
    # end

    # def self.load_class_yaml(string_or_io : String | IO)
    #   load_class_ser_hash YAML.parse(string_or_io)
    # end

    # # def self.load_class_json(string_or_io : String | IO)
    # #   load_class_ser_hash JSON.parse(string_or_io).to_yaml # IDN, cannot convert the JSON Hash to YAML..
    # # end

    # def self.load_class_msgpack(string_or_io : String | IO)
    #   load_class_yaml MessagePack::Unpacker.new(string_or_io).read_hash.to_yaml
    # end

    # def self.load_class_msgpack(bytes : Bytes)
    #   load_class_msgpack IO::Memory.new(bytes)
    # end
  end # End macro included
end # End module Serializable
