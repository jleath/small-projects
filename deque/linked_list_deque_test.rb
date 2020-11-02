load 'linked_list_deque.rb'

NUM_TEST_OPERATIONS = 100000
OPERATIONS = [:add_first, :add_last, :remove_first, :remove_last, :get]

linked_list = LinkedListDeque.new
array = []

NUM_TEST_OPERATIONS.times do 
  op = OPERATIONS.sample
  value = rand(1000)
  case op
  when :add_first
    linked_list.add_first(value)
    array.unshift(value)
  when :add_last
    linked_list.add_last(value)
    array.push(value)
  when :remove_first
    linked_list.remove_first unless linked_list.empty?
    array.shift unless array.empty?
  when :remove_last
    linked_list.remove_last unless linked_list.empty?
    array.pop unless array.empty?
  when :get
    unless linked_list.empty? && array.empty?
      index = rand(linked_list.size)
      if linked_list.get(index) != array[index]
        puts "Failure!"
        exit
      end
    end
  end
end

if linked_list.to_s == array.to_s
  puts "Success!"
else
  puts "Failure!"
end

