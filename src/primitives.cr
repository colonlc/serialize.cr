{% for t in [Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64] %}
  struct {{ t }}
    def to_ser_hash
      {
        "type" => \{{ @type.id.stringify }},
        "value" => self.to_i64
      }
    end

    def self.from_ser_hash(hash) : {{ t }}
      if hash["type"] == \{{ @type.id.stringify }}
        self.new(hash["value"].as_i64)
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  end
{% end %}

{% for t in [Bool, Float, Nil] %}
  struct {{ t }}
    def to_ser_hash
      {
        "type" => \{{ @type.id.stringify }},
        "value" => self
      }
    end

    def self.from_ser_hash(hash) : {{ t }}
      if hash["type"] == \{{ @type.id.stringify }}
        hash["value"]
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  end
{% end %}

{% for t in [String] %}
  class {{ t }}
    def to_ser_hash
      {
        "type" => \{{ @type.id.stringify }},
        "value" => self
      }
    end

    def self.from_ser_hash(hash) : {{ t }}
      if hash["type"] == \{{ @type.id.stringify }}
        hash["value"].as_s
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  end
{% end %}

class Array
  def to_ser_hash
    {
        "type" => {{ @type.id.stringify }},
        "value" => map &.to_ser_hash
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : {{ @type.id }}
      if hash["type"] == \{{ @type.id.stringify }}
        \{% if T.union? %}
          res = hash["value"].as_a.map do |v|
            found = nil
            \{{ T.union_types }}.each do |itype|
              # puts "arr", itype, v
              found = itype.from_ser_hash v if found == nil
            rescue
            end

            if found.is_a? T
              found
            else
              raise "Invalid parse type: expected any of #{T}, got #{hash["type"].class}"
            end
          end

          return res if res.is_a? {{ @type.id }}
          raise "not reached"
          {{ @type.id }}.new
        \{% else %}
          res = hash["value"].as_a.map do |v|
            T.from_ser_hash(v)
          end

          return res if res.is_a? {{ @type.id }}
          raise "not reached"
          {{ @type.id }}.new
        \{% end %}
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
        {{ @type.id }}.new # never reached
      end
    end
  {% end %}
end

class Hash
  def to_ser_hash
    {
      "type" => {{ @type.id.stringify }},
      "value" => [keys.to_ser_hash, values.to_ser_hash]
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : {{ @type.id }}
      if hash["type"] == \{{ @type.id.stringify }}
        Hash.zip(
          Array(K).from_ser_hash(hash["value"][0]),
          Array(V).from_ser_hash(hash["value"][1])
        )
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  {% end %}
end

struct Tuple
  def to_ser_hash
    {
      "type" => {{ @type.id.stringify }},
      "value" => to_a.to_ser_hash
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : self
      if hash["type"] == \{{ @type.id.stringify }}
        arr = Array(Union(*T)).from_ser_hash(hash["value"])
        return self.from(arr)
        raise "not reached"
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  {% end %}
end

struct NamedTuple
  def to_ser_hash
    {
      "type" => {{ @type.id.stringify }},
      "value" => to_h.to_ser_hash
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : self
      if hash["type"] == \{{ @type.id.stringify }}
        hash = \{% begin %}Hash(Symbol, \{% begin %}Union(\{% for key, typ in T %}\{{typ}},\{% end %})\{% end %})\{% end %}.from_ser_hash(hash["value"])
        return self.from(hash)
        raise "not reached"
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  {% end %}
end

struct Symbol
  def to_ser_hash
    {
      "type" => {{ @type.id.stringify }},
      "value" => to_i
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : self
      if hash["type"] == \{{ @type.id.stringify }}
        hash["value"].as_i
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  {% end %}
end

struct Enum
  def to_ser_hash
    {
      "type" => {{ @type.id.stringify }},
      "value" => value
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : self
      if hash["type"] == \{{ @type.id.stringify }}
        from_value(hash["value"].as_i)
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  {% end %}
end

struct Slice
  def to_ser_hash
    {
      "type" => {{ @type.id.stringify }},
      "value" => to_a.to_ser_hash
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : self
      if hash["type"] == \{{ @type.id.stringify }}
        arr = Array(T).from_ser_hash(hash["value"])
        return self.new(arr.to_unsafe, sizeof(T) * arr.size)
        raise "not reached"
      else
        raise "Invalid parse type: expected {{ @type.id
         }}, got #{hash["type"]}"
      end
    end
  {% end %}
end

struct Time
  def to_ser_hash
    {
      "type" => {{ @type.id.stringify }},
      "value" => Time::Format.new("%F %X.%L %:z").format(self)
    }
  end

  {% begin %}
    def self.from_ser_hash(hash) : self
      if hash["type"] == \{{ @type.id.stringify }}
        hash["value"].as_time
      else
        raise "Invalid parse type: expected {{ @type.id }}, got #{hash["type"]}"
      end
    end
  {% end %}
end
