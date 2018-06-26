# require "yaml"
# require "json"

require "../src/**"

class Container
  include Serializable

  # @union : (String | A | B).class
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
    @ntuple = { a: "ntuple", b: 7, c: nil, d: A.new(9u8)}
    @enum = C::Lol
    @allenum = [C::Lol, C::Rofl, C::Lmao]
    @time = Time.now
    @bytes = IO::Memory.new("01234").to_slice
  end
end

class A
  include Serializable

  def initialize(@uint8 : UInt8)
  end
end

struct B
  include Serializable

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

# obj = Container.new
# yaml = obj.to_yaml

# puts Container.from_yaml(obj.to_yaml).to_yaml == yaml
# puts Container.from_json(obj.to_json).to_yaml == yaml
# puts Container.from_msgpack(obj.to_msgpack).to_yaml == yaml

puts NamedTuple(name: String, year: Int32).from_ser_hash({name: "Crystal", year: 2011}.to_ser_hash)
# puts ({name: "Crystal", year: 2011}).to_ser_hash.class

# TODO

# from_ser_hash without only YAML::Any

# Enum, Union, NamedTuple, Time[::Format]
# Classvars

# Benchmarks
# Tests
