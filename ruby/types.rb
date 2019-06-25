class MalType
  attr_reader :value

  def initialize(v)
    @value = v
  end
end

class MalList < MalType; end
class MalNum < MalType; end
class MalSymbol < MalType; end
class MalString < MalType; end
class MalBool < MalType; end
class MalNil < MalType; end
