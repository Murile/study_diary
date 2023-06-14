class StudyItem

  attr_reader :title, :category

    def initialize(title, category)
      @title = title
      @category = category
    end

    def self.all
      db  =SQLite3::Database.new("./mydatabase.db")
      items = db.execute("SELECT  TB_DIARY_STUDY.ITEM,
      CATEGORY.NAME
      FROM 	TB_DIARY_STUDY
  
     inner join CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID)")
      db.close

      items
    end

    def self.find_by(id)
      print "Digite um id para a busca: "
      id = gets.chomp.to_i
  
      db = SQLite3::Database.new("./mydatabase.db")
      db.execute("PRAGMA foreign_keys = ON")
      item = db.execute("SELECT TB_DIARY_STUDY.ITEM, CATEGORY.NAME
                        FROM TB_DIARY_STUDY
                        INNER JOIN CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID)
                        WHERE TB_DIARY_STUDY.ID = ?", [id])
      db.close
      end
end

