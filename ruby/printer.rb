require_relative "./types"

class Printer
  def self.pr_str(mal_v, print_readably: true)
    case mal_v
    when MalList
      content = mal_v.value.map { |v| pr_str v }.join(" ")
      "(" + content + ")"
    when MalVector
      content = mal_v.value.map { |v| pr_str v }.join(" ")
      "[" + content + "]"
    when MalHash
      content = mal_v.value.map { |v| pr_str v }.join(" ")
      "{" + content + "}"
    when MalType
      mal_v.value
    else
      mal_v
    end
  end
end
