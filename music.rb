require 'pstore'

# Initialize the store.
# The file will be created if it doesn't exist.

store = PStore.new('store.pstore')
puts store.inspect

# Load data from the store.
#data = Hash.new
data = store.transaction { store[:data] }
# We could also use store.fetch, which does the same as Hash#fetch:
# Return the value if it exists, otherwise return the default value.
# data = store.transaction { store.fetch(:data, 'default value') }

# Do something with the data.
#data['a'] = 1
#data['b'] = 2


data.each do |key, value|
    puts "#{key} : #{value}"
end


store.transaction do
  # Save the data to the store.
  store[:data] = data

  # Oh wait, let's check something first, and if it's
  # not what we expect, abort the transaction and don't
  # write anything to the store.
  # store.abort unless is_this_thing_on?

  # Another option is to commit early, which also returns
  # from the transaction, but writes what you have done
  # so far. In this case, store[:data] would be written
  # but store[:last_run] would not.
  store.commit # if lets_commit_it

  # Save the current time so next time
  # you know when this was last run.
  store[:last_run] = Time.now
end

puts 'finished'