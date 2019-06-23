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
  puts rep(buf)
end
