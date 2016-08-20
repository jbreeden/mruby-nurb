require 'json'

factors = {
  # parent_state: [:resolved, :rejected],
  # parent_yield: [:scalar, :promise],
  chain_method: [:then, :catch, :bind],
  callback_result: [:returns, :raises],
  callback_yield: [:scalar, :promise]
}

def permutations(*lists)
  result = [[]]
  lists.each { |list|
    result = result.inject([]) { |acc, prev|
      list.each { |el|
        acc.push(prev.dup + [el])
      }
      acc
    }
  }
  result
end

scenarios = permutations(*factors.values)

puts 'scenarios = ['
scenarios.each_with_index { |scenario, i|
  print '  ' + JSON.generate(scenario)
  if scenarios[i + 1]
    puts ','
  else
    puts
  end
}
puts ']'
