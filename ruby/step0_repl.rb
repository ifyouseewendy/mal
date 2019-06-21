require_relative "./readline"

def READ(arg, *_)
  arg
end

def EVAL(arg, *_)
  arg
end

def PRINT(arg, *_)
  arg
end

def rep(*args)
  PRINT(EVAL(READ(*args)))
end

# loop do
#   print "user> "
#
#   line = gets
#   break if line.nil?
#
#   puts rep(line)
# end

while buf = Readline.readline("user> ", true)
  puts rep(buf)
end
