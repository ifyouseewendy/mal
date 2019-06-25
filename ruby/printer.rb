require_relative "./types"

class Printer
  def self.pr_str(mal_v, print_readably: true)
    case mal_v
    when MalList
      content = mal_v.value.map { |v| pr_str v }.join(" ")
      "(" + content + ")"
    else
      mal_v.value
    end
  end
end
