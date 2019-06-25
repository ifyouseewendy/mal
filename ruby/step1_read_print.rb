require_relative "./boot"

def READ(arg)
  Reader.read_str(arg)
end

def EVAL(arg)
  arg
end

def PRINT(arg)
  Printer.pr_str(arg)
end

def rep(arg)
  PRINT(EVAL(READ(arg)))
end

while buf = Readline.readline("user> ", true)
  begin
    MAL_LOGGER.info("--> start str: #{buf.inspect}")
    puts rep(buf)
  rescue => e
    MAL_LOGGER.error "e: #{e.inspect}"
    puts "Error: #{e}"
  ensure
    MAL_LOGGER.info("--> end\n")
  end
end
