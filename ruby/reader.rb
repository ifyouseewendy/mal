require_relative "./mal_logger"
require_relative "./types"

class Reader
  # [\s,]*              - Ignore whitespaces and commas
  # ~@                  - Captures the special two-characters ~@
  # [\[\]{}()'`~^@]     - Captures any special single character, one of []{}()'`~^@
  # "(?:\\.|[^\\"])*"?  - Starts capturing at a double-quote and stops at the next double-quote
  #                       unless it was preceded by a backslash in which case it includes it until
  #                       the next double-quote
  # ;.*                 - Captures any sequence of characters starting with ;
	# [^\s\[\]{}('"`,;)]* - Captures a sequence of zero or more non special characters (e.g. symbols,
  #                       numbers, "true", "false", and "nil")
  TOKEN_REGEX = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/

  class << self
    def read_str(str)
      new(tokenize(str)).read_form
    end

    def tokenize(str)
      tokens = []
      p = 0

      loop do
        break if p >= str.length

        m = TOKEN_REGEX.match(str[p..-1])

        t = m.captures.first.to_s
        tokens << t unless t.empty?
        p += m.to_s.length
      end

      MAL_LOGGER.info("#tokenize: #{tokens.map(&:inspect).join(' ')}")
      tokens
    end
  end

  attr_reader :tokens, :position

  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def read_form
    case _peek
    when "(", "["
      read_list
    else
      read_atom
    end
  end

private

  def _next
    _peek.tap { @position += 1 }
  end

  def _peek
    raise "EOF encountered" if position == tokens.length
    tokens[position]
  end

  def read_list
    res = []
    loop do
      _next
      t = _peek

      break if t == ")" || t == "]"

      res << read_form
    end

    MalList.new(res)
  end

  def read_atom
    t = _peek
    case t
    when "nil"
      MalNil.new(t)
    when "true", "false"
      MalBool.new(t)
    when /^[\-]?\d+$/
      MalNum.new(t.to_i)
    when /^".*"$/
      # v = t.gsub(/\\./, {"\\\\" => "\\", "\\n" => "\n", "\\\"" => '"'})
      # MAL_LOGGER.info "v: #{v.inspect}"
      MalString.new(t)
    when /^".*$/
      raise "unbalanced quotes"
    when /^[-|>|\w]+$/
      MalSymbol.new(t)
    when /^[\+\-\*\/]+$/
      MalSymbol.new(t)
    else
      MAL_LOGGER.error("#read_atom: Don't know how to handle token: #{t.inspect}")
    end
  end
end
