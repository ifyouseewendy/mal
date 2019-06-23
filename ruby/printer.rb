require_relative "./types"

class Printer
  def self.pr_str(mal_v)
    case mal_v
    when MalNum, MalSymbol
      mal_v.value
    when MalList
      content = mal_v.value.map { |v| pr_str v }.join(" ")
      "(" + content + ")"
    else
      raise "Don't know how to handle #{mal_v.inspect}"
    end
  end
end
