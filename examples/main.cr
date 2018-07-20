require "../src/**"

class Container
  include Serializable

  @bytes : Bytes

  @@classvar = [1,2,3,4,5]

  def initialize
    @string = "container"
    @uint = 1u64
    @array = [A.new(1u8), A.new(2u8)]
    @array2 = [A.new(3u8), B.new("Hello world!")]
    @hash = {
      "one" => Generic(UInt16).new(99u16),
      "arr" => Generic(Array(Generic(A) | Generic(B))).new([
        Generic(B).new(B.new("generics!")),
        Generic(A).new(A.new(5u8))
      ])
    }
    @tuple1 = { "tuple1" }
    @tuple2 = { "tuple2", 999}
    @tuple3 = { "tuple3", 3u64, nil }
    @enum = C::Lol
    @allenum = [C::Lol, C::Rofl, C::Lmao]
    @bytes = IO::Memory.new("01234").to_slice
    # @sym = :symbols
    # @time = Time.now
    # @ntuple = { a: "ntuple", b: 7, c: nil, d: A.new(9u8)}
  end
end

class A
  include Serializable

  def initialize(@uint8 : UInt8)
  end
end

struct B
  include Serializable

  @@lol = 1337

  def initialize(@string : String)
  end
end

enum C
  Lol
  Rofl
  Lmao
end

class Generic(T)
  include Serializable

  def initialize(@t : T)
  end
end

# Test code

obj = Container.new
yaml = obj.ser_yaml

puts "Correct serialization and deserialization with YAML: #{ Container.deser_yaml(obj.ser_yaml).ser_yaml == yaml }"
puts "Correct serialization and deserialization with MessagePack: #{ Container.deser_msgpack(obj.ser_msgpack).ser_yaml == yaml }"

# yaml = Container.ser_class_yaml
#
# Container.load_class_yaml yaml
# puts Container.ser_class_yaml == yaml
#
# Container.load_class_msgpack Container.ser_class_msgpack
# puts Container.ser_class_yaml == yaml

# TODO

# NamedTuple, Time[::Format], Symbols
# Classvars

# Benchmarks
# Tests
