class Category

  attr_reader :name, :itens

  def initialize(name, itens)
    @name = name
    @itens = itens
  end
  
  def self.all
    db = SQLite3::Database.new("./mydatabase.db")
    db.execute("PRAGMA foreign_keys = ON")
    categories = db.execute("SELECT CATEGORY.ID, CATEGORY.NAME
                             FROM CATEGORY
                             INNER JOIN TB_DIARY_STUDY ON CATEGORY.ID = TB_DIARY_STUDY.ID_CATEGORY
                             GROUP BY CATEGORY.ID, CATEGORY.NAME")
    db.close
  
    categories
  end

  def self.find_by(id)
    db = SQLite3::Database.new("./mydatabase.db")
      db.execute("PRAGMA foreign_keys = ON")
      item = db.execute("SELECT  TB_DIARY_STUDY.ITEM,
        CATEGORY.NAME
        FROM 	TB_DIARY_STUDY
    inner join CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID) 
    WHERE ID_CATEGORY = ?", [id])
      db.close

    item
    end

    def self.total_access_count(id)
      count = 0
      items = Category.find_by(id)
      items.each do |item|
        acesso = StudyItem.find_itens(item[0])
        count += acesso[0][3]
      end 
      count

    end
  end