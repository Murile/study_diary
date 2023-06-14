class Category

  attr_reader :name, :itens

  def initialize(name, itens)
    @name = name
    @itens = itens
  end
  
  def self.all
    db = SQLite3::Database.new("./mydatabase.db")
    db.execute("PRAGMA foreign_keys = ON")
    categories = db.execute("SELECT * FROM CATEGORY")
    db.close

    categories
  end

  def self.find_by(id)
    print "Digite um id para a busca: "
    id = gets.chomp.to_i

    db = SQLite3::Database.new("./mydatabase.db")
    db.execute("PRAGMA foreign_keys = ON")
    item = db.execute("SELECT * FROM CATEGORY
                      WHERE ID = ?", [id])
    db.close
    end
end