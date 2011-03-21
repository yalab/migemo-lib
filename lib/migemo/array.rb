module Migemo
  class Alternation < Array
    def sort
      self.clone.replace(super)
    end

    def uniq
      self.clone.replace(super)
    end

    def map
      self.clone.replace(super {|x| yield(x)})
    end

    def delete_if
      self.clone.replace(super {|x| yield(x)})
    end

    def select
      self.clone.replace(super {|x| yield(x)})
    end
  end

  class Concatnation < Array
    def map
      self.clone.replace(super {|x| yield(x)})
    end
  end

  class CharClass < Array
  end
end
