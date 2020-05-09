# serialize.cr

> This project will probably never get finished. If you want to use it, you may ask me, but I probably won't continue working on this.

Provides easy serialization of arbitrary complex objects in JSON/Yaml and Messagepack.
This uses the [msgpack-crystal](https://github.com/crystal-community/msgpack-crystal) library by crystal-community.

## What is working
- Full [de-]serialization of instances containing one of
  + Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64
  + Bool
  + Float
  + Nil
  + String
  + Arrays / Hashes / Tuples / Slices of these
  into / from YAML and MessagePack

## Missing
- JSON support

- NamedTuple (Not possible because I can not get the types of the NT)
- Time[::Format]
- Symbol


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  serialize.cr:
    github: vypxl/serialize.cr
```

## Usage

```crystal
require "serialize.cr"

yaml = obj.ser_yaml # serialize to YAML
mp = obj.ser_msgpack # serialize to MessagePack

new_from_yaml = Obj.deser_yaml yaml # deserialize from YAML
new_from_msgpack = Obj.deser_msgpack mp # deserialize from MessagePack
```

## Contributors

- [vypxl](https://github.com/vypxl) - creator, maintainer
