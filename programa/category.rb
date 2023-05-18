class Category
    attr_reader :name, :itens
  
    def initialize(name, itens)
      @name = name
      @itens = itens
    end
end