# serialize.cr

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
    github: colonlc/serialize.cr
```

## Usage

```crystal
require "serialize.cr"

yaml = obj.ser_yaml # serialize to YAML
mp = obj.ser_msgpack # serialize to MessagePack

new_from_yaml = Obj.deser_yaml yaml # deserialize from YAML
new_from_msgpack = Obj.deser_msgpack mp # deserialize from MessagePack
```

## Contributing

I appreciate any help because I got little time for this project.

1. Fork it ( https://github.com/colonlc/serialize.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Colonlc](https://github.com/colonlc) Colonlc - creator, maintainer
