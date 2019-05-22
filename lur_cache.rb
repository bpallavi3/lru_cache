class Node
  attr_accessor :key, :value, :front, :next
end

class LruCache
  attr :register, :head, :tail, :limit

  def initialize(limit)
    @register = Hash.new
    @head = nil
    @limit = limit
    @tail = nil
  end

  def put(key,value)
    if @register && @register[key]
      p "Already present cannot be added again!!"
    else
      #
      # If element doesnt exist in cache
      # then add to mru position
      #

      #
      # Create the node
      #
      n = Node.new
      n.key = key
      n.value = value
      #
      # Initialization condition when only 1 node
      # exists in the cache
      #
      if @head == nil
        @head = n
        @tail = n
      else
        #
        # New node always is the most recently used node
        #
        append_to_cache(n)
      end
      @register[key] = n
      #
      # If addition of the new node to cache surpassed
      # the limit of the cache, delete the lru node
      #
      if (@register.keys.length > @limit)
        delete_tail_node
      end
    end
    display
  end

  def append_to_cache(n)
    n.front = nil
    temp = @head
    temp.front = n
    @head = n
    @head.next = temp
  end

  def delete_tail_node
    p "EVICTING: " + @tail.key.to_s
    @register.delete(@tail.key)
    #
    # least recently used node is always the tail,
    # hence should delete tail
    #
    @tail = @tail.front
    @tail.next = nil
  end

  def remove_from_cache(node)
    node.front.next = node.next if node.front
    if @tail == node
      @tail = node.front
    end
  end

  def get(key)
    if @register[key]
      #
      # If the node exists , its the most recently accessed
      # hence should move to the top of the list
      #
      node = @register[key]
      remove_from_cache(node)
      append_to_cache(node)
      return node.value.to_s
    else
      #
      # Key not found
      #
      return -1
    end
  end

  def display
    p "-------------------------------"
    node = @head
    while node != nil
      p "{" + node.key.to_s + " : " +
        node.value.to_s + ", Front:" +
        ( node.front ? node.front.key.to_s : "") + ", Next:" +
        ( node.next ? node.next.key.to_s : "") + "}"
      node = node.next
    end
    p "Head : " + (@head ? @head.value.to_s : "")
    p "Tail : " + (@tail ? @tail.value.to_s : "")
    p "-------------------------------"
  end
end

cache = LruCache.new(2)
cache.put(1, 1)
cache.put(2, 2)
p "returned value : " + cache.get(1).to_s       # returns 1
cache.put(3, 3)                                 # evicts key 2
p "returned value : " + cache.get(2).to_s       # returns -1 (not found)
cache.put(4, 4)                                 # evicts key 1
p "returned value : " + cache.get(1).to_s       # returns -1 (not found)
p "returned value : " + cache.get(3).to_s       # returns 3
p "returned value : " + cache.get(4).to_s
cache.display
