require_relative "./boot"

def READ(arg)
  Reader.read_str(arg)
end

REPL_ENV = {
  "+" => -> (a,b) { a + b },
  "-" => -> (a,b) { a - b },
  "*" => -> (a,b) { a * b },
  "/" => -> (a,b) { a / b }
}

def eval_ast(ast, env)
  case ast
  when MalSymbol
    raise "Not found symobl: #{ast.value}" unless env.key?(ast.value)
    env[ast.value]
  when MalList
    ast.value.map { |v| EVAL(v, env) }
  when MalVector
    MalVector.new(ast.value.map { |v| EVAL(v, env) })
  when MalHash
    MalHash.new(ast.value.map.with_index { |v, i| i.even? ? v : EVAL(v, env)})
  else
    ast.value
  end
end

def EVAL(ast, env)
  MAL_LOGGER.info("--> #EVAL ast: #{ast.inspect}")
  return eval_ast(ast, env) if !ast.is_a?(MalList)
  return ast if ast.value.empty?

  list = eval_ast(ast, env)
  first, *args = list
  first.call(*args)
end

def PRINT(arg)
  Printer.pr_str(arg)
end

def rep(arg, env)
  PRINT(EVAL(READ(arg), env))
end

while buf = Readline.readline("user> ", true)
  begin
    MAL_LOGGER.info("--> start str: #{buf.inspect}")
    puts rep(buf, REPL_ENV)
  rescue => e
    MAL_LOGGER.error "e: #{e.inspect}"
    puts "Error: #{e}"
  ensure
    MAL_LOGGER.info("--> end\n")
  end
end
